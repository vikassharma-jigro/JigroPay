import '../../../../core/errors/result.dart';
import '../../data/models/user_model.dart';
import '../repositories/auth_repository.dart';

class UpdateProfileUseCase {
  const UpdateProfileUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<UserModel>> call({
    required String name,
    required String email,
    String? profileImage,
  }) {
    return _repository.updateProfile(
      name: name,
      email: email,
      profileImage: profileImage,
    );
  }
}
