import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:jigrotech/splash_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:get/get.dart';
import 'app_utils/shared_preferences.dart';
import 'firebase_options.dart';

SpUtil? sp;

// Background messaging handler (Must be top-level & annotated)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("=================== BACKGROUND NOTIFICATION ===================");
  debugPrint("Message ID: ${message.messageId}");
  debugPrint("Title: ${message.notification?.title}");
  debugPrint("Body: ${message.notification?.body}");
  debugPrint("Data Payload: ${message.data}");
  debugPrint("===============================================================");
}

// Local Notifications plugin instance & high-importance channel configuration
final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel _channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

// Helper function to download image bytes for Android BigPicture notification
Future<ByteArrayAndroidBitmap?> _getByteArrayFromUrl(String? url) async {
  if (url == null || url.trim().isEmpty) return null;
  try {
    final http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return ByteArrayAndroidBitmap(response.bodyBytes);
    }
  } catch (e) {
    debugPrint("Error downloading notification image: $e");
  }
  return null;
}

// Helper function to download image file for iOS notification attachments
Future<String?> _downloadAndSaveFile(String? url, String fileName) async {
  if (url == null || url.trim().isEmpty) return null;
  try {
    final Directory directory = await getTemporaryDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    }
  } catch (e) {
    debugPrint("Error saving notification image for iOS: $e");
  }
  return null;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Register background messaging handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await ScreenProtector.preventScreenshotOn();

  // Transparent status bar with light icons
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  sp = await SpUtil.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initPushNotifications();
  }

  Future<void> _initPushNotifications() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // 1. Request Push Notification permissions
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    debugPrint('User granted notification permission: ${settings.authorizationStatus}');

    // 2. Fetch FCM Token
    try {
      String? token = await messaging.getToken();
      debugPrint("FCM Token =========> $token");
    } catch (e) {
      debugPrint("Error getting FCM Token: $e");
    }

    // 3. Initialize Local Notifications for Foreground display
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint("Notification clicked with payload: ${response.payload}");
      },
    );

    // 4. Create Android Notification Channel
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // 5. Set foreground presentation options
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 6. Listen for Foreground Messages with Image Support & Print Logs
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("=================== FOREGROUND NOTIFICATION ===================");
      debugPrint("Message ID: ${message.messageId}");
      debugPrint("Title: ${message.notification?.title}");
      debugPrint("Body: ${message.notification?.body}");
      debugPrint("Data Payload: ${message.data}");
      debugPrint("===============================================================");

      RemoteNotification? notification = message.notification;

      // Extract Image URL if present in notification payload or data payload
      String? imageUrl = notification?.android?.imageUrl ??
          notification?.apple?.imageUrl ??
          message.data['image'] ??
          message.data['imageUrl'];

      BigPictureStyleInformation? bigPictureStyleInformation;
      String? iosImagePath;

      if (imageUrl != null && imageUrl.isNotEmpty) {
        ByteArrayAndroidBitmap? byteArrayAndroidBitmap =
            await _getByteArrayFromUrl(imageUrl);
        if (byteArrayAndroidBitmap != null) {
          bigPictureStyleInformation = BigPictureStyleInformation(
            byteArrayAndroidBitmap,
            largeIcon: byteArrayAndroidBitmap,
            contentTitle: notification?.title,
            summaryText: notification?.body,
          );
        }
        iosImagePath = await _downloadAndSaveFile(imageUrl, 'notification_img.jpg');
      }

      if (notification != null) {
        _flutterLocalNotificationsPlugin.show(
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
              styleInformation: bigPictureStyleInformation,
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
    });

    // 7. Listen for Background App Open (User clicked notification while app in background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("=================== NOTIFICATION OPENED (BACKGROUND) ===================");
      debugPrint("Message ID: ${message.messageId}");
      debugPrint("Title: ${message.notification?.title}");
      debugPrint("Body: ${message.notification?.body}");
      debugPrint("Data Payload: ${message.data}");
      debugPrint("=========================================================================");
    });

    // 8. Check for Terminated App Open (User clicked notification when app was closed)
    RemoteMessage? initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint("=================== NOTIFICATION OPENED (TERMINATED) ===================");
      debugPrint("Message ID: ${initialMessage.messageId}");
      debugPrint("Title: ${initialMessage.notification?.title}");
      debugPrint("Body: ${initialMessage.notification?.body}");
      debugPrint("Data Payload: ${initialMessage.data}");
      debugPrint("=========================================================================");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: const FirstSplash(), // 👈 Gradient + SplashScreen
    );
  }
}
