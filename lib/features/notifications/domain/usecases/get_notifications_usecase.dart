import '../../../../core/errors/result.dart';
import '../../data/models/notification_item_model.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsUseCase {
  const GetNotificationsUseCase(this._repository);
  final NotificationRepository _repository;

  Future<Result<List<NotificationItemModel>>> call() {
    return _repository.fetchNotifications();
  }
}
