import '../../../../core/constants/app_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/faq_model.dart';
import '../../domain/repositories/help_support_repository.dart';

class HelpSupportRepositoryImpl implements HelpSupportRepository {
  HelpSupportRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  final ApiClient _apiClient;

  @override
  Future<Result<FaqResponse>> fetchFaqs() async {
    try {
      final response = await _apiClient.get(AppEndpoints.faqs);
      _apiClient.throwIfError(response);
      final faqResponse = FaqResponse.fromApiResponse(response.data);
      return Success(faqResponse);
    } on AppException catch (e) {
      return Error(ServerFailure(e.message));
    } catch (e) {
      return Error(ServerFailure('Failed to load FAQs: $e'));
    }
  }

  @override
  Future<Result<bool>> submitEnquiry({
    required String subject,
    required String message,
    String? category,
  }) async {
    try {
      final response = await _apiClient.post(
        AppEndpoints.helpEnquiries,
        data: {
          'subject': subject,
          'description': message,
          'message': message,
          if (category != null) 'category': category,
        },
      );
      _apiClient.throwIfError(response);
      return const Success(true);
    } on AppException catch (e) {
      return Error(ServerFailure(e.message));
    } catch (e) {
      return Error(ServerFailure('Failed to submit enquiry: $e'));
    }
  }
}
