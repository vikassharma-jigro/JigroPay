/// Typed biller model for bill payment services
/// (electricity, water, gas, broadband, cable, municipal, etc.).
///
/// Keys sourced from `fetchOperatorsByType` and `fetchUtilityBill` responses.
class BillerModel {
  const BillerModel({
    required this.opcode,
    required this.name,
    this.category,
    this.state,
    this.imageUrl,
    this.isActive,
    this.supportsFetch,
    this.fetchRequiredFields,
  });

  final String opcode;
  final String name;
  final String? category;
  final String? state;
  final String? imageUrl;
  final bool? isActive;

  /// Whether this biller supports bill-fetch before payment.
  final bool? supportsFetch;

  /// List of field keys required for bill fetch (e.g. ['consumer_id', 'mobile']).
  final List<String>? fetchRequiredFields;

  factory BillerModel.fromJson(Map<String, dynamic> json) {
    List<String>? fields;
    final rawFields = json['required_fields'] ?? json['fetch_fields'];
    if (rawFields is List) {
      fields = rawFields.map((e) => e.toString()).toList();
    }

    return BillerModel(
      opcode:
          (json['operator_code'] ??
                  json['opcode'] ??
                  json['company_code'] ??
                  json['biller_id'] ??
                  json['id'] ??
                  'A')
              .toString(),
      name:
          (json['name'] ??
                  json['operator_name'] ??
                  json['biller_name'] ??
                  json['company'] ??
                  json['company_name'] ??
                  '')
              .toString(),
      category: _str(json['category'] ?? json['type'] ?? json['service_type']),
      state: _str(json['state'] ?? json['state_name']),
      imageUrl: _str(
        json['image'] ??
            json['logo'] ??
            json['icon'] ??
            json['operator_image'] ??
            json['icon_url'],
      ),
      isActive: _bool(json['is_active'] ?? json['active'] ?? json['status']),
      supportsFetch: _bool(json['supports_fetch'] ?? json['fetch_bill']),
      fetchRequiredFields: fields,
    );
  }

  Map<String, dynamic> toJson() => {
    'opcode': opcode,
    'name': name,
    if (category != null) 'category': category,
    if (state != null) 'state': state,
    if (imageUrl != null) 'image': imageUrl,
    if (isActive != null) 'is_active': isActive,
    if (supportsFetch != null) 'supports_fetch': supportsFetch,
    if (fetchRequiredFields != null) 'required_fields': fetchRequiredFields,
  };

  @override
  bool operator ==(Object other) =>
      other is BillerModel && opcode == other.opcode;

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
