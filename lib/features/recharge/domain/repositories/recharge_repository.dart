import '../../../../core/errors/result.dart';
import '../../../history/data/models/transaction_model.dart';
import '../../data/models/operator_model.dart';
import '../../data/models/order_model.dart';
import '../../data/models/recharge_plan_model.dart';

abstract interface class RechargeRepository {
  /// Fetches the operator and circle for a given [mobileNumber].
  Future<Result<OperatorModel>> fetchOperator({required String mobileNumber});

  /// Fetches categorised plans for mobile/DTH recharge.
  Future<Result<CategorisedPlans>> fetchPlans({
    required String mobileNumber,
    required String opcode,
    required String circle,
    bool isDth = false,
  });

  /// Fetches special R-Offers for mobile recharge.
  Future<Result<List<RechargePlanModel>>> fetchRoffers({
    required String mobileNumber,
    required String opcode,
  });

  /// Creates a Razorpay order for recharge.
  Future<Result<OrderModel>> createOrder({
    required String opcode,
    required String number,
    required double amount,
    String? type,
    String? fetchId,
  });

  /// Verifies a Razorpay payment on backend.
  Future<Result<PaymentVerifyModel>> verifyPayment({
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
    String? type,
  });

  /// Fetches recent recharges for the current user.
  Future<Result<List<TransactionModel>>> fetchRecentRecharges();
}
