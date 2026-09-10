import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigrotech/View/auth_view/onboarding_screen.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import 'app_utils/app_colors.dart';
import 'getx_controller/auth_controller.dart';
import 'main.dart';

import 'package:jigrotech/View/dashdoard_view/bottom_navigation_bar_screen.dart';
import 'app_utils/shared_preferences.dart';

class FirstSplash extends StatefulWidget {
  const FirstSplash({super.key});

  @override
  State<StatefulWidget> createState() => _FirstSplashState();
}

class _FirstSplashState extends State<FirstSplash>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bgFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;

  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    //authController.getProfileApi(context: context);
    super.initState();

    // 1500ms animation controller with easeInOut
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // 1. Purple Gradient Background Fade In
    _bgFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    // 2. Center Logo Scale + Fade
    _logoScaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
      ),
    );

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.85, curve: Curves.easeInOut),
      ),
    );

    // 1000ms delay before animation starts
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _controller.forward();
      }
    });

    // Total delay (1000ms) + animation duration (1500ms) = 2500ms -> Navigate
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;

      bool isLoggedIn = sp?.getBool(SpUtil.IS_LOGGED_IN) ?? false;
      String? token = sp?.getString(SpUtil.ACCESS_TOKEN);

      Widget nextScreen = (isLoggedIn && (token != null && token.isNotEmpty))
          ? DashboardScreen()
          : const OnboardingScreen();

      Get.off(
        () => nextScreen,
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // Purple Gradient Background Fade In
              Positioned.fill(
                child: Opacity(
                  opacity: _bgFadeAnimation.value,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff4a1270),
                          primaryColor,
                          electricPurple,
                          Color(0xff2d0b49),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Image.asset(
                      AppImages.splashBackIcon,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Center Logo Scale + Fade Animation
              Center(
                child: Opacity(
                  opacity: _logoFadeAnimation.value,
                  child: Transform.scale(
                    scale: _logoScaleAnimation.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          AppImages.sppIcon,
                          height: 280,
                          fit: BoxFit.cover,
                        ),
                        // const SizedBox(height: 20),
                        // text(
                        //   "JIGROPAY",
                        //   textColor: blackColor,
                        //   fontSize: 32,
                        //   fontFamily: FontFamily.plusJakartaSansBold,
                        //   fontWeight: FontWeight.w600,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
