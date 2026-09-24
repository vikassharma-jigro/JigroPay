import '../../../../core/errors/result.dart';
import '../../data/models/banner_model.dart';

abstract class HomeRepository {
  /// Fetches promotional banners for home carousel.
  Future<Result<List<BannerModel>>> fetchBanners();

  /// Fetches unread notification badge count.
  Future<Result<int>> fetchUnreadNotificationCount();
}
