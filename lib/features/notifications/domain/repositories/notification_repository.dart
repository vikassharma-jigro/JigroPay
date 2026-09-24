import '../../../../core/errors/result.dart';
import '../../data/models/notification_item_model.dart';

abstract class NotificationRepository {
  /// Fetches list of notifications.
  Future<Result<List<NotificationItemModel>>> fetchNotifications();

  /// Marks all notifications as read.
  Future<Result<bool>> markAllRead();

  /// Clears all notifications.
  Future<Result<bool>> clearAll();
}
