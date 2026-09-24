import '../../../../core/errors/result.dart';
import '../repositories/help_support_repository.dart';

class SubmitEnquiryUseCase {
  const SubmitEnquiryUseCase(this._repository);
  final HelpSupportRepository _repository;

  Future<Result<bool>> call({
    required String subject,
    required String message,
    String? category,
  }) {
    return _repository.submitEnquiry(
      subject: subject,
      message: message,
      category: category,
    );
  }
}
