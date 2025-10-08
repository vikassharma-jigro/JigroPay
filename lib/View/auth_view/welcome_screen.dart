import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jigrotech/View/auth_view/login_screen.dart';
import 'package:jigrotech/View/auth_view/signup_screen.dart';
import 'package:jigrotech/app_utils/app_colors.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import 'package:jigrotech/app_utils/font_family.dart';
import 'package:jigrotech/app_utils/text_widget.dart';

import '../../main.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientAppScaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.businessIcon,
              fit: BoxFit.cover
              ,height: 300,
              ),
            SizedBox(height: 20,),
            Center(
              child: text(
                  "Welcome to JIGROPAY",
                  textColor: blackColor, fontSize: 22,
                  fontWeight: FontWeight.w400,fontFamily: FontFamily.plusJakartaSansMedium
              ),
            ),
            SizedBox(height: 14,),
            CommonButton(text: "Create your account ",
                onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                },
                gradient: const LinearGradient(
                  colors: [pinkColor, purpleGradientColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                fontFamily: FontFamily.plusJakartaSansRegular,
                fontWeight: FontWeight.w400),
            SizedBox(height: 14,),
            text(
                "I already have an account",
                textColor: blackColor, fontSize: 14,
                fontWeight: FontWeight.w400,fontFamily: FontFamily.plusJakartaSansRegular
            ),
          ],
        ),
      )
    );
  }
}