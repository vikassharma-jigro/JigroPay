import 'package:flutter/material.dart';
import 'package:jigrotech/View/auth_view/otp_screen.dart';
import 'package:jigrotech/View/auth_view/uploadPhoto_screen.dart';
import 'package:jigrotech/app_utils/app_colors.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import 'package:jigrotech/app_utils/font_family.dart';
import 'package:jigrotech/app_utils/text_widget.dart';

import '../../main.dart';

class VerifiedChampionScreen extends StatelessWidget {
  final String? email;
  final String? mobile;
  final bool? isMobile ;
  const VerifiedChampionScreen({super.key,this.email,this.mobile,this.isMobile});

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
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child:  Icon(Icons.arrow_back_ios,color: purpleGradientColor,),
                ),
                SizedBox(height: 120,),
                Center(
                  child: isMobile==true?Image.asset(AppImages.mobileVerifiedIcon,height: 300,): Image.asset(AppImages.emailCampaionIcon,
                    fit: BoxFit.cover
                    ,height: 300,
                  ),
                ),
                SizedBox(height: 20,),
                Center(
                  child: text(
                      "You’re verified!",
                      textColor: blackColor, fontSize: 20,
                      fontWeight: FontWeight.w600,fontFamily: FontFamily.plusJakartaSansBold
                  ),
                ),
                Center(
                  child: text(
                      "Now you can fund your account so you’re ready to invest in crypto",
                      textColor: greyColor, fontSize: 14,
                      textAlign: TextAlign.center,
                      isCentered: true,
                      fontWeight: FontWeight.w400,fontFamily: FontFamily.plusJakartaSansRegular
                  ),
                ),
                SizedBox(height: 20,),
                CommonButton(text: "Continue",
                    onPressed: (){
                     isMobile==true?
                     Navigator.push(context, MaterialPageRoute(builder: (context) => UploadPhotoScreen(),))
                     :Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen(mobileNumber: mobile,),));
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
          ),
        )
    );
  }
}