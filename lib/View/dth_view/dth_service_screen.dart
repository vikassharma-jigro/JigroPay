
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/app_utils/app_images.dart';

import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';
import 'dth_customer_screen.dart';



class DthServiceScreen extends StatefulWidget {

  const DthServiceScreen({super.key,});

  @override
  State<DthServiceScreen> createState() => _DthServiceScreenState();
}


class _DthServiceScreenState extends State<DthServiceScreen> {
  List<String> options = [
    "Airtel DTH",
    "D2H",
    "Dish TV Limited",
    "Sun Direct TV",
    "Sun Direct TV",
    "Tata Play",
  ];
  int? selectIndex;
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
              child: text("DTH",
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text("Add New DTH Operator",
                      textAlign: TextAlign.center,
                      isCentered: true,
                      textColor:blackColor,fontSize: 20,
                      fontFamily: FontFamily.plusJakartaSansBold,
                      fontWeight: FontWeight.w600),

                  text("Select your DTH service provider",
                      textColor:greyColor,fontSize: 14,
                      fontFamily: FontFamily.plusJakartaSansRegular,
                      fontWeight: FontWeight.w600),
                ],
              ),

              SizedBox(height: 15),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: 10,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  bool isSelected = selectIndex == index;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:  GestureDetector(
                      onTap: (){
                        setState(() {
                          selectIndex = index; // selected index update करो
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DthCustomerScreen(),));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: isSelected?blue1Color:greyColor)
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(AppImages.sunImage),
                                    SizedBox(width: 20,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        text("Airtel DTH",
                                            textColor:blackColor,fontSize: 16,
                                            fontFamily: FontFamily.plusJakartaSansMedium,
                                            fontWeight: FontWeight.w500),

                                        text("Digital TV Service",
                                            textColor:greyColor,fontSize: 12,
                                            fontFamily: FontFamily.plusJakartaSansRegular,
                                            fontWeight: FontWeight.w400),
                                      ],
                                    ),
                                  ],
                                ),


                                Icon(Icons.arrow_forward_ios,color: greyColor,)
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




