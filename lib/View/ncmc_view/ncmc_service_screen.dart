
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/View/ncmc_view/ncmc_account_screen.dart';
import 'package:jigrotech/app_utils/app_images.dart';

import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';



class NcmcServiceScreen extends StatefulWidget {

  const NcmcServiceScreen({super.key,});

  @override
  State<NcmcServiceScreen> createState() => _NcmcServiceScreenState();
}


class _NcmcServiceScreenState extends State<NcmcServiceScreen> {
  List<String> options = [
    "Airtel Payments Bank RuPay NCMC",
    "HDFC Bank NCMC Pune Metro",
    "MufinPay NCMC",
    "Pine Labs RuPay NCMC Card Top-Up",
    "State Bank of India NCMC Card Top-Up",
  ];
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child:  Icon(Icons.arrow_back_ios,color: white,),
            ),
            text("NCMC Recharge",
                textAlign: TextAlign.center,
                isCentered: true,
                textColor:white,fontSize: 18,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600),
            Icon(Icons.help),

            // SizedBox(width: 10,),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              text("All Providers",
                  textColor:blackColor,fontSize: 16,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w600),
              SizedBox(height: 10),
              text("Select your NCMC provider to recharge",
                  textColor:blackColor,fontSize: 14,
                  fontFamily: FontFamily.plusJakartaSansRegular,
                  fontWeight: FontWeight.w400),
              SizedBox(height: 15),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: options.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:  GestureDetector(
                      onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context) => NcmcAccountScreen(ncmcServiceName: options[index],),));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 7,vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          // border: Border.all(color:greyColor)
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(AppImages.nhmcImage),
                                    SizedBox(width: 20,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        text(options[index],
                                            textColor:blackColor,fontSize: 13,
                                            fontFamily: FontFamily.plusJakartaSansMedium,
                                            fontWeight: FontWeight.w500),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  );

                },)
            ],
          ),
        ),
      ),



    );
  }

}




