/// Typed operator model for mobile recharge.
///
/// Keys extracted from [RechargeController.fetchOperatorAndPlans].
class OperatorModel {
  const OperatorModel({
    required this.opcode,
    required this.name,
    this.circle,
    this.circleCode,
    this.imageUrl,
    this.isActive,
  });

  final String opcode;
  final String name;
  final String? circle;
  final String? circleCode;
  final String? imageUrl;
  final bool? isActive;

  factory OperatorModel.fromJson(Map<String, dynamic> json) {
    return OperatorModel(
      opcode: (json['mapped_opcode'] ??
              json['company_code'] ??
              json['opcode'] ??
              json['operator_code'] ??
              'A')
          .toString(),
      name: (json['name'] ??
              json['operator_name'] ??
              json['company'] ??
              json['company_name'] ??
              '')
          .toString(),
      circle: _str(json['circle'] ?? json['circle_name']),
      circleCode: _str(json['circle_code']),
      imageUrl: _str(json['image'] ?? json['logo'] ?? json['icon'] ?? json['operator_image']),
      isActive: _bool(json['is_active'] ?? json['status']),
    );
  }

  /// Handles `response['data']` and bare-map nesting.
  factory OperatorModel.fromApiResponse(Map<String, dynamic> response) {
    final data = response['data'] is Map
        ? response['data'] as Map<String, dynamic>
        : response;
    return OperatorModel.fromJson(data);
  }

  Map<String, dynamic> toJson() => {
    'opcode': opcode,
    'name': name,
    if (circle != null) 'circle': circle,
    if (circleCode != null) 'circle_code': circleCode,
    if (imageUrl != null) 'image': imageUrl,
    if (isActive != null) 'is_active': isActive,
  };

  @override
  bool operator ==(Object other) =>
      other is OperatorModel && opcode == other.opcode;

  @override
  int get hashCode => opcode.hashCode;
}

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
