import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/View/cable_view/cable_service_screen.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/app_images.dart';
import '../../app_utils/font_family.dart';
import '../../app_utils/text_widget.dart';
import '../../main.dart';
import '../electricity_bill/electricity_bill_service_screen.dart';


class SeeAllServicesScreen extends StatefulWidget {
  const SeeAllServicesScreen({super.key});

  @override
  State<SeeAllServicesScreen> createState() => _SeeAllServicesScreenState();
}


class _SeeAllServicesScreenState extends State<SeeAllServicesScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GradientAppScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:   InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child:  Icon(Icons.arrow_back_ios,color: white,),
        ),
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                lightPurpleColor.withOpacity(.6),
                electricPurple.withOpacity(.7),


              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: white
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(
                          "Popular Categories",
                          textColor: blackColor,
                          fontSize: 14,
                          fontFamily: FontFamily.plusJakartaSansBold,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: (){
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => MoneyTransferScreen(),));
                              },
                              child: Column(
                                children: [
                                  SvgPicture.asset(AppImages.electricityImage,height: 50,),
                                  SizedBox(height: 5,),
                                  Center(
                                    child: text(
                                      "Electricity",
                                      isCentered: true,
                                      textColor: blackColor,
                                      fontSize: 11,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => FastTagScreen(),));
                              },
                              child: Column(
                                children: [
                                 SvgPicture.asset(AppImages.cardImage,height: 50,),
                                  SizedBox(height: 5,),
                                  Center(
                                    child: text(
                                      "Credit Card",
                                      isCentered: true,
                                      textColor: blackColor,
                                      fontSize: 11,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                               // Navigator.push(context, MaterialPageRoute(builder: (context) => DthServiceScreen(),));
                              },
                              child: Column(
                                children: [
                                  Image.asset(AppImages.mobileReImage,height: 50,),
                                  SizedBox(height: 5,),
                                  Center(
                                    child: text(
                                      "Mobile\nRecharge",
                                      isCentered: true,
                                      textColor: blackColor,
                                      fontSize: 11,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                SvgPicture.asset(AppImages.fastImage,height: 50,),
                                SizedBox(height: 5,),
                                Center(
                                  child: text(
                                    "FASTag",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily: FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Column(
                              children: [
                                SvgPicture.asset(AppImages.dthTvImage,height: 50,),
                                SizedBox(height: 5,),
                                Center(
                                  child: text(
                                    "DTH",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily: FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Column(
                              children: [
                                SvgPicture.asset(AppImages.gasImage,height: 50,),
                                SizedBox(height: 5,),
                                Center(
                                  child: text(
                                    "Book A\nCylinder",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily: FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: (){
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => ElectricityBillServiceScreen(),));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(AppImages.phoneImage,height: 50,),
                                  SizedBox(height: 5,),
                                  text(
                                    "Mobile\nPostpaid",
                                    //isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily: FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 40,),
                            Spacer(),
                          ],
                        ),

                      ],
                    ),


                  ),

                  SizedBox(height: 15,),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: white
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(
                          "Recharges",
                          textColor: blackColor,
                          fontSize: 14,
                          fontFamily: FontFamily.plusJakartaSansBold,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: (){
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => MoneyTransferScreen(),));
                              },
                              child: Column(
                                children: [
                                  Image.asset(AppImages.mobileReImage,height: 50,),
                                  SizedBox(height: 5,),
                                  Center(
                                    child: text(
                                      "Mobile",
                                      isCentered: true,
                                      textColor: blackColor,
                                      fontSize: 11,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => FastTagScreen(),));
                              },
                              child: Column(
                                children: [
                                  SvgPicture.asset(AppImages.dthTvImage,height: 50,),
                                  SizedBox(height: 5,),
                                  Center(
                                    child: text(
                                      "DTH",
                                      isCentered: true,
                                      textColor: blackColor,
                                      fontSize: 11,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => CableServiceScreen(),));
                              },
                              child: Column(
                                children: [
                                  SvgPicture.asset(AppImages.cableImage,height: 50,),
                                  SizedBox(height: 5,),
                                  Center(
                                    child: text(
                                      "Cable",
                                      isCentered: true,
                                      textColor: blackColor,
                                      fontSize: 11,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                SvgPicture.asset(AppImages.fastImage,height: 50,),
                                SizedBox(height: 5,),
                                Center(
                                  child: text(
                                    "FASTag",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily: FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                SvgPicture.asset(AppImages.nhmcImage,height: 50,),
                                SizedBox(height: 5,),
                                Center(
                                  child: text(
                                    "NCMC",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily: FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),



                      ],
                    ),


                  ),

                  SizedBox(height: 15,),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: white
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(
                          "Utilities",
                          textColor: blackColor,
                          fontSize: 14,
                          fontFamily: FontFamily.plusJakartaSansBold,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: (){
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => MoneyTransferScreen(),));
                              },
                              child: Column(
                                children: [
                                  SvgPicture.asset(AppImages.electricityImage,height: 50,),
                                  SizedBox(height: 5,),
                                  Center(
                                    child: text(
                                      "Electricity",
                                      isCentered: true,
                                      textColor: blackColor,
                                      fontSize: 11,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => FastTagScreen(),));
                              },
                              child: Column(
                                children: [
                                  SvgPicture.asset(AppImages.gasImage,height: 50,),
                                  SizedBox(height: 5,),
                                  Center(
                                    child: text(
                                      "Gas",
                                      isCentered: true,
                                      textColor: blackColor,
                                      fontSize: 11,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => DthServiceScreen(),));
                              },
                              child: Column(
                                children: [
                                  SvgPicture.asset(AppImages.pipedGasImage,height: 50,),
                                  SizedBox(height: 5,),
                                  Center(
                                    child: text(
                                      "Piped Gas",
                                      isCentered: true,
                                      textColor: blackColor,
                                      fontSize: 11,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                SvgPicture.asset(AppImages.waterImage,height: 50,),
                                SizedBox(height: 5,),
                                Center(
                                  child: text(
                                    "Water",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily: FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),

                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Column(
                              children: [
                                SvgPicture.asset(AppImages.phoneImage,height: 50,),
                                SizedBox(height: 5,),
                                Center(
                                  child: text(
                                    "Postpaid",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily: FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Column(
                              children: [
                                SvgPicture.asset(AppImages.wifiImage,height: 50,),
                                SizedBox(height: 5,),
                                Center(
                                  child: text(
                                    "Broadband",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily: FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: (){
                              //  Navigator.push(context, MaterialPageRoute(builder: (context) => ElectricityBillServiceScreen(),));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(AppImages.phoneImage,height: 50,),
                                  SizedBox(height: 5,),
                                  text(
                                    "Landline",
                                    //isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily: FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Spacer(),
                          ],
                        ),

                      ],
                    ),


                  ),


                  SizedBox(height: 15,),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: white
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(
                          "Financial Services",
                          textColor: blackColor,
                          fontSize: 14,
                          fontFamily: FontFamily.plusJakartaSansBold,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: (){
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => MoneyTransferScreen(),));
                              },
                              child: Column(
                                children: [
                                  SvgPicture.asset(AppImages.nhmcImage,height: 50,),
                                  SizedBox(height: 5,),
                                  Center(
                                    child: text(
                                      "Credit Card",
                                      isCentered: true,
                                      textColor: blackColor,
                                      fontSize: 11,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 1,),
                            GestureDetector(
                              onTap: (){
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => FastTagScreen(),));
                              },
                              child: Column(
                                children: [
                                 SvgPicture.asset(AppImages.mutualFundImage,height: 50,),
                                  SizedBox(height: 5,),
                                  Center(
                                    child: text(
                                      "Mutual Fund",
                                      isCentered: true,
                                      textColor: blackColor,
                                      fontSize: 11,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 5,),
                            GestureDetector(
                              onTap: (){
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => DthServiceScreen(),));
                              },
                              child: Column(
                                children: [
                                  SvgPicture.asset(AppImages.insuranceImage,height: 50,),
                                  SizedBox(height: 5,),
                                  Center(
                                    child: text(
                                      "Insurance",
                                      isCentered: true,
                                      textColor: blackColor,
                                      fontSize: 11,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            GestureDetector(
                              onTap: (){
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => ElectricityBillServiceScreen(),));
                              },
                              child: Column(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(AppImages.loanImage,height: 50,),
                                  SizedBox(height: 5,),
                                  Center(
                                    child: text(
                                      "Loan",
                                      isCentered: true,
                                      textAlign: TextAlign.center,
                                      textColor: blackColor,
                                      fontSize: 11,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                SvgPicture.asset(AppImages.municipalImage,height: 50,),
                                SizedBox(height: 5,),
                                Center(
                                  child: text(
                                    "Municipal",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily: FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            //SizedBox(width: 1,),
                            Column(
                              children: [
                                SvgPicture.asset(AppImages.serviceImage,height: 50,),
                                SizedBox(height: 5,),
                                Center(
                                  child: text(
                                    "Service",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily: FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                           // SizedBox(width: 5,),
                            Column(
                              children: [
                                SvgPicture.asset(AppImages.rdImage,height: 50,),
                                SizedBox(height: 5,),
                                Center(
                                  child: text(
                                    "RD",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily: FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),

                            Column(
                              children: [
                                SvgPicture.asset(AppImages.npsImage,height: 50,),
                                SizedBox(height: 5,),
                                Center(
                                  child: text(
                                    "NPS",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily: FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),




                      ],
                    ),


                  ),

                  SizedBox(height: 15,),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: white
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(
                          "More Services",
                          textColor: blackColor,
                          fontSize: 14,
                          fontFamily: FontFamily.plusJakartaSansBold,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: (){
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => MoneyTransferScreen(),));
                              },
                              child: Column(
                                children: [
                                  SvgPicture.asset(AppImages.subscriptionImage,height: 50,),
                                  SizedBox(height: 5,),
                                  Center(
                                    child: text(
                                      "Subscription",
                                      isCentered: true,
                                      textColor: blackColor,
                                      fontSize: 11,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => FastTagScreen(),));
                              },
                              child: Column(
                                children: [
                                  SvgPicture.asset(AppImages.housingImage,height: 50,),
                                  SizedBox(height: 5,),
                                  Center(
                                    child: text(
                                      "Housing",
                                      isCentered: true,
                                      textColor: blackColor,
                                      fontSize: 11,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => DthServiceScreen(),));
                              },
                              child: Column(
                                children: [
                                  SvgPicture.asset(AppImages.clubImage,height: 50,),
                                  SizedBox(height: 5,),
                                  Center(
                                    child: text(
                                      "Club",
                                      isCentered: true,
                                      textColor: blackColor,
                                      fontSize: 11,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                SvgPicture.asset(AppImages.hospitalImage,height: 50,),
                                SizedBox(height: 5,),
                                Center(
                                  child: text(
                                    "Hospital",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily: FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Column(
                              children: [
                                SvgPicture.asset(AppImages.educationImage,height: 50,),
                                SizedBox(height: 5,),
                                Center(
                                  child: text(
                                    "Education",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily: FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            SizedBox(width: 20,),
                            Column(
                              children: [
                                SvgPicture.asset(AppImages.donationImage,height: 50,),
                                SizedBox(height: 5,),
                                Center(
                                  child: text(
                                    "Donation",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily: FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Column(
                              children: [
                                SvgPicture.asset(AppImages.pathologyImage,height: 50,),
                                SizedBox(height: 5,),
                                Center(
                                  child: text(
                                    "Pathology",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily: FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Spacer(),
                          ],
                        ),
                      ],
                    ),


                  ),

                ],
              ),
            ),
          )
      ),



    );
  }

}

