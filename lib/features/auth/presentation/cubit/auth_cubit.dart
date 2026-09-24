import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/result.dart';
import '../../data/models/user_model.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required SendOtpUseCase sendOtpUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required GetProfileUseCase getProfileUseCase,
    UpdateProfileUseCase? updateProfileUseCase,
  }) : _sendOtpUseCase = sendOtpUseCase,
       _verifyOtpUseCase = verifyOtpUseCase,
       _registerUseCase = registerUseCase,
       _logoutUseCase = logoutUseCase,
       _checkAuthStatusUseCase = checkAuthStatusUseCase,
       _getProfileUseCase = getProfileUseCase,
       _updateProfileUseCase = updateProfileUseCase,
       super(const AuthInitial());

  final SendOtpUseCase _sendOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase? _updateProfileUseCase;

  /// Checks if a session is currently active.
  /// Does NOT eagerly fetch profile on startup if not needed.
  Future<void> checkStatus() async {
    final isAuth = await _checkAuthStatusUseCase();
    if (isAuth) {
      final profileResult = await _getProfileUseCase();
      switch (profileResult) {
        case Success(:final data):
          emit(AuthAuthenticated(data));
        case Error():
          emit(const AuthUnauthenticated());
      }
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  /// Sends OTP to the provided [phone] number.
  Future<void> sendOtp({required String phone, String? email}) async {
    emit(const AuthLoading());
    final result = await _sendOtpUseCase(phone: phone);
    switch (result) {
      case Success(:final data):
        emit(AuthOtpSent(phone: phone, message: data, email: email));
      case Error(:final failure):
        emit(AuthError(failure.message));
    }
  }

  /// Resends OTP without navigating away.
  Future<void> resendOtp({required String phone, String? email}) async {
    final result = await _sendOtpUseCase(phone: phone);
    switch (result) {
      case Success(:final data):
        emit(AuthOtpSent(phone: phone, message: data, email: email));
      case Error(:final failure):
        emit(AuthError(failure.message));
    }
  }

  /// Verifies the entered [otp].
  Future<void> verifyOtp({
    required String phone,
    required String otp,
    required String fcmToken,
  }) async {
    emit(const AuthLoading());
    final result = await _verifyOtpUseCase(
      phone: phone,
      otp: otp,
      fcmToken: fcmToken,
    );
    switch (result) {
      case Success(:final data):
        emit(AuthAuthenticated(data));
      case Error(:final failure):
        emit(AuthError(failure.message));
    }
  }

  /// Registers a new user account.
  Future<void> register({
    required String name,
    required String email,
    required String phone,
  }) async {
    emit(const AuthLoading());
    final result = await _registerUseCase(
      name: name,
      email: email,
      phone: phone,
    );
    switch (result) {
      case Success():
        emit(
          AuthOtpSent(
            phone: phone,
            email: email,
            message: 'Registration submitted. Please verify the OTP sent.',
          ),
        );
      case Error(:final failure):
        emit(AuthError(failure.message));
    }
  }

  /// Logs out the user and clears secure session storage.
  Future<void> logout() async {
    emit(const AuthLoading());
    await _logoutUseCase();
    emit(const AuthUnauthenticated());
  }

  /// Fetches current user profile from backend.
  Future<void> fetchProfile() async {
    final result = await _getProfileUseCase();
    if (result is Success<UserModel>) {
      emit(AuthAuthenticated(result.data));
    }
  }

  /// Updates user profile details (name, email, profile image).
  Future<bool> updateProfile({
    required String name,
    required String email,
    String? profileImage,
  }) async {
    if (_updateProfileUseCase == null) return false;
    emit(const AuthLoading());
    final result = await _updateProfileUseCase(
      name: name,
      email: email,
      profileImage: profileImage,
    );
    switch (result) {
      case Success(:final data):
        emit(AuthAuthenticated(data));
        return true;
      case Error(:final failure):
        emit(AuthError(failure.message));
        return false;
    }
  }

  /// Resets state back to initial (e.g. after showing an error toast).
  void reset() {
    emit(const AuthInitial());
  }
}
