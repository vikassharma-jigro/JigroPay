import '../../../../core/errors/result.dart';
import '../../data/models/user_model.dart';
import '../repositories/auth_repository.dart';

class GetProfileUseCase {
  const GetProfileUseCase(this._repository);
  final AuthRepository _repository;

  Future<Result<UserModel>> call() {
    return _repository.getProfile();
  }
}
