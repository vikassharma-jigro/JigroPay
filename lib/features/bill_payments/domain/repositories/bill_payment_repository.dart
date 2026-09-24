import '../../../../core/errors/result.dart';
import '../../../recharge/data/models/order_model.dart';
import '../../data/models/bill_details_model.dart';
import '../../data/models/biller_model.dart';

abstract interface class BillPaymentRepository {
  /// Fetches billers/operators for a specific [serviceType]
  /// (e.g. 'electricity', 'water', 'gas', 'broadband', 'cable', 'fastag', 'credit-card', etc.).
  Future<Result<List<BillerModel>>> fetchBillersByType({required String serviceType});

  /// Fetches bill details before payment using [billerCode] and [consumerNumber].
  Future<Result<BillDetailsModel>> fetchBillDetails({
    required String serviceType,
    required String billerCode,
    required String consumerNumber,
    Map<String, dynamic>? extraFields,
  });

  /// Creates a payment order for the fetched bill.
  Future<Result<OrderModel>> createBillOrder({
    required String opcode,
    required String consumerNumber,
    required double amount,
    required String fetchId,
    String? serviceType,
  });

  /// Verifies the bill payment with Razorpay credentials.
  Future<Result<PaymentVerifyModel>> verifyBillPayment({
    required String paymentId,
    required String orderId,
    required String signature,
    String? serviceType,
  });
}
