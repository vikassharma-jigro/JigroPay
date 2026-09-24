import 'package:flutter_test/flutter_test.dart';
import 'package:jigrotech/core/errors/result.dart';
import 'package:jigrotech/features/notifications/data/models/notification_item_model.dart';
import 'package:jigrotech/features/notifications/domain/repositories/notification_repository.dart';
import 'package:jigrotech/features/notifications/domain/usecases/clear_all_notifications_usecase.dart';
import 'package:jigrotech/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:jigrotech/features/notifications/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'package:jigrotech/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:jigrotech/features/notifications/presentation/cubit/notification_state.dart';

class _FakeNotificationRepository implements NotificationRepository {
  @override
  Future<Result<List<NotificationItemModel>>> fetchNotifications() async {
    return Success([
      NotificationItemModel(
        id: 1,
        title: 'Recharge Success',
        body: '₹299 recharged',
        createdAt: DateTime(2024, 1, 1),
        isRead: false,
      ),
      NotificationItemModel(
        id: 2,
        title: 'Bill Paid',
        body: 'Electricity bill paid',
        createdAt: DateTime(2024, 1, 2),
        isRead: false,
      ),
    ]);
  }

  @override
  Future<Result<bool>> markAllRead() async => const Success(true);

  @override
  Future<Result<bool>> clearAll() async => const Success(true);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeNotificationRepository repo;
  late NotificationCubit cubit;

  setUp(() {
    repo = _FakeNotificationRepository();
    cubit = NotificationCubit(
      getNotificationsUseCase: GetNotificationsUseCase(repo),
      markAllNotificationsReadUseCase: MarkAllNotificationsReadUseCase(repo),
      clearAllNotificationsUseCase: ClearAllNotificationsUseCase(repo),
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is NotificationInitial', () {
    expect(cubit.state, equals(const NotificationInitial()));
  });

  test('loadNotifications emits [Loading, Loaded]', () async {
    expectLater(
      cubit.stream,
      emitsInOrder([
        isA<NotificationLoading>(),
        isA<NotificationLoaded>()
            .having((s) => s.notifications.length, 'count', 2)
            .having((s) => s.unreadCount, 'unreadCount', 2),
      ]),
    );

    await cubit.loadNotifications();
  });

  test('markAllAsRead updates all items to isRead true', () async {
    await cubit.loadNotifications();
    await cubit.markAllAsRead();

    final state = cubit.state as NotificationLoaded;
    expect(state.unreadCount, 0);
    expect(state.notifications.every((n) => n.isRead), isTrue);
  });

  test('clearAll clears the notifications list', () async {
    await cubit.loadNotifications();
    await cubit.clearAll();

    final state = cubit.state as NotificationLoaded;
    expect(state.notifications.isEmpty, isTrue);
  });
}
