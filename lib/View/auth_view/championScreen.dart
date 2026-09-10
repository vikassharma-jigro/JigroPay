import 'package:flutter/material.dart';
import 'package:jigrotech/View/auth_view/otp_screen.dart';
import 'package:jigrotech/View/auth_view/uploadPhoto_screen.dart';
import 'package:jigrotech/app_utils/app_colors.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import 'package:jigrotech/app_utils/font_family.dart';
import 'package:jigrotech/app_utils/text_widget.dart';

import '../../main.dart';

import 'package:jigrotech/View/dashdoard_view/bottom_navigation_bar_screen.dart';

class VerifiedChampionScreen extends StatelessWidget {
  final String? email;
  final String? mobile;
  final bool? isMobile;
  const VerifiedChampionScreen({
    super.key,
    this.email,
    this.mobile,
    this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: white,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()),
                  (route) => false,
                );
              }
            },
            child: const Icon(Icons.arrow_back_ios, color: primaryColor),
          ),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: isMobile == true
                    ? Image.asset(AppImages.mobileVerifiedIcon, height: 260)
                    : Image.asset(
                        AppImages.emailCampaionIcon,
                        fit: BoxFit.cover,
                        height: 260,
                      ),
              ),
              const SizedBox(height: 25),
              Center(
                child: text(
                  "You’re verified!",
                  textColor: blackColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  fontFamily: FontFamily.plusJakartaSansBold,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: text(
                  "Now you can fund your account so you’re ready to invest and pay.",
                  textColor: greyColor,
                  fontSize: 14,
                  textAlign: TextAlign.center,
                  isCentered: true,
                  fontWeight: FontWeight.w400,
                  fontFamily: FontFamily.plusJakartaSansRegular,
                ),
              ),
              const SizedBox(height: 30),
              CommonButton(
                text: "Continue to Dashboard",
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardScreen(),
                    ),
                    (route) => false,
                  );
                },
                gradient: const LinearGradient(
                  colors: [primaryColor, secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
