import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/result.dart';
import '../../domain/usecases/clear_all_notifications_usecase.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_all_notifications_read_usecase.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit({
    required GetNotificationsUseCase getNotificationsUseCase,
    required MarkAllNotificationsReadUseCase markAllNotificationsReadUseCase,
    required ClearAllNotificationsUseCase clearAllNotificationsUseCase,
  })  : _getNotificationsUseCase = getNotificationsUseCase,
        _markAllNotificationsReadUseCase = markAllNotificationsReadUseCase,
        _clearAllNotificationsUseCase = clearAllNotificationsUseCase,
        super(const NotificationInitial());

  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkAllNotificationsReadUseCase _markAllNotificationsReadUseCase;
  final ClearAllNotificationsUseCase _clearAllNotificationsUseCase;

  /// Loads notifications on screen open.
  Future<void> loadNotifications() async {
    emit(const NotificationLoading());
    final result = await _getNotificationsUseCase();
    switch (result) {
      case Success(:final data):
        emit(NotificationLoaded(notifications: data));
      case Error(:final failure):
        emit(NotificationError(failure.message));
    }
  }

  /// Marks all notifications read.
  Future<void> markAllAsRead() async {
    if (state is! NotificationLoaded) return;
    final current = state as NotificationLoaded;

    final updated =
        current.notifications.map((n) => n.copyWith(isRead: true)).toList();
    emit(NotificationLoaded(notifications: updated));

    await _markAllNotificationsReadUseCase();
  }

  /// Clears all notifications.
  Future<void> clearAll() async {
    emit(const NotificationLoaded(notifications: []));
    await _clearAllNotificationsUseCase();
  }
}
