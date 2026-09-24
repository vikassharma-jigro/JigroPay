import '../../../../core/constants/app_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/banner_model.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  final ApiClient _apiClient;

  @override
  Future<Result<List<BannerModel>>> fetchBanners() async {
    try {
      final response = await _apiClient.get(AppEndpoints.banners);
      final list = BannerModel.listFromApiResponse(response.data);
      return Success(list);
    } on AppException catch (e) {
      return Error(ServerFailure(e.toString()));
    } catch (e) {
      return Error(ServerFailure('Failed to load banners: $e'));
    }
  }

  @override
  Future<Result<int>> fetchUnreadNotificationCount() async {
    try {
      final response =
          await _apiClient.get(AppEndpoints.fetchUnreadNotifications);
      final data = response.data;
      int count = 0;
      if (data is Map) {
        count = int.tryParse(
                (data['count'] ?? data['unread_count'] ?? 0).toString()) ??
            0;
      } else if (data is int) {
        count = data;
      }
      return Success(count);
    } on AppException catch (e) {
      return Error(ServerFailure(e.toString()));
    } catch (e) {
      return Error(ServerFailure('Failed to fetch unread count: $e'));
    }
  }
}
