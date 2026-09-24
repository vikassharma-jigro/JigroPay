import '../../../../core/errors/result.dart';
import '../repositories/notification_repository.dart';

class ClearAllNotificationsUseCase {
  const ClearAllNotificationsUseCase(this._repository);
  final NotificationRepository _repository;

  Future<Result<bool>> call() {
    return _repository.clearAll();
  }
}
