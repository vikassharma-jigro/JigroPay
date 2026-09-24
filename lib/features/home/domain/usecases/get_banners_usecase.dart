import '../../../../core/errors/result.dart';
import '../../data/models/banner_model.dart';
import '../repositories/home_repository.dart';

class GetBannersUseCase {
  const GetBannersUseCase(this._repository);
  final HomeRepository _repository;

  Future<Result<List<BannerModel>>> call() {
    return _repository.fetchBanners();
  }
}
