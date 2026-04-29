import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jigrotech/View/bank_view/mobile_recharge_screen/recharge_pay_screen.dart';
import 'package:jigrotech/app_utils/app_images.dart';

import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';

class RechargePlanScreen extends StatefulWidget {
  final String? mobileRechargeNumber;
  final String? photo;
  final String? number;
  const RechargePlanScreen({
    super.key,
    this.mobileRechargeNumber,
    this.photo,
    this.number,
  });

  @override
  State<RechargePlanScreen> createState() => _RechargePlanScreenState();
}

class _RechargePlanScreenState extends State<RechargePlanScreen> {
  String? _selectValue;
  List<String> options = [
    "Jio Postpaid",
    "Airtel Postpaid",
    "VI Postpaid",
    "BSNL Postpaid",
    "Jio Fiber",
    "Airtel Broadband",
    "VI Data",
    "BSNL Fiber",
    "Jio Business",
    "Airtel Office",
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
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: white),
            ),
            Expanded(
              child: text(
                "Recharge with an\nunlimited 5G plan",
                textAlign: TextAlign.center,
                isCentered: true,
                textColor: white,
                fontSize: 18,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [
                      pinkColor,
                      purpleGradientColor,
                      // Gradient का दूसरा color
                    ],
                    begin: Alignment.topLeft, // Gradient की शुरुआत
                    end: Alignment.bottomRight,
                  ),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(
                          "Select a recharge plan",
                          textAlign: TextAlign.center,
                          isCentered: true,
                          textColor: white,
                          fontSize: 18,
                          fontFamily: FontFamily.plusJakartaSansBold,
                          fontWeight: FontWeight.w600,
                        ),

                        text(
                          "00000000",
                          textColor: white,
                          fontSize: 16,
                          fontFamily: FontFamily.plusJakartaSansRegular,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),

                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: white,
                      ),
                      child: Image.asset(AppImages.userIcon, height: 30),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              text(
                "Suggested Plans",
                textAlign: TextAlign.center,
                isCentered: true,
                textColor: blackColor,
                fontSize: 18,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: greyColor),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(
                          "₹33",
                          textAlign: TextAlign.center,
                          isCentered: true,
                          textColor: blackColor,
                          fontSize: 18,
                          fontFamily: FontFamily.plusJakartaSansBold,
                          fontWeight: FontWeight.w600,
                        ),

                        text(
                          "1 Day validity",
                          textColor: blackColor,
                          fontSize: 12,
                          fontFamily: FontFamily.plusJakartaSansRegular,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: greyColor),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(
                          "₹349",
                          textAlign: TextAlign.center,
                          isCentered: true,
                          textColor: blackColor,
                          fontSize: 18,
                          fontFamily: FontFamily.plusJakartaSansBold,
                          fontWeight: FontWeight.w600,
                        ),

                        text(
                          "28 Days validity",
                          textColor: blackColor,
                          fontSize: 12,
                          fontFamily: FontFamily.plusJakartaSansRegular,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
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
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: greyColor),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              text(
                                "₹151",
                                textAlign: TextAlign.center,
                                isCentered: true,
                                textColor: blackColor,
                                fontSize: 18,
                                fontFamily: FontFamily.plusJakartaSansBold,
                                fontWeight: FontWeight.w600,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (cntext) => RechargePayScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: purpleGradientColor,
                                  ),
                                  child: text(
                                    "Recharge",
                                    textAlign: TextAlign.center,
                                    isCentered: true,
                                    textColor: white,
                                    fontSize: 18,
                                    fontFamily: FontFamily.plusJakartaSansBold,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: lightGreenColor.withOpacity(.2),
                            ),
                            child: text(
                              "5G Upgraded Pack",
                              textAlign: TextAlign.center,
                              isCentered: true,
                              textColor: lightGreenColor,
                              fontSize: 12,
                              fontFamily: FontFamily.plusJakartaSansRegular,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          text(
                            "Validity: 24 Days",
                            textColor: greyColor,
                            fontSize: 12,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w600,
                          ),

                          text(
                            "Data: 1GB/Day + Night Free",
                            textColor: greyColor,
                            fontSize: 12,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w600,
                          ),

                          text(
                            "Calls: Unlimited | SMS: 100/Day",
                            textColor: greyColor,
                            fontSize: 12,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
