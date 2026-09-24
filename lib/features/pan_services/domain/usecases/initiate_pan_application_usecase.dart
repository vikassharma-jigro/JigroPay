import '../../../../core/errors/result.dart';
import '../repositories/pan_service_repository.dart';

class InitiatePanApplicationUseCase {
  const InitiatePanApplicationUseCase(this._repository);

  final PanServiceRepository _repository;

  Future<Result<String>> call({required String mobileNumber}) {
    return _repository.initiatePanApplication(mobileNumber: mobileNumber);
  }
}
