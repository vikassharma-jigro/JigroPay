import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../cubit/splash_cubit.dart';
import '../cubit/splash_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _bgFadeAnimation;
  late final Animation<double> _logoScaleAnimation;
  late final Animation<double> _logoFadeAnimation;

  bool _animationCompleted = false;
  SplashState? _pendingState;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _bgFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

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

    // Start startup route check via Cubit
    context.read<SplashCubit>().determineStartupRoute();

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationCompleted = true;
        if (_pendingState != null) {
          _navigate(_pendingState!);
        }
      }
    });
  }

  void _navigate(SplashState state) {
    if (!mounted) return;
    switch (state) {
      case SplashAuthenticated():
        context.go('/dashboard');
      case SplashUnauthenticated(:final showOnboarding):
        context.go(showOnboarding ? '/onboarding' : '/login');
      case SplashInitial():
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        _pendingState = state;
        if (_animationCompleted) {
          _navigate(state);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
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
                            AppColors.primary,
                            AppColors.electricPurple,
                            Color(0xff2d0b49),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Image.asset(
                        AppAssets.splashBack,
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
                      child: Image.asset(
                        AppAssets.spp,
                        height: 280,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
