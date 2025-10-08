import 'package:flutter/material.dart';
import 'package:jigrotech/View/bank_view/pin_screen.dart';
import 'package:jigrotech/main.dart';

import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
class RechargePayScreen extends StatefulWidget {
  const RechargePayScreen({super.key});

  @override
  State<RechargePayScreen> createState() => _RechargePayScreenState();
}

class _RechargePayScreenState extends State<RechargePayScreen> {
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
                child: text("Pay",
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.purpleAccent.withOpacity(0.3)
                    ),
                  ),
                  SizedBox(width: 15,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start  ,
                    children: [
                      text("Jio Prepaid",
                          textAlign: TextAlign.center,
                          isCentered: true,
                          textColor:blackColor,fontSize: 18,
                          fontFamily: FontFamily.plusJakartaSansBold,
                          fontWeight: FontWeight.w600),


                      text("Mumma ❤️ • 0000000000",
                          textAlign: TextAlign.center,
                          isCentered: true,
                          textColor:blackColor,fontSize: 15,
                          fontFamily: FontFamily.plusJakartaSansRegular,
                          fontWeight: FontWeight.w600),

                      text("Rajasthan",
                          textAlign: TextAlign.center,
                          isCentered: true,
                          textColor:greyColor,fontSize: 15,
                          fontFamily: FontFamily.plusJakartaSansRegular,
                          fontWeight: FontWeight.w600),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: greyColor)
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        text("₹151",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor:blackColor,fontSize: 18,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (cntext) => RechargePayScreen()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 30,vertical: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: lightorangeColor
                            ),
                            child: text("Change Plan",
                                textAlign: TextAlign.center,
                                isCentered: true,
                                textColor:purpleGradientColor,fontSize: 18,
                                fontFamily: FontFamily.plusJakartaSansMedium,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),

                    text("Validity: 24 Days",
                        textColor:greyColor,fontSize: 12,
                        fontFamily: FontFamily.plusJakartaSansRegular,
                        fontWeight: FontWeight.w600),

                    text("Data: 1GB/Day + Night Free",
                        textColor:greyColor,fontSize: 12,
                        fontFamily: FontFamily.plusJakartaSansRegular,
                        fontWeight: FontWeight.w600),

                    text("Calls: Unlimited | SMS: 100/Day",
                        textColor:greyColor,fontSize: 12,
                        fontFamily: FontFamily.plusJakartaSansRegular,
                        fontWeight: FontWeight.w600),

                    SizedBox(height: 10,),

                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: lightYellowColor.withOpacity(.3),
                            border: Border.all(color: lightYellowColor)
                        ),
                        child: text("Data Only Pack (No Voice & No SMS)",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor:redColor,fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                            fontWeight: FontWeight.w400),
                      ),
                    ),

                    SizedBox(height: 15,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Container(
                         padding: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(5),
                             color: lightColor
                         ),
                         child: Column(
                           children: [
                             Icon(Icons.phone,color: greyColor,),

                             text("Voice",
                                 textAlign: TextAlign.center,
                                 isCentered: true,
                                 textColor:greyColor,fontSize: 14,
                                 fontFamily: FontFamily.plusJakartaSansMedium,
                                 fontWeight: FontWeight.w400),

                             text("NA",
                                 textAlign: TextAlign.center,
                                 isCentered: true,
                                 textColor:greyColor,fontSize: 14,
                                 fontFamily: FontFamily.plusJakartaSansMedium,
                                 fontWeight: FontWeight.w400),
                           ],
                         ),
                       ),

                       Container(
                         padding: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(5),
                             color: lightColor
                         ),
                         child: Column(
                           children: [
                             Icon(Icons.phone,color: greyColor,),

                             text("SMS",
                                 textAlign: TextAlign.center,
                                 isCentered: true,
                                 textColor:greyColor,fontSize: 14,
                                 fontFamily: FontFamily.plusJakartaSansMedium,
                                 fontWeight: FontWeight.w400),

                             text("NA",
                                 textAlign: TextAlign.center,
                                 isCentered: true,
                                 textColor:greyColor,fontSize: 14,
                                 fontFamily: FontFamily.plusJakartaSansMedium,
                                 fontWeight: FontWeight.w400),
                           ],
                         ),
                       ),
                     ],
                   ),

                    SizedBox(height: 15,),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: lightBlueColor.withOpacity(.6),
                        border: Border.all(color: blue1Color)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text("Note",
                              textAlign: TextAlign.center,
                              isCentered: true,
                              textColor:blue1Color,fontSize: 14,
                              fontFamily: FontFamily.plusJakartaSansBold,
                              fontWeight: FontWeight.w400),

                          text("2GB High Speed Data thereafter Unlimited at 64Kbps",
                              textColor:blue1Color,fontSize: 14,
                              fontFamily: FontFamily.plusJakartaSansRegular,
                              fontWeight: FontWeight.w400),
                        ],
                      ),
                    ),

                  ],
                ),
              ),

              SizedBox(height: 15,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: lightColor
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text("Payment Summary",
                        textColor:blackColor,fontSize: 16,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontWeight: FontWeight.w700),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        text("Plan Amount",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor:greyColor,fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                            fontWeight: FontWeight.w400),
                        text("₹29.00",
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
                        text("GST",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor:greyColor,fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                            fontWeight: FontWeight.w400),
                        text("₹29.00",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor:blackColor,fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w400),
                      ],
                    ),
                    Divider(thickness: .5,height: 10,),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        text("Total Amount",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor:blackColor,fontSize: 18,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600),
                        text("₹29.00",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor:blackColor,fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w400),
                      ],
                    ),

                  ],
                ),
              ),
              const SizedBox(height: 30,),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 55,
                child: CommonButton(
                  text: "Proceed to pay ",
                  gradient: const LinearGradient(
                    colors: [pinkColor, purpleGradientColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  textColor: white,
                  fontWeight: FontWeight.w500,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontSize:18.0,
                  //padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  borderRadius: BorderRadius.circular(15.0),
                  onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) =>  UpiPinScreen(isMobileRecharge: true,),));

                  },),
              ),
            ],
          ),
        )
    );
  }
}
