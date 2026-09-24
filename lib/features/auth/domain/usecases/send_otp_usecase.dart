import '../../../../core/errors/result.dart';
import '../repositories/auth_repository.dart';

class SendOtpUseCase {
  const SendOtpUseCase(this._repository);
  final AuthRepository _repository;

  Future<Result<String>> call({required String phone}) {
    return _repository.sendOtp(phone: phone);
  }
}
