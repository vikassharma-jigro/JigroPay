/// Typed Razorpay order model — returned by the `create-order` API.
///
/// Keys sourced from [RechargeController.createRechargeOrder] response.
class OrderModel {
  const OrderModel({
    required this.orderId,
    required this.razorpayOrderId,
    required this.amount,
    required this.currency,
    this.razorpayKey,
    this.transactionId,
    this.status,
    this.notes,
  });

  final String orderId;
  final String razorpayOrderId;
  final double amount;
  final String currency;
  final String? razorpayKey;
  final String? transactionId;
  final String? status;
  final Map<String, dynamic>? notes;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Unwrap nested data if present
    final d = json['data'] is Map ? json['data'] as Map<String, dynamic> : json;

    return OrderModel(
      orderId: (d['id'] ?? d['order_id'] ?? d['app_order_id'] ?? '').toString(),
      razorpayOrderId: (d['razorpay_order_id'] ?? d['gateway_order_id'] ?? d['rpid'] ?? '').toString(),
      amount: _double(d['amount'] ?? d['total_amount']),
      currency: (d['currency'] ?? 'INR').toString(),
      razorpayKey: _str(d['razorpay_key'] ?? d['key'] ?? d['gateway_key']),
      transactionId: _str(d['transaction_id'] ?? d['txn_id']),
      status: _str(d['status']),
      notes: d['notes'] is Map ? Map<String, dynamic>.from(d['notes']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': orderId,
    'razorpay_order_id': razorpayOrderId,
    'amount': amount,
    'currency': currency,
    if (razorpayKey != null) 'razorpay_key': razorpayKey,
    if (transactionId != null) 'transaction_id': transactionId,
    if (status != null) 'status': status,
    if (notes != null) 'notes': notes,
  };

  @override
  String toString() =>
      'OrderModel(orderId=$orderId, razorpayOrderId=$razorpayOrderId, amount=$amount)';
}

// ── Verify payment response ──────────────────────────────────────────────────

/// Typed payment verification response — from `verify` API.
class PaymentVerifyModel {
  const PaymentVerifyModel({
    required this.success,
    required this.message,
    this.transactionId,
    this.status,
    this.operator,
    this.refId,
    this.rechargeId,
  });

  final bool success;
  final String message;
  final String? transactionId;
  final String? status;
  final String? operator;
  final String? refId;
  final String? rechargeId;

  factory PaymentVerifyModel.fromJson(Map<String, dynamic> json) {
    final d = json['data'] is Map ? json['data'] as Map<String, dynamic> : json;

    final rawStatus = json['status'] ?? json['success'];
    final isSuccess = rawStatus == true ||
        rawStatus == 1 ||
        rawStatus == 'true' ||
        rawStatus == 'Success' ||
        rawStatus == 'success';

    return PaymentVerifyModel(
      success: isSuccess,
      message: (json['message'] ?? json['msg'] ?? (isSuccess ? 'Payment Successful' : 'Payment Failed')).toString(),
      transactionId: _str(d['transaction_id'] ?? d['txn_id'] ?? d['id']),
      status: _str(d['status'] ?? d['recharge_status']),
      operator: _str(d['operator'] ?? d['operator_name']),
      refId: _str(d['ref_id'] ?? d['reference_id'] ?? d['recharge_ref']),
      rechargeId: _str(d['recharge_id'] ?? d['order_id']),
    );
  }
}

String? _str(dynamic v) {
  if (v == null) return null;
  final s = v.toString().trim();
  return (s.isEmpty || s == 'null') ? null : s;
}

double _double(dynamic v) {
  if (v == null) return 0.0;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0.0;
}
