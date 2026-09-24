import '../../../../core/errors/result.dart';
import '../../data/models/faq_model.dart';
import '../repositories/help_support_repository.dart';

class GetFaqsUseCase {
  const GetFaqsUseCase(this._repository);
  final HelpSupportRepository _repository;

  Future<Result<FaqResponse>> call() {
    return _repository.fetchFaqs();
  }
}
