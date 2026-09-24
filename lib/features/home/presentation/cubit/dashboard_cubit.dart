import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/result.dart';
import '../../data/models/banner_model.dart';
import '../../domain/usecases/get_banners_usecase.dart';
import '../../domain/usecases/get_unread_notifications_count_usecase.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({
    required GetBannersUseCase getBannersUseCase,
    required GetUnreadNotificationsCountUseCase
        getUnreadNotificationsCountUseCase,
  })  : _getBannersUseCase = getBannersUseCase,
        _getUnreadNotificationsCountUseCase =
            getUnreadNotificationsCountUseCase,
        super(const DashboardInitial());

  final GetBannersUseCase _getBannersUseCase;
  final GetUnreadNotificationsCountUseCase _getUnreadNotificationsCountUseCase;

  /// Loads banners and unread notification count lazily upon screen open.
  Future<void> loadDashboard() async {
    emit(const DashboardLoading());

    final results = await Future.wait([
      _getBannersUseCase(),
      _getUnreadNotificationsCountUseCase(),
    ]);

    final bannerResult = results[0] as Result<List<BannerModel>>;
    final unreadResult = results[1] as Result<int>;

    final banners = bannerResult is Success<List<BannerModel>>
        ? bannerResult.data
        : <BannerModel>[];

    final unreadCount =
        unreadResult is Success<int> ? unreadResult.data : 0;

    emit(DashboardLoaded(
      banners: banners,
      unreadCount: unreadCount,
    ));
  }

  void refreshUnreadCount() async {
    final result = await _getUnreadNotificationsCountUseCase();
    if (result is Success<int> && state is DashboardLoaded) {
      final current = state as DashboardLoaded;
      emit(current.copyWith(unreadCount: result.data));
    }
  }
}
