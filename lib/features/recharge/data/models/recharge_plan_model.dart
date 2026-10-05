
class RechargePlanModel {
  const RechargePlanModel({
    required this.id,
    required this.amount,
    required this.description,
    this.validity,
    this.talktime,
    this.data,
    this.sms,
    this.category,
    this.opcode,
    this.circle,
    this.isPopular,
    this.tag,
  });

  final String id;
  final double amount;
  final String description;
  final String? validity;
  final String? talktime;
  final String? data;
  final String? sms;
  final String? category;
  final String? opcode;
  final String? circle;
  final bool? isPopular;
  final String? tag;

  factory RechargePlanModel.fromJson(Map<String, dynamic> json) {
    return RechargePlanModel(
      id: (json['id'] ?? json['plan_id'] ?? json['recharge_id'] ?? '').toString(),
      amount: _double(json['rs'] ?? json['amount'] ?? json['price'] ?? json['recharge_amount']),
      description: (json['desc'] ??
              json['description'] ??
              json['plan_description'] ??
              json['details'] ??
              '')
          .toString(),
      validity: _str(json['validity'] ?? json['plan_validity']),
      talktime: _str(json['talktime'] ?? json['talk_time'] ?? json['calling']),
      data: _str(json['data'] ?? json['plan_data'] ?? json['internet']),
      sms: _str(json['sms']),
      category: _str(json['type'] ?? json['category'] ?? json['plan_type']),
      opcode: _str(json['opcode'] ?? json['operator_code']),
      circle: _str(json['circle'] ?? json['circle_code']),
      isPopular: _bool(json['is_popular'] ?? json['popular']),
      tag: _str(json['tag'] ?? json['label'] ?? json['badge']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'description': description,
    if (validity != null) 'validity': validity,
    if (talktime != null) 'talktime': talktime,
    if (data != null) 'data': data,
    if (sms != null) 'sms': sms,
    if (category != null) 'category': category,
    if (opcode != null) 'opcode': opcode,
    if (circle != null) 'circle': circle,
    if (isPopular != null) 'is_popular': isPopular,
    if (tag != null) 'tag': tag,
  };

  @override
  bool operator ==(Object other) =>
      other is RechargePlanModel && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Holds categorised recharge plans (e.g. Talktime, Data, Combos).
class CategorisedPlans {
  const CategorisedPlans(this.plans);

  final Map<String, List<RechargePlanModel>> plans;

  bool get isEmpty => plans.isEmpty;
  bool get isNotEmpty => plans.isNotEmpty;

  List<String> get categories => plans.keys.toList();

  List<RechargePlanModel> get allPlans =>
      plans.values.expand((list) => list).toList();

  List<RechargePlanModel> forCategory(String category) =>
      plans[category] ?? [];

  /// Parses the API response into a [CategorisedPlans] object.
  ///
  /// Handles both `Map<category, List<plan>>` and bare `List<plan>` structures.
  factory CategorisedPlans.fromApiResponse(Map<String, dynamic> response) {
    final raw = response['data'] ?? response['plans'] ?? response;

    if (raw is Map) {
      final result = <String, List<RechargePlanModel>>{};
      raw.forEach((key, value) {
        if (value is List) {
          result[key.toString()] = value
              .whereType<Map<String, dynamic>>()
              .map(RechargePlanModel.fromJson)
              .toList();
        }
      });
      return CategorisedPlans(result);
    }

    if (raw is List) {
      final plans = raw
          .whereType<Map<String, dynamic>>()
          .map(RechargePlanModel.fromJson)
          .toList();
      return CategorisedPlans({'All Plans': plans});
    }

    return const CategorisedPlans({});
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

String? _str(dynamic v) {
  if (v == null) return null;
  final s = v.toString().trim();
  return (s.isEmpty || s == 'null') ? null : s;
}

bool? _bool(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  if (v == 1 || v == '1' || v == 'true') return true;
  if (v == 0 || v == '0' || v == 'false') return false;
  return null;
}

double _double(dynamic v) {
  if (v == null) return 0.0;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0.0;
}
