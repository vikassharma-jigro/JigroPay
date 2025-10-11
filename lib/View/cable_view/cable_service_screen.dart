
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/app_utils/app_images.dart';

import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';
import 'cable_pay_screen.dart';



class CableServiceScreen extends StatefulWidget {

  const CableServiceScreen({super.key,});

  @override
  State<CableServiceScreen> createState() => _CableServiceScreenState();
}


class _CableServiceScreenState extends State<CableServiceScreen> {
  List<String> options = [
    "ACT Cable TV",
    "Alka Vishwadarshan",
    "Amrita Cable Network",
    "Angel Cable And Broadband Service",
    "Ansari Cable Tv",
    "Arihant Network",
    "Aryan Cable Network",
    "BCN Digital",
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
          children: [
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child:  Icon(Icons.arrow_back_ios,color: white,),
            ),
            Expanded(
              child: text("Cable",
                  textAlign: TextAlign.center,
                  isCentered: true,
                  textColor:white,fontSize: 18,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w600),
            ),

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
              text("Add New Connections",
                  textColor:blackColor,fontSize: 16,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w600),
              SizedBox(height: 5,),
              text("Select your cable TV provider",
                  textColor:greyColor,fontSize: 14,
                  fontFamily: FontFamily.plusJakartaSansMedium,
                  fontWeight: FontWeight.w600),

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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CablePayScreen(cableServiceName: options[index],),));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
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
                                    SvgPicture.asset(AppImages.tvDishImage),
                                    SizedBox(width: 20,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        text(options[index],
                                            textColor:blackColor,fontSize: 14,
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




