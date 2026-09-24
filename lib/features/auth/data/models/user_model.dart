/// Typed user / profile model.
///
/// Keys extracted from [AuthController.getProfileApi] response observation.
class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.profileImageUrl,
    this.profileImage,
    this.referralCode,
    this.walletBalance,
    this.isActive,
    this.createdAt,
  });

  final int id;
  final String name;
  final String phone;
  final String? email;
  final String? profileImageUrl;
  final String? profileImage;
  final String? referralCode;
  final double? walletBalance;
  final bool? isActive;
  final DateTime? createdAt;

  // ── Deserialisation ──────────────────────────────────────────────────────────

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Profile image — handle nested or flat
    final raw = json['profile_image_url'] ??
        json['profile_image'] ??
        json['avatar'] ??
        json['photo'];
    String? imageUrl;
    if (raw is String && raw.isNotEmpty && raw != 'null') {
      imageUrl = raw;
    }

    final raw1 = json['profile_image'];
    String? image;
    if (raw1 is String && raw1.isNotEmpty && raw1 != 'null') {
      image = raw1;
    }

    return UserModel(
      id: _parseInt(json['id'] ?? json['user_id']),
      name: (json['name'] ?? json['full_name'] ?? json['username'] ?? '')
          .toString(),
      phone: (json['phone'] ?? json['mobile'] ?? json['mobile_number'] ?? '')
          .toString(),
      email: _parseNullableString(json['email']),
      profileImageUrl: imageUrl,
      profileImage: image,
      referralCode: _parseNullableString(
        json['referral_code'] ?? json['refer_code'],
      ),
      walletBalance: _parseDouble(json['wallet_balance'] ?? json['balance']),
      isActive: _parseBool(json['is_active'] ?? json['status']),
      createdAt: _parseDate(json['created_at'] ?? json['joined_at']),
    );
  }

  /// Builds a [UserModel] from the API profile response map, handling both
  /// `response['data']` and `response['user']` nesting patterns.
  factory UserModel.fromApiResponse(Map<String, dynamic> response) {
    final data =
        (response['data'] is Map
                ? response['data']
                : response['user'] is Map
                ? response['user']
                : response)
            as Map<String, dynamic>;
    return UserModel.fromJson(data);
  }

  // ── Serialisation ────────────────────────────────────────────────────────────

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    if (email != null) 'email': email,
    if (profileImageUrl != null) 'profile_image': profileImageUrl,
    if (profileImage != null) 'profile_image': profileImage,
    if (referralCode != null) 'referral_code': referralCode,
    if (walletBalance != null) 'wallet_balance': walletBalance,
    if (isActive != null) 'is_active': isActive,
    if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
  };

  // ── copyWith ─────────────────────────────────────────────────────────────────

  UserModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? profileImageUrl,
    String? profileImage,
    String? referralCode,
    double? walletBalance,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      profileImage: profileImage ?? this.profileImage,
      referralCode: referralCode ?? this.referralCode,
      walletBalance: walletBalance ?? this.walletBalance,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'UserModel(id=$id, name=$name, phone=$phone)';
}

// ── Helpers ───────────────────────────────────────────────────────────────────

int _parseInt(dynamic val) {
  if (val == null) return 0;
  if (val is int) return val;
  return int.tryParse(val.toString()) ?? 0;
}

double? _parseDouble(dynamic val) {
  if (val == null) return null;
  if (val is double) return val;
  if (val is int) return val.toDouble();
  return double.tryParse(val.toString());
}

String? _parseNullableString(dynamic val) {
  if (val == null) return null;
  final s = val.toString().trim();
  if (s.isEmpty || s == 'null') return null;
  return s;
}

bool? _parseBool(dynamic val) {
  if (val == null) return null;
  if (val is bool) return val;
  if (val == 1 || val == '1' || val == 'true' || val == 'True') return true;
  if (val == 0 || val == '0' || val == 'false' || val == 'False') return false;
  return null;
}

DateTime? _parseDate(dynamic val) {
  if (val == null) return null;
  final s = val.toString().trim();
  if (s.isEmpty || s == 'null') return null;
  try {
    return DateTime.parse(s).toLocal();
  } catch (_) {
    return null;
  }
}
