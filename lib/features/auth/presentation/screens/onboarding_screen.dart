import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/services/storage_service.dart';

enum OnboardingType { everyBill, fastSecure, stayAhead }

class OnboardingItem {
  final String title1;
  final String title2;
  final String title3;
  final bool highlightTitle2;
  final String subtitle;
  final String imagePath;
  final IconData? icon;
  final Color? iconColor;
  final OnboardingType type;

  const OnboardingItem({
    required this.title1,
    required this.title2,
    required this.title3,
    required this.subtitle,
    required this.imagePath,
    required this.type,
    this.highlightTitle2 = false,
    this.icon,
    this.iconColor,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingItem> _items = const [
    OnboardingItem(
      title1: 'Every Bill.',
      title2: 'One Simple',
      title3: 'App.',
      highlightTitle2: true,
      subtitle:
          'Manage and pay your everyday bills without switching between apps.',
      imagePath: AppAssets.onboarding1,
      type: OnboardingType.everyBill,
    ),
    OnboardingItem(
      title1: 'Pay Bills.',
      title2: 'Fast',
      title3: 'Secure.',
      icon: Icons.sentiment_very_satisfied_rounded,
      iconColor: AppColors.secondary,
      highlightTitle2: true,
      subtitle:
          'Choose your service, fetch your bill and pay securely in just a few taps.',
      imagePath: AppAssets.onboarding2,
      type: OnboardingType.fastSecure,
    ),
    OnboardingItem(
      title1: 'Stay Ahead of',
      title2: 'Every',
      title3: 'Bill.',
      highlightTitle2: true,
      subtitle:
          'Keep track of upcoming bills and access your payment history anytime.',
      imagePath: AppAssets.onboarding3,
      type: OnboardingType.stayAhead,
    ),
  ];

  Future<void> _completeOnboarding() async {
    await StorageService.instance.setOnboardingShown();
    if (mounted) {
      context.go('/login');
    }
  }

  void _onNext() {
    if (_currentIndex < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Top Bar: Progress Indicators & Skip Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: List.generate(_items.length, (index) {
                        final isActive = index <= _currentIndex;
                        return Expanded(
                          child: Container(
                            height: 4,
                            margin: const EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              gradient: isActive
                                  ? AppColors.brandGradient
                                  : null,
                              color: isActive ? null : Colors.grey.shade300,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: _completeOnboarding,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'SKIP',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 12,
                          fontFamily: AppTypography.outfitRegular,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Image.asset(
                            item.imagePath,
                            fit: BoxFit.contain,
                            height: 320,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox(height: 320),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: [
                              Text(
                                item.title1,
                                style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 32,
                                  fontFamily: AppTypography.outfitRegular,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item.title2,
                                    style: const TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 32,
                                      fontFamily: AppTypography.outfitBold,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  if (item.icon != null) ...[
                                    const SizedBox(width: 4),
                                    Icon(
                                      item.icon,
                                      color:
                                          item.iconColor ?? AppColors.secondary,
                                      size: 32,
                                    ),
                                  ],
                                  const SizedBox(width: 6),
                                  Text(
                                    item.title3,
                                    style: const TextStyle(
                                      color: AppColors.black,
                                      fontSize: 28,
                                      fontFamily: AppTypography.outfitRegular,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.subtitle,
                                style: const TextStyle(
                                  color: AppColors.text,
                                  fontSize: 16,
                                  fontFamily: AppTypography.outfitRegular,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25, top: 10),
              child: GestureDetector(
                onTap: _onNext,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppColors.brandGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
