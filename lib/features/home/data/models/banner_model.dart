/// Banner model for the home screen carousel.
///
/// Keys sourced from [AuthController.getBannersApi] response observation.
class BannerModel {
  const BannerModel({
    required this.id,
    required this.imageUrl,
    this.title,
    this.link,
    this.isActive,
    this.sortOrder,
  });

  final int id;
  final String imageUrl;
  final String? title;
  final String? link;
  final bool? isActive;
  final int? sortOrder;

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: _int(json['id'] ?? json['banner_id']),
      imageUrl: (json['image'] ??
              json['image_url'] ??
              json['banner_image'] ??
              json['url'] ??
              '')
          .toString(),
      title: _str(json['title'] ?? json['name']),
      link: _str(json['link'] ?? json['redirect_url'] ?? json['action']),
      isActive: _bool(json['is_active'] ?? json['active'] ?? json['status']),
      sortOrder: _intNullable(json['sort_order'] ?? json['order'] ?? json['sequence']),
    );
  }

  static List<BannerModel> listFromApiResponse(dynamic response) {
    if (response == null) return [];

    List rawList = [];
    if (response is Map) {
      final dataField = response['data'];
      final bannersField = response['banners'];

      if (dataField is List) {
        rawList = dataField;
      } else if (dataField is Map) {
        final innerData = dataField['data'];
        final innerBanners = dataField['banners'];
        if (innerData is List) {
          rawList = innerData;
        } else if (innerBanners is List) {
          rawList = innerBanners;
        }
      } else if (bannersField is List) {
        rawList = bannersField;
      }
    } else if (response is List) {
      rawList = response;
    }

    return rawList
        .whereType<Map>()
        .map((e) => BannerModel.fromJson(Map<String, dynamic>.from(e)))
        .where((b) => b.imageUrl.isNotEmpty)
        .toList();
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'image': imageUrl,
    if (title != null) 'title': title,
    if (link != null) 'link': link,
    if (isActive != null) 'is_active': isActive,
    if (sortOrder != null) 'sort_order': sortOrder,
  };

  @override
  bool operator ==(Object other) =>
      other is BannerModel && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

int _int(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}

int? _intNullable(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  return int.tryParse(v.toString());
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
