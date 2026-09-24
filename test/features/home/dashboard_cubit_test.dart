import 'package:flutter_test/flutter_test.dart';
import 'package:jigrotech/core/errors/result.dart';
import 'package:jigrotech/features/home/data/models/banner_model.dart';
import 'package:jigrotech/features/home/domain/repositories/home_repository.dart';
import 'package:jigrotech/features/home/domain/usecases/get_banners_usecase.dart';
import 'package:jigrotech/features/home/domain/usecases/get_unread_notifications_count_usecase.dart';
import 'package:jigrotech/features/home/presentation/cubit/dashboard_cubit.dart';
import 'package:jigrotech/features/home/presentation/cubit/dashboard_state.dart';

class _FakeHomeRepository implements HomeRepository {
  @override
  Future<Result<List<BannerModel>>> fetchBanners() async {
    return const Success([
      BannerModel(id: 1, imageUrl: 'https://example.com/banner1.jpg', title: 'Banner 1'),
      BannerModel(id: 2, imageUrl: 'https://example.com/banner2.jpg', title: 'Banner 2'),
    ]);
  }

  @override
  Future<Result<int>> fetchUnreadNotificationCount() async {
    return const Success(3);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeHomeRepository repo;
  late DashboardCubit cubit;

  setUp(() {
    repo = _FakeHomeRepository();
    cubit = DashboardCubit(
      getBannersUseCase: GetBannersUseCase(repo),
      getUnreadNotificationsCountUseCase:
          GetUnreadNotificationsCountUseCase(repo),
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is DashboardInitial', () {
    expect(cubit.state, equals(const DashboardInitial()));
  });

  test('loadDashboard emits [Loading, Loaded] with banners and count', () async {
    expectLater(
      cubit.stream,
      emitsInOrder([
        isA<DashboardLoading>(),
        isA<DashboardLoaded>()
            .having((s) => s.banners.length, 'banners count', 2)
            .having((s) => s.unreadCount, 'unread count', 3),
      ]),
    );

    await cubit.loadDashboard();
  });
}
