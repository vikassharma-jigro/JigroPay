import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../data/models/notification_item_model.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/usecases/clear_all_notifications_usecase.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_all_notifications_read_usecase.dart';
import '../cubit/notification_cubit.dart';
import '../cubit/notification_state.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = NotificationRepositoryImpl();
    return BlocProvider(
      create: (context) => NotificationCubit(
        getNotificationsUseCase: GetNotificationsUseCase(repo),
        markAllNotificationsReadUseCase: MarkAllNotificationsReadUseCase(repo),
        clearAllNotificationsUseCase: ClearAllNotificationsUseCase(repo),
      )..loadNotifications(),
      child: const _NotificationView(),
    );
  }
}

class _NotificationView extends StatelessWidget {
  const _NotificationView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontFamily: AppTypography.outfitBold,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state is NotificationLoaded &&
                  state.notifications.isNotEmpty) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: AppColors.black),
                  onSelected: (action) {
                    if (action == 'mark_read') {
                      context.read<NotificationCubit>().markAllAsRead();
                    } else if (action == 'clear_all') {
                      context.read<NotificationCubit>().clearAll();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'mark_read',
                      child: Text('Mark all as read'),
                    ),
                    // const PopupMenuItem(
                    //   value: 'clear_all',
                    //   child: Text('Clear all'),
                    // ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (state is NotificationError) {
            return Center(
              child: EmptyStateWidget(
                icon: Icons.error_outline,
                title: 'Unable to Load Notifications',
                subtitle: state.message,
                actionLabel: 'Retry',
                onAction: () =>
                    context.read<NotificationCubit>().loadNotifications(),
              ),
            );
          }

          if (state is NotificationLoaded) {
            final list = state.notifications;
            if (list.isEmpty) {
              return const EmptyStateWidget(
                icon: Icons.notifications_none_rounded,
                title: 'No Notifications',
                subtitle: 'You are all caught up! No new notifications.',
              );
            }

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () =>
                  context.read<NotificationCubit>().loadNotifications(),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return _buildNotificationCard(list[index]);
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItemModel item) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: item.isRead
            ? AppColors.white
            : AppColors.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.isRead
              ? AppColors.border
              : AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: AppTypography.outfitBold,
                          color: AppColors.black,
                          fontWeight: item.isRead
                              ? FontWeight.w500
                              : FontWeight.w700,
                        ),
                      ),
                    ),
                    if (!item.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.body,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: AppTypography.outfitRegular,
                    color: AppColors.text,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  DateFormatter.toRelative(item.createdAt),
                  style: const TextStyle(
                    fontSize: 11,
                    fontFamily: AppTypography.outfitRegular,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
