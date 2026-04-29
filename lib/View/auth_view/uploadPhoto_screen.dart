import 'package:flutter/material.dart';
import 'package:jigrotech/View/auth_view/login_screen.dart';
import 'package:jigrotech/View/auth_view/scan_photo_screen.dart';
import 'package:jigrotech/app_utils/app_colors.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import 'package:jigrotech/app_utils/font_family.dart';
import 'package:jigrotech/app_utils/text_widget.dart';

import '../../main.dart';

class UploadPhotoScreen extends StatelessWidget {
  const UploadPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientAppScaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: purpleGradientColor),
            ),
            SizedBox(height: 50),
            Center(
              child: Image.asset(
                AppImages.personalPhotoIcon,
                fit: BoxFit.cover,
                height: 300,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: text(
                "Upload your photo",

                textColor: blackColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: FontFamily.plusJakartaSansBold,
              ),
            ),
            Center(
              child: text(
                "You need to upload your photo. This is different from account verification",
                textColor: greyColor,
                fontSize: 14,
                textAlign: TextAlign.center,
                isCentered: true,
                fontWeight: FontWeight.w400,
                fontFamily: FontFamily.plusJakartaSansRegular,
              ),
            ),
            SizedBox(height: 25),
            CommonButton(
              text: "Upload Photo",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScanPhotoScreen()),
                );
              },
              gradient: const LinearGradient(
                colors: [pinkColor, purpleGradientColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              fontFamily: FontFamily.plusJakartaSansBold,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
