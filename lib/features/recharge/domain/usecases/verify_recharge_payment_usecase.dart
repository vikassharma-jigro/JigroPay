import '../../../../core/errors/result.dart';
import '../../data/models/order_model.dart';
import '../repositories/recharge_repository.dart';

class VerifyRechargePaymentUseCase {
  const VerifyRechargePaymentUseCase(this._repository);
  final RechargeRepository _repository;

  Future<Result<PaymentVerifyModel>> call({
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
    String? type,
  }) {
    return _repository.verifyPayment(
      razorpayPaymentId: razorpayPaymentId,
      razorpayOrderId: razorpayOrderId,
      razorpaySignature: razorpaySignature,
      type: type,
    );
  }
}
