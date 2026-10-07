import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import '../services/storage_service.dart';

/// Background FCM handler — must be top-level and annotated.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint(
    '[FCM:BG] id=${message.messageId} | '
    'title=${message.notification?.title}',
  );
}

/// Centralised notification service for JigroPay.
///
/// Extracts all FCM + flutter_local_notifications logic from [main.dart].
/// Call [NotificationService.initialize()] once in [main()] after Firebase init.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Used for important JigroPay notifications.',
    importance: Importance.high,
  );

  // ── Initialization ────────────────────────────────────────────────────────────

  static Future<void> initialize() async {
    // 1. Register background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 2. Request permissions
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    // 3. Fetch & persist FCM token
    try {
      if (!kIsWeb && Platform.isIOS) {
        // On iOS, an APNS token must be registered with Apple before FCM can generate a registration token.
        // It may take several seconds on first launch on a real device.
        String? apnsToken = await messaging.getAPNSToken();
        int attempts = 0;
        while (apnsToken == null && attempts < 10) {
          await Future.delayed(const Duration(seconds: 1));
          apnsToken = await messaging.getAPNSToken();
          attempts++;
        }

        if (apnsToken == null) {
          debugPrint(
            '[FCM] APNS token is still null after $attempts attempts.\n'
            'IMPORTANT: iOS Simulators cannot receive remote APNs push notifications from Firebase.\n'
            'Please test on a physical iOS device with an active Apple Developer profile and APNs Key (.p8).',
          );
        } else {
          debugPrint('[FCM] APNS token obtained successfully.');
          final token = await messaging.getToken();
          if (token != null) {
            await StorageService.instance.setFcmToken(token);
            debugPrint('[FCM] iOS FCM registration token: $token');
          }
        }
      } else {
        final token = await messaging.getToken();
        if (token != null) {
          await StorageService.instance.setFcmToken(token);
          debugPrint('[FCM] FCM registration token: $token');
        }
      }
    } catch (e) {
      debugPrint('[FCM] Failed to get token: $e');
    }

    // Listen for token refreshes (e.g. when APNS token becomes available)
    messaging.onTokenRefresh.listen((token) async {
      await StorageService.instance.setFcmToken(token);
      debugPrint('[FCM] Token refreshed: $token');
    });

    // 4. Initialise local notifications plugin
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await instance._localNotifications.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: (response) {
        debugPrint('[FCM:local] tapped payload=${response.payload}');
      },
    );

    // 5. Create Android high-importance channel
    await instance._localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    // 6. Set iOS foreground presentation (delegated to flutter_local_notifications for rich media support)
    await messaging.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: true,
      sound: false,
    );

    // 7. Listen for foreground messages
    FirebaseMessaging.onMessage.listen(instance._onForegroundMessage);

    // 8. Background open (app in background, user tapped)
    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      debugPrint('[FCM:BG-open] id=${msg.messageId}');
    });

    // 9. Terminated open (app was closed, user tapped)
    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('[FCM:terminated-open] id=${initialMessage.messageId}');
    }
  }

  // ── Foreground message handler ────────────────────────────────────────────────

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    debugPrint(
      '[FCM:FG] id=${message.messageId} | '
      'title=${message.notification?.title}',
    );

    final notification = message.notification;
    if (notification == null) return;

    final imageUrl =
        notification.android?.imageUrl ??
        notification.apple?.imageUrl ??
        message.data['image'] as String? ??
        message.data['imageUrl'] as String?;

    BigPictureStyleInformation? bigPicture;
    String? iosImagePath;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      final androidBitmap = await _downloadBitmap(imageUrl);
      if (androidBitmap != null) {
        bigPicture = BigPictureStyleInformation(
          androidBitmap,
          largeIcon: androidBitmap,
          contentTitle: notification.title,
          summaryText: notification.body,
        );
      }
      iosImagePath = await _downloadFile(imageUrl, 'fcm_img.jpg');
    }

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          icon: '@mipmap/ic_launcher',
          importance: Importance.high,
          priority: Priority.high,
          styleInformation: bigPicture,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          attachments: iosImagePath != null
              ? [DarwinNotificationAttachment(iosImagePath)]
              : null,
        ),
      ),
    );
  }

  // ── Image download helpers (using Dio, not http package) ──────────────────────

  static final _dio = Dio(
    BaseOptions(connectTimeout: const Duration(seconds: 10)),
  );

  static Future<ByteArrayAndroidBitmap?> _downloadBitmap(String url) async {
    try {
      final response = await _dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200 && response.data != null) {
        return ByteArrayAndroidBitmap(Uint8List.fromList(response.data!));
      }
    } catch (e) {
      debugPrint('[NotificationService] bitmap download error: $e');
    }
    return null;
  }

  static Future<String?> _downloadFile(String url, String fileName) async {
    try {
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/$fileName';
      final response = await _dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200 && response.data != null) {
        await File(filePath).writeAsBytes(response.data!);
        return filePath;
      }
    } catch (e) {
      debugPrint('[NotificationService] file download error: $e');
    }
    return null;
  }
}
