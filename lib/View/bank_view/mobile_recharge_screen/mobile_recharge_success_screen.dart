import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/View/dashdoard_view/bottom_navigation_bar_screen.dart';
import 'package:jigrotech/app_utils/app_images.dart';

import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';



class MobileRechargeSuccessScreen extends StatefulWidget {

  const MobileRechargeSuccessScreen({super.key,});

  @override
  State<MobileRechargeSuccessScreen> createState() => _MobileRechargeSuccessScreenState();
}


class _MobileRechargeSuccessScreenState extends State<MobileRechargeSuccessScreen> {

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return GradientAppScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:   Row(
          children: [
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child:  Icon(Icons.arrow_back_ios,color: white,),
            ),
            // SizedBox(width: 10,),
          ],
        ),
      ),

      body: Container(
        color: lightGreyColor,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 20,),
                SvgPicture.asset(AppImages.successImage,color: purpleGradientColor,),
                SizedBox(height: 20,),
                text("Mobile Recharge Success",
                    textColor:purpleGradientColor,fontSize: 18,
                    fontFamily: FontFamily.plusJakartaSansBold,
                    fontWeight: FontWeight.w700),
                SizedBox(height: 10,),
                text("00000",
                    textColor:greyColor,fontSize: 16,
                    fontFamily: FontFamily.plusJakartaSansRegular,
                    fontWeight: FontWeight.w400),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text("Transaction ID",
                        textAlign: TextAlign.center,
                        isCentered: true,
                        textColor:purpleGradientColor,fontSize: 18,
                        fontFamily: FontFamily.plusJakartaSansRegular,
                        fontWeight: FontWeight.w600),
                    text("#71L69PJK3",
                        textAlign: TextAlign.center,
                        isCentered: true,
                        textColor:greyColor,fontSize: 14,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontWeight: FontWeight.w400),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text("Amount",
                        textAlign: TextAlign.center,
                        isCentered: true,
                        textColor:purpleGradientColor,fontSize: 18,
                        fontFamily: FontFamily.plusJakartaSansMedium,
                        fontWeight: FontWeight.w600),
                    text("₹29.00",
                        textAlign: TextAlign.center,
                        isCentered: true,
                        textColor:greyColor,fontSize: 14,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontWeight: FontWeight.w400),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text("Charge",
                        textAlign: TextAlign.center,
                        isCentered: true,
                        textColor:purpleGradientColor,fontSize: 18,
                        fontFamily: FontFamily.plusJakartaSansMedium,
                        fontWeight: FontWeight.w600),
                    text("+2",
                        textAlign: TextAlign.center,
                        isCentered: true,
                        textColor:blackColor,fontSize: 14,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontWeight: FontWeight.w400),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text("Total Amount",
                        textAlign: TextAlign.center,
                        isCentered: true,
                        textColor:purpleGradientColor,fontSize: 18,
                        fontFamily: FontFamily.plusJakartaSansMedium,
                        fontWeight: FontWeight.w600),
                    text("₹29.00",
                        textAlign: TextAlign.center,
                        isCentered: true,
                        textColor:blackColor,fontSize: 14,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontWeight: FontWeight.w400),
                  ],
                ),

                SizedBox(height: 10,),
                Divider(height: 10,thickness: .5,),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.call,color: purpleGradientColor,),
                        text("Call",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor:purpleGradientColor,fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w400),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.message,color: purpleGradientColor,),
                        text("Message",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor:purpleGradientColor,fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w400),
                      ],
                    ),
                  ],
                ),
                Divider(height: 10,thickness: .5,),
                SizedBox(height: 30,),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: 55,
                  child: CommonButton(
                      text: "Back To Home",
                      textColor: white,
                      gradient: const LinearGradient(
                        colors: [pinkColor, purpleGradientColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.plusJakartaSansBold,
                      fontSize:18.0,
                      //padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                      //borderRadius: BorderRadius.circular(40.0),

                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen(),));
                      }



                  ),
                ),
              ],
            ),
          ),
        ),
      ),



    );
  }

}




