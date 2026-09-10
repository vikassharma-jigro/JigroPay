import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../api_services/api_base_helper.dart';
import '../api_services/api_config.dart';
import '../app_utils/app_colors.dart';
import '../model/notification_model.dart';

class NotificationController extends GetxController {
  var notificationList = <NotificationModel>[].obs;
  var unreadCount = 0.obs;
  var isLoading = false.obs;
  var isActionLoading = false.obs;

  /// 1. Fetch All Notifications (GET /auth/notifications)
  Future<void> fetchNotifications(BuildContext context, {bool showLoader = true}) async {
    try {
      if (showLoader) isLoading(true);

      debugPrint("🚀 Calling Fetch Notifications API: $notificationsUrl");
      var response = await ApiBaseHelper().getApiCall(
        false,
        notificationsUrl,
        context,
        isPopup: false,
      );

      if (response != null) {
        List<dynamic> rawList = [];
        if (response is List) {
          rawList = response;
        } else if (response is Map) {
          if (response['data'] != null) {
            if (response['data'] is List) {
              rawList = response['data'];
            } else if (response['data'] is Map && response['data']['data'] != null && response['data']['data'] is List) {
              rawList = response['data']['data'];
            }
          } else if (response['notifications'] != null && response['notifications'] is List) {
            rawList = response['notifications'];
          } else if (response['result'] != null && response['result'] is List) {
            rawList = response['result'];
          }

          if (response['unread_count'] != null) {
            unreadCount.value = int.tryParse(response['unread_count'].toString()) ?? 0;
          } else if (response['unreadCount'] != null) {
            unreadCount.value = int.tryParse(response['unreadCount'].toString()) ?? 0;
          }
        }

        notificationList.value = rawList
            .map((item) => NotificationModel.fromJson(Map<String, dynamic>.from(item)))
            .toList();

        // Calculate unread count if not provided directly in response
        if (response is List || (response is Map && response['unread_count'] == null && response['unreadCount'] == null)) {
          unreadCount.value = notificationList.where((n) => !n.isRead).length;
        }
      }
    } catch (e) {
      debugPrint("⚠️ Exception in fetchNotifications: $e");
    } finally {
      if (showLoader) isLoading(false);
    }
  }

  /// 2. Fetch Unread Notifications / Count (GET /auth/notifications/fetch-unread)
  Future<void> fetchUnreadNotifications(BuildContext context) async {
    try {
      debugPrint("🚀 Calling Fetch Unread Notifications API: $fetchUnreadNotificationsUrl");
      var response = await ApiBaseHelper().getApiCall(
        false,
        fetchUnreadNotificationsUrl,
        context,
        isPopup: false,
      );

      if (response != null && response is Map) {
        if (response['unread_count'] != null) {
          unreadCount.value = int.tryParse(response['unread_count'].toString()) ?? 0;
        } else if (response['count'] != null) {
          unreadCount.value = int.tryParse(response['count'].toString()) ?? 0;
        } else if (response['data'] != null) {
          if (response['data'] is int) {
            unreadCount.value = response['data'];
          } else if (response['data'] is List) {
            unreadCount.value = (response['data'] as List).length;
          }
        }
      }
    } catch (e) {
      debugPrint("⚠️ Exception in fetchUnreadNotifications: $e");
    }
  }

  /// 3. Mark All Notifications as Read (POST / PUT /auth/notifications/mark-all-read)
  Future<void> markAllAsRead(BuildContext context) async {
    try {
      isActionLoading(true);
      debugPrint("🚀 Calling Mark All Read API: $markAllReadNotificationsUrl");
      
      var response = await ApiBaseHelper().postApiCall(
        true,
        markAllReadNotificationsUrl,
        context,
        {},
        isPopup: false,
      );

      // Fallback to PUT if POST fails
      if (response == null || (response is Map && response['status'] == false)) {
        if (!context.mounted) return;
        response = await ApiBaseHelper().putApiCall(
          false,
          markAllReadNotificationsUrl,
          context,
          {},
          isPopup: false,
        );
      }

      // Update local state regardless
      notificationList.value = notificationList.map((n) => n.copyWith(isRead: true)).toList();
      unreadCount.value = 0;

      Fluttertoast.showToast(
        msg: "All notifications marked as read",
        backgroundColor: blueColor,
        textColor: Colors.white,
      );
    } catch (e) {
      debugPrint("⚠️ Exception in markAllAsRead: $e");
    } finally {
      isActionLoading(false);
    }
  }

  /// 4. Mark Single Notification as Read (POST / PUT /auth/notifications/{id}/mark-read)
  Future<void> markAsRead(BuildContext context, dynamic id) async {
    try {
      String endpoint = "auth/notifications/$id/mark-read";
      debugPrint("🚀 Calling Mark Single Read API: $endpoint");

      var response = await ApiBaseHelper().postApiCall(
        false,
        endpoint,
        context,
        {},
        isPopup: false,
      );

      // Fallback to PUT if needed
      if (response == null || (response is Map && response['status'] == false)) {
        if (!context.mounted) return;
        response = await ApiBaseHelper().putApiCall(
          false,
          endpoint,
          context,
          {},
          isPopup: false,
        );
      }

      // Update item in local list
      int index = notificationList.indexWhere((n) => n.id.toString() == id.toString());
      if (index != -1 && !notificationList[index].isRead) {
        notificationList[index] = notificationList[index].copyWith(isRead: true);
        if (unreadCount.value > 0) {
          unreadCount.value--;
        }
      }
    } catch (e) {
      debugPrint("⚠️ Exception in markAsRead: $e");
    }
  }

  /// 5. Clear All Notifications (POST /auth/notifications/clear-all)
  Future<void> clearAllNotifications(BuildContext context) async {
    try {
      isActionLoading(true);
      debugPrint("🚀 Calling Clear All Notifications API: $clearAllNotificationsUrl");

      await ApiBaseHelper().postApiCall(
        true,
        clearAllNotificationsUrl,
        context,
        {},
        isPopup: false,
      );

      notificationList.clear();
      unreadCount.value = 0;

      Fluttertoast.showToast(
        msg: "All notifications cleared",
        backgroundColor: blueColor,
        textColor: Colors.white,
      );
    } catch (e) {
      debugPrint("⚠️ Exception in clearAllNotifications: $e");
    } finally {
      isActionLoading(false);
    }
  }
}
