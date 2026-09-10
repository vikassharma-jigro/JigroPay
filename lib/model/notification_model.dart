class NotificationModel {
  final dynamic id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final String createdAt;
  final String? link;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    this.type = 'general',
    this.isRead = false,
    this.createdAt = '',
    this.link,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    bool readStatus = false;
    if (json['reads'] != null && json['reads'] is List) {
      readStatus = (json['reads'] as List).isNotEmpty;
    } else if (json['is_read'] != null) {
      if (json['is_read'] is bool) {
        readStatus = json['is_read'];
      } else if (json['is_read'] is int) {
        readStatus = json['is_read'] == 1;
      } else if (json['is_read'] is String) {
        readStatus = json['is_read'] == '1' || json['is_read'].toString().toLowerCase() == 'true';
      }
    } else if (json['read'] != null) {
      if (json['read'] is bool) {
        readStatus = json['read'];
      } else if (json['read'] is int) {
        readStatus = json['read'] == 1;
      }
    } else if (json['read_at'] != null) {
      readStatus = true;
    } else if (json['status'] != null) {
      readStatus = json['status'].toString().toLowerCase() == 'read';
    }

    String formattedDate = json['created_at']?.toString() ?? json['createdAt']?.toString() ?? json['timestamp']?.toString() ?? '';
    if (formattedDate.contains('T')) {
      try {
        DateTime dt = DateTime.parse(formattedDate).toLocal();
        formattedDate = "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
      } catch (_) {}
    }

    return NotificationModel(
      id: json['id'] ?? json['_id'] ?? json['notification_id'] ?? '',
      title: json['title']?.toString() ?? json['heading']?.toString() ?? 'Notification',
      message: json['message']?.toString() ?? json['body']?.toString() ?? json['description']?.toString() ?? '',
      type: json['type']?.toString() ?? json['category']?.toString() ?? 'general',
      isRead: readStatus,
      createdAt: formattedDate,
      link: json['link']?.toString(),
      data: json['data'] is Map<String, dynamic> ? json['data'] : null,
    );
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      message: message,
      type: type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      link: link,
      data: data,
    );
  }
}
