import 'package:flutter/material.dart';
import 'package:jigrotech/View/auth_view/login_screen.dart';
import 'package:jigrotech/View/auth_view/welcome_screen.dart';
import 'package:jigrotech/app_utils/app_colors.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import 'package:jigrotech/app_utils/font_family.dart';
import 'package:jigrotech/app_utils/text_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingItem> _items = [
    OnboardingItem(
      title1: "Every Bill.",
      title2: "One Simple",
      title3: "App.",
      highlightTitle2: true,
      subtitle: "Manage and pay your everyday bills without switching between apps.",
      imagePath: AppImages.onboarding1,
      type: OnboardingType.everyBill,
    ),
    OnboardingItem(
      title1: "Pay Bills.",
      title2: "Fast",
      title3: "Secure.",
      icon: Icons.sentiment_very_satisfied_rounded,
      iconColor: secondaryColor,
      highlightTitle2: true,
      subtitle: "Choose your service, fetch your bill and pay securely in just a few taps.",
      imagePath: AppImages.onboarding2,
      type: OnboardingType.fastSecure,
    ),
    OnboardingItem(
      title1: "Stay Ahead of",
      title2: "Every",
      title3: "Bill.",
      highlightTitle2: true,
      subtitle: "Keep track of upcoming bills and access your payment history anytime.",
      imagePath: AppImages.onboarding3,
      type: OnboardingType.stayAhead,
    ),
  ];

  void _onSkip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _onNext() {
    if (_currentIndex < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _onSkip();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            // Top Bar: Progress Indicators & Skip Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Progress Segmented Bar
                  Expanded(
                    child: Row(
                      children: List.generate(3, (index) {
                        bool isActive = index <= _currentIndex;
                        return Expanded(
                          child: Container(
                            height: 4,
                            margin: const EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              gradient: isActive
                                  ? const LinearGradient(
                                      colors: [primaryColor, secondaryColor],
                                    )
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
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: _onSkip,
                  child: Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: text(
                        "SKIP",
                        textColor: blackColor,
                        fontSize: 12,
                        fontFamily: FontFamily.plusJakartaSansRegular,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // PageView for 3 screens
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                physics: NeverScrollableScrollPhysics(),
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
                       // const Spacer(),
                        // Visual Graphic Illustration
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SizedBox(
                           // height: 320,
                            child: _buildGraphic(item),
                          ),
                        ),

                        // Titles & Subtitle
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: [
                              text(
                                item.title1,
                                textColor: blackColor,
                                fontSize: 32,
                                fontFamily: FontFamily.plusJakartaSansRegular,
                                fontWeight: FontWeight.w400,
                                textAlign: TextAlign.center,
                                isCentered: true,
                              ),
                              const SizedBox(height: 2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  text(
                                    item.title2,
                                    textColor: secondaryColor,
                                    fontSize: 32,
                                    fontFamily: FontFamily.plusJakartaSansBold,
                                    fontWeight: FontWeight.w600,
                                    textAlign: TextAlign.center,
                                    isCentered: true,
                                  ),
                                  if (item.icon != null) ...[
                                    const SizedBox(width: 4),
                                    Icon(
                                      item.icon,
                                      color: item.iconColor ?? secondaryColor,
                                      size: 32,
                                    ),
                                  ],
                                  const SizedBox(width: 6),
                                  text(
                                    item.title3,
                                    textColor: blackColor,
                                    fontSize: 28,
                                    fontFamily: FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                    textAlign: TextAlign.center,
                                    isCentered: true,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              text(
                                item.subtitle,
                                textColor: blackColor,
                                fontSize: 16,
                                fontFamily: FontFamily.plusJakartaSansRegular,
                                textAlign: TextAlign.center,
                                isCentered: true,
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

            // Bottom Navigation Next Button
            Padding(
              padding: const EdgeInsets.only(bottom: 25, top: 10),
              child: GestureDetector(
                onTap: _onNext,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [primaryColor, secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: primaryColor.withOpacity(0.35),
                    //     blurRadius: 15,
                    //     offset: const Offset(0, 8),
                    //   ),
                    // ],
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

  Widget _buildGraphic(OnboardingItem item) {
    return Image.asset(
      item.imagePath,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback custom graphics if static asset PNG is not added yet
        switch (item.type) {
          case OnboardingType.everyBill:
            return _buildEveryBillGraphic();
          case OnboardingType.fastSecure:
            return _buildFastSecureGraphic();
          case OnboardingType.stayAhead:
            return _buildStayAheadGraphic();
        }
      },
    );
  }

  // --- Graphic 1: Every Bill. One Simple App. ---
  Widget _buildEveryBillGraphic() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer dashed orbit circle
        Container(
          width: 260,
          height: 260,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: primaryColor.withOpacity(0.2),
              width: 1.5,
            ),
          ),
        ),
        // Central soft purple background circle
        Container(
          width: 170,
          height: 170,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFF3E8FF).withOpacity(0.6),
          ),
        ),
        // Central Phone Mockup with Wallet
        Container(
          width: 130,
          height: 210,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade800, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              // Dynamic Notch
              Container(
                width: 35,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 15),
              // Inner Wallet App Mockup
              Container(
                width: 50,
                height: 45,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primaryColor, secondaryColor],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 15),
              // Mini list items inside mockup
              ...List.generate(3, (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: secondaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
        // Floating Orbiting Icon Badges
        Positioned(
          top: 25,
          left: 55,
          child: _buildBadgeIcon(Icons.water_drop_rounded, Colors.blue),
        ),
        Positioned(
          top: 35,
          right: 55,
          child: _buildBadgeIcon(Icons.smartphone_rounded, Colors.purple),
        ),
        Positioned(
          top: 130,
          left: 10,
          child: _buildBadgeIcon(Icons.lightbulb_rounded, Colors.amber),
        ),
        Positioned(
          top: 130,
          right: 10,
          child: _buildBadgeIcon(Icons.shield_rounded, primaryColor),
        ),
        Positioned(
          bottom: 25,
          left: 45,
          child: _buildBadgeIcon(Icons.router_rounded, Colors.indigo),
        ),
        Positioned(
          bottom: 35,
          right: 45,
          child: _buildBadgeIcon(Icons.credit_card_rounded, Colors.deepPurple),
        ),
      ],
    );
  }

  // --- Graphic 2: Pay Bills. Fast Secure. ---
  Widget _buildFastSecureGraphic() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Orbit circle
        Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: primaryColor.withOpacity(0.25),
              width: 1.5,
            ),
          ),
        ),
        // Purple avatar circle background
        Container(
          width: 180,
          height: 180,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFF3E8FF),
          ),
        ),
        // Central Illustration Icon / Avatar
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [primaryColor.withOpacity(0.15), secondaryColor.withOpacity(0.15)],
                ),
              ),
              child: const Icon(
                Icons.person_pin_circle_rounded,
                size: 80,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            // Floating Wallet Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.account_balance_wallet_rounded, color: primaryColor, size: 20),
                  SizedBox(width: 6),
                  Icon(Icons.verified_rounded, color: secondaryColor, size: 16),
                ],
              ),
            ),
          ],
        ),
        // Floating Orbit Badges
        Positioned(
          top: 20,
          child: _buildBadgeIcon(Icons.lightbulb_outline_rounded, Colors.amber),
        ),
        Positioned(
          top: 35,
          right: 35,
          child: _buildBadgeIcon(Icons.bolt_rounded, Colors.purple),
        ),
        Positioned(
          top: 100,
          left: 15,
          child: _buildBadgeIcon(Icons.water_rounded, Colors.blue),
        ),
        Positioned(
          top: 110,
          right: 15,
          child: _buildBadgeIcon(Icons.local_fire_department_rounded, Colors.deepOrange),
        ),
        Positioned(
          bottom: 50,
          left: 25,
          child: _buildBadgeIcon(Icons.wifi_rounded, Colors.indigo),
        ),
        Positioned(
          bottom: 55,
          right: 25,
          child: _buildBadgeIcon(Icons.security_rounded, primaryColor),
        ),
      ],
    );
  }

  // --- Graphic 3: Stay Ahead of Every Bill. ---
  Widget _buildStayAheadGraphic() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background Circle
        Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFF3E8FF).withOpacity(0.5),
          ),
        ),
        // Floating Cards Stack
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Upcoming Bills Floating Card
            Container(
              width: 210,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.12),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      text("Upcoming Bills", textColor: Colors.black87, fontSize: 11, fontFamily: FontFamily.plusJakartaSansBold),
                      const Icon(Icons.receipt_long_rounded, color: primaryColor, size: 16),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildMiniBillRow(Icons.lightbulb_rounded, Colors.amber, "3 Days"),
                  const SizedBox(height: 4),
                  _buildMiniBillRow(Icons.water_drop_rounded, Colors.blue, "5 Days"),
                  const SizedBox(height: 4),
                  _buildMiniBillRow(Icons.wifi_rounded, Colors.indigo, "7 Days"),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Payment History Card
            Container(
              width: 210,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.12),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      text("Payment History", textColor: Colors.black87, fontSize: 11, fontFamily: FontFamily.plusJakartaSansBold),
                      const Icon(Icons.check_circle_rounded, color: Colors.green, size: 16),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildMiniHistoryRow(Icons.lightbulb_rounded, Colors.amber),
                  const SizedBox(height: 4),
                  _buildMiniHistoryRow(Icons.water_drop_rounded, Colors.blue),
                ],
              ),
            ),
          ],
        ),
        // Orbit Floating Badges
        Positioned(
          top: 15,
          left: 50,
          child: _buildBadgeIcon(Icons.calendar_month_rounded, Colors.purple),
        ),
        Positioned(
          top: 15,
          right: 50,
          child: _buildBadgeIcon(Icons.notifications_active_rounded, Colors.deepOrange),
        ),
        Positioned(
          bottom: 20,
          left: 30,
          child: _buildBadgeIcon(Icons.analytics_rounded, Colors.indigo),
        ),
        Positioned(
          bottom: 20,
          right: 30,
          child: _buildBadgeIcon(Icons.auto_graph_rounded, secondaryColor),
        ),
      ],
    );
  }

  Widget _buildBadgeIcon(IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }

  Widget _buildMiniBillRow(IconData icon, Color color, String time) {
    return Row(
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 6),
        Expanded(
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(time, style: TextStyle(fontSize: 9, color: Colors.grey.shade600)),
        ),
      ],
    );
  }

  Widget _buildMiniHistoryRow(IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 6),
        Expanded(
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.check_circle, color: Colors.green, size: 12),
      ],
    );
  }
}

enum OnboardingType { everyBill, fastSecure, stayAhead }

class OnboardingItem {
  final String title1;
  final String title2;
  final String title3;
  final IconData? icon;
  final Color? iconColor;
  final bool highlightTitle2;
  final String subtitle;
  final String imagePath;
  final OnboardingType type;

  OnboardingItem({
    required this.title1,
    required this.title2,
    required this.title3,
    this.icon,
    this.iconColor,
    required this.highlightTitle2,
    required this.subtitle,
    required this.imagePath,
    required this.type,
  });
}
