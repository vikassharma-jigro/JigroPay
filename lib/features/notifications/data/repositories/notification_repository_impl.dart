import '../../../../core/constants/app_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/notification_item_model.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  final ApiClient _apiClient;

  @override
  Future<Result<List<NotificationItemModel>>> fetchNotifications() async {
    try {
      final response = await _apiClient.get(AppEndpoints.notifications);
      _apiClient.throwIfError(response);
      final list = NotificationItemModel.listFromApiResponse(response.data);
      return Success(list);
    } on AppException catch (e) {
      return Error(ServerFailure(e.toString()));
    } catch (e) {
      return Error(ServerFailure('Failed to load notifications: $e'));
    }
  }

  @override
  Future<Result<bool>> markAllRead() async {
    try {
      await _apiClient.post(AppEndpoints.markAllReadNotifications);
      return const Success(true);
    } on AppException catch (e) {
      return Error(ServerFailure(e.toString()));
    } catch (e) {
      return Error(ServerFailure('Failed to mark notifications read: $e'));
    }
  }

  @override
  Future<Result<bool>> clearAll() async {
    try {
      await _apiClient.post(AppEndpoints.clearAllNotifications);
      return const Success(true);
    } on AppException catch (e) {
      return Error(ServerFailure(e.toString()));
    } catch (e) {
      return Error(ServerFailure('Failed to clear notifications: $e'));
    }
  }
}
