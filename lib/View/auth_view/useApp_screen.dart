import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jigrotech/View/auth_view/login_screen.dart';
import 'package:jigrotech/View/auth_view/signup_screen.dart';
import 'package:jigrotech/app_utils/app_colors.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import 'package:jigrotech/app_utils/font_family.dart';
import 'package:jigrotech/app_utils/text_widget.dart';

import '../../main.dart';
import '../kyc_verfication_view/kyc_verfication_screen.dart';

class UseAppScreen extends StatelessWidget {
  const UseAppScreen({super.key});

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
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios,color: purpleGradientColor,),
              ),
              SizedBox(height: 50,),
              Center(
                child: Image.asset(AppImages.splashIcon,
                  fit: BoxFit.cover
                  ,height: 200,
                ),
              ),
              Center(
                child: text(
                    "JIGROPAY",
                    textColor: purpleGradientColor, fontSize: 22,
                    fontWeight: FontWeight.w400,
                    fontFamily: FontFamily.plusJakartaSansBold
                ),
              ),
              SizedBox(height: 20,),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () async {
                    Navigator.push(context, MaterialPageRoute(builder:(context) => const SignUpScreen(),));
                  },
                  child: RichText(
                    text:  const TextSpan(
                      text: 'Welcome to ',
                      style: TextStyle(color: blackColor,fontSize:14,
                          fontWeight: FontWeight.w400,fontFamily: FontFamily.plusJakartaSansBold),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'JIGROPAY ',
                            style: TextStyle(color: pinkColor,fontSize:14,
                                fontFamily: FontFamily.plusJakartaSansBold,
                                fontWeight: FontWeight.w600)),
                      TextSpan(
                            text: 'APP',
                            style: TextStyle(color: blackColor,fontSize:14,
                                fontFamily: FontFamily.plusJakartaSansBold,fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),

              Center(
                child: text(
                    "Introducing Jigropay  - Simplified Payments. Effortlessly request and make secure transactions anytime, anywhere. Join us now for seamless financial freedom.",
                    textColor: blackColor, fontSize: 10,
                    textAlign: TextAlign.center,
                    isCentered: true,
                    fontWeight: FontWeight.w500,fontFamily: FontFamily.plusJakartaSansRegular
                ),
              ),
              SizedBox(height: 54,),
              CommonButton(text: "USE APP",
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => KycVerficationScreen(),));
                  },
                  gradient: const LinearGradient(
                    colors: [pinkColor, purpleGradientColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w600),
            ],
          ),
        )
    );
  }
}