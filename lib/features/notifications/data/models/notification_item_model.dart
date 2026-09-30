/// Typed notification item model.
///
/// Keys sourced from [NotificationController] response and
/// [AppEndpoints.notifications] GET response.
class NotificationItemModel {
  const NotificationItemModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.imageUrl,
    this.type,
    this.isRead = false,
    this.deepLink,
    this.extra,
  });

  final int id;
  final String title;
  final String body;
  final DateTime createdAt;
  final String? imageUrl;
  final String? type;
  final bool isRead;
  final String? deepLink;
  final Map<String, dynamic>? extra;

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    return NotificationItemModel(
      id: _int(json['id'] ?? json['notification_id']),
      title: (json['title'] ?? json['heading'] ?? json['subject'] ?? '')
          .toString(),
      body:
          (json['body'] ??
                  json['message'] ??
                  json['content'] ??
                  json['description'] ??
                  '')
              .toString(),
      createdAt: _dateOrNow(
        json['created_at'] ?? json['date'] ?? json['sent_at'],
      ),
      imageUrl: _str(json['image'] ?? json['image_url'] ?? json['icon']),
      type: _str(json['type'] ?? json['notification_type'] ?? json['category']),
      isRead: _checkIsRead(json),
      deepLink: _str(json['deep_link'] ?? json['action'] ?? json['redirect']),
      extra: json['data'] is Map
          ? Map<String, dynamic>.from(json['data'])
          : null,
    );
  }

  static List<NotificationItemModel> listFromApiResponse(dynamic response) {
    if (response == null) return [];

    List rawList = [];
    if (response is Map) {
      final dataField = response['data'];
      final notificationsField = response['notifications'];

      if (dataField is List) {
        rawList = dataField;
      } else if (dataField is Map) {
        // Handles Laravel paginated response structure:
        // response['data'] is Map, and response['data']['data'] is List
        final innerData = dataField['data'];
        final innerNotifs = dataField['notifications'];
        if (innerData is List) {
          rawList = innerData;
        } else if (innerNotifs is List) {
          rawList = innerNotifs;
        }
      } else if (notificationsField is List) {
        rawList = notificationsField;
      } else if (notificationsField is Map) {
        final innerData = notificationsField['data'];
        if (innerData is List) {
          rawList = innerData;
        }
      }
    } else if (response is List) {
      rawList = response;
    }

    return rawList
        .whereType<Map>()
        .map(
          (e) => NotificationItemModel.fromJson(Map<String, dynamic>.from(e)),
        )
        .toList();
  }

  NotificationItemModel copyWith({bool? isRead}) => NotificationItemModel(
    id: id,
    title: title,
    body: body,
    createdAt: createdAt,
    imageUrl: imageUrl,
    type: type,
    isRead: isRead ?? this.isRead,
    deepLink: deepLink,
    extra: extra,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'created_at': createdAt.toIso8601String(),
    if (imageUrl != null) 'image': imageUrl,
    if (type != null) 'type': type,
    'is_read': isRead,
    if (deepLink != null) 'deep_link': deepLink,
  };

  @override
  bool operator ==(Object other) =>
      other is NotificationItemModel &&
      id == other.id &&
      isRead == other.isRead;

  @override
  int get hashCode => Object.hash(id, isRead);
}

int _int(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}

String? _str(dynamic v) {
  if (v == null) return null;
  final s = v.toString().trim();
  return (s.isEmpty || s == 'null') ? null : s;
}

bool _boolDef(dynamic v, {required bool def}) {
  if (v == null) return def;
  if (v is bool) return v;
  if (v == 1 || v == '1' || v == 'true') return true;
  if (v == 0 || v == '0' || v == 'false') return false;
  return def;
}

bool _checkIsRead(Map<String, dynamic> json) {
  // 1. Check the 'reads' array from the API response
  final reads = json['reads'];
  if (reads is List && reads.isNotEmpty) {
    return reads.any((entry) {
      if (entry is Map) {
        final readAt = entry['read_at'];
        return readAt != null &&
            readAt.toString().trim().isNotEmpty &&
            readAt.toString() != 'null';
      }
      return false;
    });
  }

  // 2. Direct read_at check (in case single notification endpoints return read_at directly)
  if (json['read_at'] != null &&
      json['read_at'].toString().trim().isNotEmpty &&
      json['read_at'].toString() != 'null') {
    return true;
  }

  // 3. Fallback to boolean flags if present
  return _boolDef(json['is_read'] ?? json['read'] ?? json['seen'], def: false);
}

DateTime _dateOrNow(dynamic v) {
  if (v == null) return DateTime.now();
  try {
    return DateTime.parse(v.toString()).toLocal();
  } catch (_) {
    return DateTime.now();
  }
}
