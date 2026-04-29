import 'package:flutter/material.dart';
import 'package:jigrotech/View/auth_view/email_otp_screen.dart';
import 'package:jigrotech/app_utils/app_colors.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import 'package:jigrotech/app_utils/font_family.dart';
import 'package:jigrotech/app_utils/text_widget.dart';

import '../../main.dart';

class VerifiedScreen extends StatelessWidget {
  final String? email;
  final String? mobile;
  const VerifiedScreen({super.key, this.email, this.mobile});

  @override
  Widget build(BuildContext context) {
    return GradientAppScaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios, color: purpleGradientColor),
              ),
              SizedBox(height: 120),
              Center(
                child: Image.asset(
                  AppImages.emailVerifiedIcon,
                  fit: BoxFit.cover,
                  height: 300,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: text(
                  "Verify your email",
                  textColor: blackColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: FontFamily.plusJakartaSansBold,
                ),
              ),
              Center(
                child: text(
                  "We sent a verification email to. Please tap the\nlink inside that email to continiue",
                  textColor: greyColor,
                  fontSize: 14,
                  textAlign: TextAlign.center,
                  isCentered: true,
                  fontWeight: FontWeight.w400,
                  fontFamily: FontFamily.plusJakartaSansRegular,
                ),
              ),
              SizedBox(height: 20),
              CommonButton(
                text: "Continue",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EmailOtpScreen(email: email, mobile: mobile),
                    ),
                  );
                },
                gradient: const LinearGradient(
                  colors: [pinkColor, purpleGradientColor],
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
    );
  }
}
