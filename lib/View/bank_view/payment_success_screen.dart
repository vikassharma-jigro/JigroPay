import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/font_family.dart';
import '../../app_utils/text_widget.dart';
import '../../main.dart';


class PaymentSuccessScreen extends StatefulWidget {
  final String? bankName;
  const PaymentSuccessScreen({super.key,this.bankName});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}


class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {

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
                SvgPicture.asset(AppImages.successImage),
                SizedBox(height: 20,),
                text("Bank account balance\nfetched successfully",
                    textColor:blackColor,fontSize: 18,
                    fontFamily: FontFamily.plusJakartaSansBold,
                    fontWeight: FontWeight.w700),
                SizedBox(height: 20,),
                SvgPicture.asset(AppImages.rajImage),
                SizedBox(height: 10,),
                text("State Bank Of India",
                    textColor:blackColor,fontSize: 16,
                    fontFamily: FontFamily.plusJakartaSansRegular,
                    fontWeight: FontWeight.w400),
                SizedBox(height: 10,),
                text("₹68,151.62",
                    textColor:blackColor,fontSize: 36,
                    fontFamily: FontFamily.plusJakartaSansBold,
                    fontWeight: FontWeight.w600),
                SizedBox(height: 10,),
                SvgPicture.asset(AppImages.phoneBannerImage),
                const SizedBox(height: 50,),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: 55,
                  child: CommonButton(
                      text: "Done",
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




