import 'package:equatable/equatable.dart';
import '../../data/models/notification_item_model.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

final class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

final class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

final class NotificationLoaded extends NotificationState {
  const NotificationLoaded({
    required this.notifications,
  });

  final List<NotificationItemModel> notifications;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  NotificationLoaded copyWith({
    List<NotificationItemModel>? notifications,
  }) {
    return NotificationLoaded(
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object?> get props => [notifications];
}

final class NotificationError extends NotificationState {
  const NotificationError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
