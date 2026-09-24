import '../../../../core/errors/result.dart';
import '../../data/models/user_model.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  const RegisterUseCase(this._repository);
  final AuthRepository _repository;

  Future<Result<UserModel>> call({
    required String name,
    required String email,
    required String phone,
  }) {
    return _repository.register(name: name, email: email, phone: phone);
  }
}
