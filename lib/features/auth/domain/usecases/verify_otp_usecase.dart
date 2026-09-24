import '../../../../core/errors/result.dart';
import '../../data/models/user_model.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  const VerifyOtpUseCase(this._repository);
  final AuthRepository _repository;

  Future<Result<UserModel>> call({
    required String phone,
    required String otp,
    required String fcmToken,
  }) {
    return _repository.verifyOtp(
      phone: phone,
      otp: otp,
      fcmToken: fcmToken,
    );
  }
}
