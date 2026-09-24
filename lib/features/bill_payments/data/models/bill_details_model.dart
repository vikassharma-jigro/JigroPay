/// Typed bill details model — returned by bill-fetch API before payment.
///
/// Used for: electricity, water, gas, broadband, cable, fastag, credit card.
/// Keys sourced from [RechargeController.fetchUtilityBill] /
/// [RechargeController.fetchFastagBill] response observation.
class BillDetailsModel {
  const BillDetailsModel({
    required this.fetchId,
    required this.consumerName,
    required this.amount,
    this.consumerNumber,
    this.billNumber,
    this.billDate,
    this.dueDate,
    this.outstandingAmount,
    this.billerName,
    this.serviceNumber,
    this.extra,
  });

  final String fetchId;
  final String consumerName;
  final double amount;
  final String? consumerNumber;
  final String? billNumber;
  final DateTime? billDate;
  final DateTime? dueDate;
  final double? outstandingAmount;
  final String? billerName;
  final String? serviceNumber;

  /// Any additional fields from the API for display (unit consumed, address, etc.)
  final Map<String, dynamic>? extra;

  factory BillDetailsModel.fromJson(Map<String, dynamic> json) {
    // Unwrap nested data
    final d = json['data'] is Map ? json['data'] as Map<String, dynamic> : json;

    return BillDetailsModel(
      fetchId: (d['fetch_id'] ?? d['ref_id'] ?? d['txn_ref'] ?? d['id'] ?? '').toString(),
      consumerName: (d['consumer_name'] ??
              d['customer_name'] ??
              d['name'] ??
              d['holder_name'] ??
              '')
          .toString(),
      amount: _double(d['amount'] ?? d['bill_amount'] ?? d['outstanding_amount'] ?? d['due_amount']),
      consumerNumber: _str(d['consumer_no'] ?? d['consumer_number'] ?? d['account_no'] ?? d['consumer_id']),
      billNumber: _str(d['bill_no'] ?? d['bill_number'] ?? d['invoice_no']),
      billDate: _date(d['bill_date'] ?? d['billing_date']),
      dueDate: _date(d['due_date'] ?? d['payment_due_date'] ?? d['expiry_date']),
      outstandingAmount: _doubleNullable(d['outstanding_amount'] ?? d['arrears']),
      billerName: _str(d['biller_name'] ?? d['company_name'] ?? d['operator']),
      serviceNumber: _str(d['service_no'] ?? d['vehicle_no'] ?? d['card_no']),
      extra: Map<String, dynamic>.from(d),
    );
  }

  Map<String, dynamic> toJson() => {
    'fetch_id': fetchId,
    'consumer_name': consumerName,
    'amount': amount,
    if (consumerNumber != null) 'consumer_no': consumerNumber,
    if (billNumber != null) 'bill_no': billNumber,
    if (billDate != null) 'bill_date': billDate!.toIso8601String(),
    if (dueDate != null) 'due_date': dueDate!.toIso8601String(),
    if (outstandingAmount != null) 'outstanding_amount': outstandingAmount,
    if (billerName != null) 'biller_name': billerName,
    if (serviceNumber != null) 'service_no': serviceNumber,
  };
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

double? _doubleNullable(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  return double.tryParse(v.toString());
}

DateTime? _date(dynamic v) {
  if (v == null) return null;
  final s = v.toString().trim();
  if (s.isEmpty || s == 'null') return null;
  try { return DateTime.parse(s).toLocal(); } catch (_) { return null; }
}
