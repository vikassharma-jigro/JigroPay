import '../../../../core/errors/result.dart';
import '../../../recharge/data/models/order_model.dart';
import '../repositories/bill_payment_repository.dart';

class PayBillUseCase {
  const PayBillUseCase(this._repository);
  final BillPaymentRepository _repository;

  Future<Result<OrderModel>> createOrder({
    required String opcode,
    required String consumerNumber,
    required double amount,
    required String fetchId,
    String? serviceType,
  }) {
    return _repository.createBillOrder(
      opcode: opcode,
      consumerNumber: consumerNumber,
      amount: amount,
      fetchId: fetchId,
      serviceType: serviceType,
    );
  }

  Future<Result<PaymentVerifyModel>> verifyPayment({
    required String paymentId,
    required String orderId,
    required String signature,
    String? serviceType,
  }) {
    return _repository.verifyBillPayment(
      paymentId: paymentId,
      orderId: orderId,
      signature: signature,
      serviceType: serviceType,
    );
  }
}
