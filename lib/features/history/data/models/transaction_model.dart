/// Transaction history item model with nested Category and Razorpay models.
///
/// Sourced from transaction APIs.
class TransactionCategoryModel {
  final int? id;
  final String? name;
  final String? icon;
  final String? type;
  final String? operatorCode;
  final String? inspayCode;
  final String? iconUrl;

  const TransactionCategoryModel({
    this.id,
    this.name,
    this.icon,
    this.type,
    this.operatorCode,
    this.inspayCode,
    this.iconUrl,
  });

  factory TransactionCategoryModel.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return TransactionCategoryModel(
        id: json['id'] is int
            ? json['id']
            : int.tryParse(json['id']?.toString() ?? ''),
        name: json['name']?.toString(),
        icon: json['icon']?.toString(),
        type: json['type']?.toString(),
        operatorCode: json['operator_code']?.toString(),
        inspayCode: json['inspay_code']?.toString(),
        iconUrl: json['icon_url']?.toString(),
      );
    } else if (json is List && json.isNotEmpty && json[0] is Map) {
      return TransactionCategoryModel.fromJson(Map<String, dynamic>.from(json[0]));
    }
    return const TransactionCategoryModel();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'type': type,
        'operator_code': operatorCode,
        'inspay_code': inspayCode,
        'icon_url': iconUrl,
      };
}

class RazorpayResponseModel {
  final String? paymentId;
  final String? orderId;
  final String? signature;
  final String? receipt;
  final String? status;

  const RazorpayResponseModel({
    this.paymentId,
    this.orderId,
    this.signature,
    this.receipt,
    this.status,
  });

  factory RazorpayResponseModel.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      final rawId = json['id']?.toString();
      final isOrderId = rawId != null && rawId.startsWith('order_');
      final isPaymentId = rawId != null && rawId.startsWith('pay_');

      return RazorpayResponseModel(
        paymentId: json['payment_id']?.toString() ?? (isPaymentId ? rawId : null),
        orderId: json['order_id']?.toString() ?? (isOrderId ? rawId : null),
        signature: json['signature']?.toString(),
        receipt: json['receipt']?.toString(),
        status: json['status']?.toString(),
      );
    }
    return const RazorpayResponseModel();
  }

  Map<String, dynamic> toJson() => {
        'payment_id': paymentId,
        'order_id': orderId,
        'signature': signature,
        if (receipt != null) 'receipt': receipt,
        if (status != null) 'status': status,
      };
}

class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.txnId,
    this.type,
    this.operator,
    this.billerId,
    this.number,
    this.refId,
    this.orderId,
    this.razorpayOrderId,
    this.paymentId,
    this.description,
    this.receiptUrl,
    this.planDetails,
    this.categoryName,
    this.category,
    this.razorpayResponse,
  });

  final String id;
  final String? txnId;
  final double amount;

  /// Raw status string: 'success', 'pending', 'failed', 'refunded'.
  final String status;
  final DateTime createdAt;

  /// Service type: 'recharge', 'dth', 'electricity', 'water', etc.
  final String? type;
  final String? operator;
  final String? billerId;

  /// Mobile / account / vehicle number recharged.
  final String? number;
  final String? refId;
  final String? orderId;
  final String? razorpayOrderId;
  final String? paymentId;
  final String? description;
  final String? receiptUrl;
  final String? planDetails;
  final String? categoryName;
  final TransactionCategoryModel? category;
  final RazorpayResponseModel? razorpayResponse;

  // ── Derived Helpers & Direct UI Getters ────────────────────────────────────

  /// Get type from nested `category.type` first, fallback to root `type`
  String get displayType => category?.type ?? type ?? '';

  /// Get icon_url from nested `category.icon_url` or `category.icon`
  String get displayIconUrl {
    final u = category?.iconUrl ?? category?.icon;
    return (u != null && u.trim().isNotEmpty) ? u.trim() : '';
  }

  /// Get operator code / biller id from `category.operatorCode` or `billerId` or `operator`
  String get displayOperatorCode =>
      category?.operatorCode ?? billerId ?? operator ?? '';

  /// Get Razorpay payment_id from `razorpay_response.payment_id` or `paymentId`
  String get displayPaymentId =>
      razorpayResponse?.paymentId ?? paymentId ?? '';

  /// Get Razorpay order_id from `razorpay_response.order_id` or `razorpayOrderId` or `orderId`
  String get displayOrderId =>
      razorpayResponse?.orderId ?? razorpayOrderId ?? orderId ?? '';

  bool get isSuccess =>
      status.toLowerCase() == 'success' ||
      status.toLowerCase() == 'successful' ||
      status.toLowerCase() == 'completed';

  bool get isPending =>
      status.toLowerCase() == 'pending' || status.toLowerCase() == 'processing';

  bool get isFailed =>
      status.toLowerCase() == 'failed' ||
      status.toLowerCase() == 'failure' ||
      status.toLowerCase() == 'cancelled';

  // ── Serialisation ─────────────────────────────────────────────────────────────

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final catModel = json['category'] != null
        ? TransactionCategoryModel.fromJson(json['category'])
        : null;

    final rzpModel = json['razorpay_response'] != null
        ? RazorpayResponseModel.fromJson(json['razorpay_response'])
        : null;

    final rzpPaymentId = rzpModel?.paymentId ??
        _str(json['razorpay_txid'] ?? json['payment_id'] ?? json['razorpay_payment_id']);

    final rzpOrderId = rzpModel?.orderId ??
        _str(json['razorpay_order_id'] ?? json['order_id']);

    return TransactionModel(
      id: (json['id'] ??
              json['transaction_id'] ??
              json['txn_id'] ??
              json['order_id'] ??
              '')
          .toString(),
      txnId: _str(json['txn_id'] ?? json['bconnect_txn_id']),
      amount: _double(json['amount'] ?? json['recharge_amount'] ?? json['total_amount']),
      status: (json['status'] ??
              json['recharge_status'] ??
              json['payment_status'] ??
              'pending')
          .toString()
          .toLowerCase(),
      createdAt: _dateOrNow(json['created_at'] ?? json['date'] ?? json['transaction_date']),
      type: _str(catModel?.type ?? json['type'] ?? json['service_type']),
      operator: _str(catModel?.name ?? json['operator'] ?? json['operator_name'] ?? json['biller_name']),
      billerId: _str(json['biller_id'] ?? catModel?.operatorCode),
      number: _str(json['consumer_number'] ??
          json['number'] ??
          json['mobile'] ??
          json['account_no'] ??
          json['vehicle_no']),
      refId: _str(json['reference_id'] ?? json['ref_id'] ?? json['recharge_ref']),
      orderId: rzpOrderId,
      razorpayOrderId: rzpOrderId,
      paymentId: rzpPaymentId,
      description: _str(json['description'] ?? json['plan_description'] ?? json['details']),
      receiptUrl: _str(json['receipt_url'] ?? json['invoice_url']),
      planDetails: _str(json['plan_details'] ?? json['plan'] ?? json['pack']),
      categoryName: _str(json['category_name'] ?? catModel?.name),
      category: catModel,
      razorpayResponse: rzpModel,
    );
  }

  /// Parses the API history response — handles `data`, `transactions`,
  /// `history` nesting and bare-list shapes.
  static List<TransactionModel> listFromApiResponse(dynamic response) {
    if (response == null) return [];

    List rawList = [];
    if (response is Map) {
      final dataField = response['data'];
      final txField = response['transactions'];
      final historyField = response['history'];
      final rechargesField = response['recharges'];

      if (dataField is List) {
        rawList = dataField;
      } else if (dataField is Map) {
        final innerData = dataField['data'];
        final innerTx = dataField['transactions'];
        if (innerData is List) {
          rawList = innerData;
        } else if (innerTx is List) {
          rawList = innerTx;
        }
      } else if (txField is List) {
        rawList = txField;
      } else if (historyField is List) {
        rawList = historyField;
      } else if (rechargesField is List) {
        rawList = rechargesField;
      }
    } else if (response is List) {
      rawList = response;
    }

    return rawList
        .whereType<Map>()
        .map((e) => TransactionModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'txn_id': txnId,
        'amount': amount,
        'status': status,
        'created_at': createdAt.toIso8601String(),
        if (type != null) 'type': type,
        if (operator != null) 'operator': operator,
        if (billerId != null) 'biller_id': billerId,
        if (number != null) 'number': number,
        if (refId != null) 'ref_id': refId,
        if (orderId != null) 'order_id': orderId,
        if (razorpayOrderId != null) 'razorpay_order_id': razorpayOrderId,
        if (paymentId != null) 'payment_id': paymentId,
        if (description != null) 'description': description,
        if (planDetails != null) 'plan_details': planDetails,
        if (categoryName != null) 'category_name': categoryName,
        if (category != null) 'category': category!.toJson(),
        if (razorpayResponse != null)
          'razorpay_response': razorpayResponse!.toJson(),
      };

  @override
  bool operator ==(Object other) =>
      other is TransactionModel && id == other.id;

  @override
  int get hashCode => id.hashCode;
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

DateTime _dateOrNow(dynamic v) {
  if (v == null) return DateTime.now();
  final s = v.toString().trim();
  if (s.isEmpty || s == 'null') return DateTime.now();
  try {
    return DateTime.parse(s).toLocal();
  } catch (_) {
    return DateTime.now();
  }
}

