import '../../../../core/errors/result.dart';
import '../../data/models/faq_model.dart';

abstract class HelpSupportRepository {
  /// Fetches FAQ items and support contact details.
  Future<Result<FaqResponse>> fetchFaqs();

  /// Submits support enquiry ticket.
  Future<Result<bool>> submitEnquiry({
    required String subject,
    required String message,
    String? category,
  });
}
