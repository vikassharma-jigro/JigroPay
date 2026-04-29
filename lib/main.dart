import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jigrotech/splash_screen.dart';
import 'package:screen_protector/screen_protector.dart';
import 'app_utils/app_colors.dart';
import 'app_utils/shared_preferences.dart';

SpUtil? sp;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenProtector.preventScreenshotOn();
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: const FirstSplashWrapper(), // 👈 Gradient + SplashScreen
    );
  }
}

/// Wrapper to show Gradient Status Bar + SplashScreen
class FirstSplashWrapper extends StatelessWidget {
  const FirstSplashWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientAppScaffold(
      body: const FirstSplash(), // 👈 Tumhara existing SplashScreen
    );
  }
}

/// Reusable Scaffold with Gradient Status Bar
class GradientAppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  const GradientAppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      extendBodyBehindAppBar: true, // AppBar ke peeche gradient dikhe
      appBar: appBar,
      body: Stack(
        children: [
          const GradientStatusBar(),
          SafeArea(child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

/// Gradient Status Bar Widget
class GradientStatusBar extends StatelessWidget {
  const GradientStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.top,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            pinkColor, // define in app_colors.dart
            purpleGradientColor, // define in app_colors.dart
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
