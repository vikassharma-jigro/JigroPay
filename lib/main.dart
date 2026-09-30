import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:screen_protector/screen_protector.dart';

import 'app.dart';
import 'core/services/notification_service.dart';
import 'core/services/storage_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize secure storage service
  await StorageService.init();

  //. Initialize env
  await dotenv.load(fileName: ".env");

  await NotificationService.initialize();
  await ScreenProtector.preventScreenshotOn();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(const JigroPayApp());
}
