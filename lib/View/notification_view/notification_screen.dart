import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/text_widget.dart';
import '../../getx_controller/notification_controller.dart';
import '../../model/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController controller = Get.put(NotificationController());
  String _selectedFilter = 'all'; // 'all' or 'unread'

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchNotifications(context);
    });
  }

  IconData _getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'recharge':
      case 'mobile':
        return Icons.phone_android_rounded;
      case 'dth':
        return Icons.tv_rounded;
      case 'payment':
      case 'wallet':
      case 'transaction':
        return Icons.account_balance_wallet_rounded;
      case 'offer':
      case 'promo':
        return Icons.local_offer_rounded;
      case 'security':
      case 'alert':
        return Icons.shield_rounded;
      default:
        return Icons.notifications_active_rounded;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type.toLowerCase()) {
      case 'recharge':
      case 'mobile':
        return primaryColor;
      case 'payment':
      case 'wallet':
      case 'transaction':
        return green1Color;
      case 'offer':
      case 'promo':
        return orangeColor;
      case 'security':
      case 'alert':
        return red1Color;
      default:
        return blueColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightWhite1Color,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: blackColor, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            const Text(
              "Notifications",
              style: TextStyle(
                color: blackColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Obx(() {
              if (controller.unreadCount.value == 0) return const SizedBox.shrink();
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${controller.unreadCount.value}",
                  style: const TextStyle(
                    color: white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: blackColor),
            onSelected: (value) {
              if (value == 'mark_all_read') {
                controller.markAllAsRead(context);
              } else if (value == 'clear_all') {
                _showClearConfirmationDialog();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_all_read',
                child: Row(
                  children: [
                    Icon(Icons.done_all_rounded, color: blueColor, size: 20),
                    SizedBox(width: 10),
                    Text("Mark all as read"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep_rounded, color: red1Color, size: 20),
                    SizedBox(width: 10),
                    Text("Clear all"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs (All / Unread)
          Container(
            color: white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                _buildFilterChip("All", 'all'),
                const SizedBox(width: 10),
                Obx(() => _buildFilterChip(
                  "Unread (${controller.unreadCount.value})",
                  'unread',
                )),
              ],
            ),
          ),
          const Divider(height: 1, color: lightGreyColor),

          // Notification List Area
          Expanded(
            child: RefreshIndicator(
              color: primaryColor,
              onRefresh: () => controller.fetchNotifications(context, showLoader: false),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  );
                }

                List<NotificationModel> displayList = controller.notificationList;
                if (_selectedFilter == 'unread') {
                  displayList = displayList.where((item) => !item.isRead).toList();
                }

                if (displayList.isEmpty) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.65,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.notifications_off_outlined,
                              size: 64,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _selectedFilter == 'unread'
                                ? "No unread notifications"
                                : "No notifications yet",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: blackColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              "We'll notify you when something important arrives.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: greyColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () => controller.fetchNotifications(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            icon: const Icon(Icons.refresh_rounded, size: 18),
                            label: const Text("Refresh"),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  itemCount: displayList.length,
                  itemBuilder: (context, index) {
                    final item = displayList[index];
                    return _buildNotificationCard(item);
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    bool isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : lightGreyColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? white : textColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel item) {
    Color typeColor = _getNotificationColor(item.type);
    IconData typeIcon = _getNotificationIcon(item.type);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: item.isRead ? Colors.transparent : primaryColor.withOpacity(0.3),
          width: item.isRead ? 0 : 1,
        ),
      ),
      color: item.isRead ? white : lightPink1Color.withOpacity(0.5),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (!item.isRead) {
            controller.markAsRead(context, item.id);
          }
          _showNotificationDetailModal(item);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Badge
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(typeIcon, color: typeColor, size: 22),
              ),
              const SizedBox(width: 12),

              // Content
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
                              fontSize: 15,
                              fontWeight: item.isRead ? FontWeight.w600 : FontWeight.bold,
                              color: blackColor,
                            ),
                          ),
                        ),
                        if (!item.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: secondaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: textColor,
                        height: 1.3,
                      ),
                    ),
                    if (item.createdAt.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        item.createdAt,
                        style: const TextStyle(
                          fontSize: 11,
                          color: greyColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotificationDetailModal(NotificationModel item) {
    Color typeColor = _getNotificationColor(item.type);
    IconData typeIcon = _getNotificationIcon(item.type);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: lightGreyColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(typeIcon, color: typeColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: blackColor,
                        ),
                      ),
                      if (item.createdAt.isNotEmpty)
                        Text(
                          item.createdAt,
                          style: const TextStyle(
                            fontSize: 12,
                            color: greyColor,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
              item.message,
              style: const TextStyle(
                fontSize: 14,
                color: textColor,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Close",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearConfirmationDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title:  Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: red1Color),
            SizedBox(width: 10),
            text("Clear Notifications",textColor: blackColor,fontSize: 16),
          ],
        ),
        content:  text(
          "Are you sure you want to clear all notifications?",textColor: blackColor,fontSize: 16
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child:  text("Cancel", textColor: greyColor,fontSize: 16),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.clearAllNotifications(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: red1Color,
              foregroundColor: white,
            ),
            child:  text("Clear All", textColor: white,fontSize: 16),
          ),
        ],
      ),
    );
  }
}
