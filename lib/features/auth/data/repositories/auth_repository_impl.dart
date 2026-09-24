import '../../../../core/constants/app_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/api_message_cleaner.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({ApiClient? apiClient, StorageService? storageService})
    : _apiClient = apiClient ?? ApiClient.instance,
      _storageService = storageService ?? StorageService.instance;

  final ApiClient _apiClient;
  final StorageService _storageService;

  //. Send OTP
  @override
  Future<Result<String>> sendOtp({required String phone}) async {
    try {
      final response = await _apiClient.post(
        AppEndpoints.sendOtp,
        data: {'phone': phone},
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final isSuccess = _isStatusSuccessful(data);
        if (isSuccess) {
          final message =
              data['message']?.toString() ?? 'OTP Sent Successfully';
          return Success(message);
        } else {
          final message = cleanApiMessage(
            data['message'] ?? data['error'] ?? 'Failed to send OTP',
          );
          return Error(ServerFailure(message));
        }
      }
      return const Error(ServerFailure('Invalid server response'));
    } on AppException catch (e) {
      return Error(e.toFailure());
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  //. Verify OTP
  @override
  Future<Result<UserModel>> verifyOtp({
    required String phone,
    required String otp,
    required String fcmToken,
  }) async {
    try {
      final response = await _apiClient.post(
        AppEndpoints.verifyOtp,
        data: {'phone': phone, 'otp': otp, 'fcm_token': fcmToken},
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final isSuccess = _isStatusSuccessful(data);
        final token = _extractToken(data);

        if (isSuccess && token != null && token.isNotEmpty) {
          await _storageService.setAccessToken(token);
          await _storageService.setLoggedIn(value: true);
          if (fcmToken.isNotEmpty) {
            await _storageService.setFcmToken(fcmToken);
          }

          UserModel user;
          try {
            user = UserModel.fromApiResponse(data);
          } catch (_) {
            user = UserModel(id: 0, name: '', phone: phone);
          }

          if (user.name.isNotEmpty) {
            await _storageService.setUserName(user.name);
          }
          return Success(user);
        } else {
          final rawMsg = cleanApiMessage(
            data['message'] ??
                data['error'] ??
                'Invalid OTP. Please try again.',
          );
          return Error(ServerFailure(rawMsg));
        }
      }
      return const Error(
        ServerFailure('Invalid verification response from server'),
      );
    } on AppException catch (e) {
      return Error(e.toFailure());
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  //. Register User
  @override
  Future<Result<UserModel>> register({
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      final response = await _apiClient.post(
        AppEndpoints.register,
        data: {'name': name, 'email': email, 'phone': phone},
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final isSuccess = _isStatusSuccessful(data);
        if (isSuccess) {
          final token = _extractToken(data);
          if (token != null && token.isNotEmpty) {
            await _storageService.setAccessToken(token);
            await _storageService.setLoggedIn(value: true);
          }

          UserModel user;
          try {
            user = UserModel.fromApiResponse(data);
          } catch (_) {
            user = UserModel(id: 0, name: name, phone: phone, email: email);
          }

          if (name.isNotEmpty) {
            await _storageService.setUserName(name);
          }
          return Success(user);
        } else {
          final rawMsg = cleanApiMessage(
            data['message'] ?? data['error'] ?? 'Registration failed',
          );
          return Error(ServerFailure(rawMsg));
        }
      }
      return const Error(
        ServerFailure('Invalid registration response from server'),
      );
    } on AppException catch (e) {
      return Error(e.toFailure());
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  //. Get Profile
  @override
  Future<Result<UserModel>> getProfile() async {
    try {
      final response = await _apiClient.get(AppEndpoints.profile);
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final user = UserModel.fromApiResponse(data);
        if (user.name.isNotEmpty) {
          await _storageService.setUserName(user.name);
        }
        return Success(user);
      }
      return const Error(ServerFailure('Failed to fetch profile'));
    } on AppException catch (e) {
      return Error(e.toFailure());
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  //. Update Profile
  @override
  Future<Result<UserModel>> updateProfile({
    required String name,
    required String email,
    String? profileImage,
  }) async {
    try {
      final response = await _apiClient.postMultipart(
        AppEndpoints.updateProfile,
        fields: {'name': name, 'email': email},
        fileKey: 'profile_image',
        filePath: profileImage,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final user = UserModel.fromApiResponse(data);
        if (user.name.isNotEmpty) {
          await _storageService.setUserName(user.name);
        }
        return Success(user);
      }
      return const Error(ServerFailure('Failed to update profile'));
    } on AppException catch (e) {
      return Error(e.toFailure());
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  //. Logout
  @override
  Future<Result<void>> logout() async {
    try {
      await _apiClient.post(AppEndpoints.logout);
    } catch (_) {
      // Even if API logout fails, clear local tokens
    } finally {
      await _storageService.clearOnLogout();
    }
    return const Success(null);
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _storageService.getAccessToken();
    return _storageService.isLoggedIn && token != null && token.isNotEmpty;
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  bool _isStatusSuccessful(Map<String, dynamic> data) {
    final status = data['status'];
    final success = data['success'];
    final statusCode = data['statusCode'];

    if (status == false || status == 'false' || status == 0 || status == '0') {
      return false;
    }
    if (success == false ||
        success == 'false' ||
        success == 0 ||
        success == '0') {
      return false;
    }

    return status == true ||
        status == 'true' ||
        status == 1 ||
        success == true ||
        success == 'true' ||
        statusCode == 200 ||
        data.containsKey('token') ||
        data.containsKey('access_token');
  }

  String? _extractToken(Map<String, dynamic> data) {
    if (data['token'] != null &&
        data['token'].toString().isNotEmpty &&
        data['token'].toString() != 'null') {
      return data['token'].toString();
    }
    if (data['access_token'] != null &&
        data['access_token'].toString().isNotEmpty &&
        data['access_token'].toString() != 'null') {
      return data['access_token'].toString();
    }
    if (data['data'] is Map) {
      final nested = data['data'] as Map;
      if (nested['token'] != null &&
          nested['token'].toString().isNotEmpty &&
          nested['token'].toString() != 'null') {
        return nested['token'].toString();
      }
    }
    return null;
  }
}
