import '../../../../core/errors/result.dart';
import '../repositories/notification_repository.dart';

class MarkAllNotificationsReadUseCase {
  const MarkAllNotificationsReadUseCase(this._repository);
  final NotificationRepository _repository;

  Future<Result<bool>> call() {
    return _repository.markAllRead();
  }
}
