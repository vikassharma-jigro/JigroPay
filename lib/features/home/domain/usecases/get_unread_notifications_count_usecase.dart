import '../../../../core/errors/result.dart';
import '../repositories/home_repository.dart';

class GetUnreadNotificationsCountUseCase {
  const GetUnreadNotificationsCountUseCase(this._repository);
  final HomeRepository _repository;

  Future<Result<int>> call() {
    return _repository.fetchUnreadNotificationCount();
  }
}
