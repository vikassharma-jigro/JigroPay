import '../../../../core/constants/app_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/api_message_cleaner.dart';
import '../../domain/repositories/pan_service_repository.dart';

class PanServiceRepositoryImpl implements PanServiceRepository {
  PanServiceRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  final ApiClient _apiClient;

  @override
  Future<Result<String>> initiatePanApplication({
    required String mobileNumber,
  }) async {
    try {
      final response = await _apiClient.post(
        AppEndpoints.nsdlNewPan,
        data: {
          'mobile_number': mobileNumber,
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final status = data['status'];
        final isSuccess = status == true ||
            status == 'Success' ||
            status == 'success' ||
            data['success'] == true;

        final redirectUrl = data['url']?.toString() ??
            data['redirect_url']?.toString() ??
            data['link']?.toString() ??
            data['data']?['url']?.toString() ??
            data['data']?['redirect_url']?.toString() ??
            data['data']?['link']?.toString();

        if (redirectUrl != null && redirectUrl.isNotEmpty) {
          return Success(redirectUrl);
        }

        if (isSuccess) {
          final msg = cleanApiMessage(
            data['message'] ?? 'PAN Service initiated successfully',
          );
          return Success(msg);
        }

        final errorMsg = cleanApiMessage(
          data['message'] ?? data['error'] ?? 'Failed to initiate PAN service',
        );
        return Error(ServerFailure(errorMsg));
      }

      return const Error(
        ServerFailure('Invalid response received from PAN service server'),
      );
    } on AppException catch (e) {
      return Error(e.toFailure());
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }
}
