import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/View/bank_view/pin_screen.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/font_family.dart';
import '../../app_utils/text_widget.dart';
import '../../main.dart';

class CheckBalanceScreen extends StatefulWidget {
  const CheckBalanceScreen({super.key});

  @override
  State<CheckBalanceScreen> createState() => _CheckBalanceScreenState();
}

class _CheckBalanceScreenState extends State<CheckBalanceScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GradientAppScaffold(
      bottomNavigationBar: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: 55,
        child: CommonButton(
          text: "Benefits, cashback",
          gradient: const LinearGradient(
            colors: [pinkColor, purpleGradientColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          textColor: white,
          fontWeight: FontWeight.w500,
          fontFamily: FontFamily.plusJakartaSansBold,
          fontSize: 18.0,
          //padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          borderRadius: BorderRadius.circular(1.0),
          onPressed: () {},
        ),
      ),
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
            // SizedBox(width: 10,),
            Expanded(
              child: text(
                "Add Bank Account",
                textAlign: TextAlign.center,
                isCentered: true,
                textColor: white,
                fontSize: 18,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(Icons.more_vert, color: white),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text(
                  "ACCOUNTS ON UPI",
                  textAlign: TextAlign.center,
                  isCentered: true,
                  textColor: greyColor,
                  fontSize: 13,
                  fontFamily: FontFamily.plusJakartaSansMedium,
                  fontWeight: FontWeight.w500,
                ),

                SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpiPinScreen(
                          bankName: "Rajasthan Gramin Bank-8093",
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10, // shadow spread
                          offset: const Offset(
                            0,
                            4,
                          ), // x, y direction of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  AppImages.rajImage,
                                  height: 50,
                                ),
                                SizedBox(width: 23),
                                text(
                                  "Rajasthan Gramin Bank-8093",
                                  textAlign: TextAlign.center,
                                  isCentered: true,
                                  textColor: blackColor,
                                  fontSize: 16,
                                  fontFamily: FontFamily.plusJakartaSansMedium,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),

                            Icon(Icons.arrow_forward_ios, color: greyColor),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10, // shadow spread
                        offset: const Offset(0, 4), // x, y direction of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(AppImages.rajImage, height: 50),
                              SizedBox(width: 23),
                              text(
                                "Rajasthan Gramin Bank-8093",
                                textAlign: TextAlign.center,
                                isCentered: true,
                                textColor: blackColor,
                                fontSize: 16,
                                fontFamily: FontFamily.plusJakartaSansMedium,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),

                          Icon(Icons.arrow_forward_ios, color: greyColor),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                text(
                  "PRE-PAID BALANCE",
                  textAlign: TextAlign.center,
                  isCentered: true,
                  textColor: greyColor,
                  fontSize: 13,
                  fontFamily: FontFamily.plusJakartaSansMedium,
                  fontWeight: FontWeight.w500,
                ),

                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10, // shadow spread
                        offset: const Offset(0, 4), // x, y direction of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                AppImages.upiLiteImage,
                                height: 50,
                              ),
                              SizedBox(width: 23),
                              text(
                                "UPI Lite",
                                textAlign: TextAlign.center,
                                isCentered: true,
                                textColor: blackColor,
                                fontSize: 16,
                                fontFamily: FontFamily.plusJakartaSansMedium,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),

                          Icon(Icons.arrow_forward_ios, color: greyColor),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10, // shadow spread
                        offset: const Offset(0, 4), // x, y direction of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                AppImages.walletImage,
                                height: 50,
                              ),
                              SizedBox(width: 23),
                              text(
                                "PhonePe Wallet",
                                textAlign: TextAlign.center,
                                isCentered: true,
                                textColor: blackColor,
                                fontSize: 16,
                                fontFamily: FontFamily.plusJakartaSansMedium,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),

                          Icon(Icons.arrow_forward_ios, color: greyColor),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10, // shadow spread
                        offset: const Offset(0, 4), // x, y direction of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(AppImages.addIcon, height: 50),
                              SizedBox(width: 23),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  text(
                                    "Add UPI account",
                                    textAlign: TextAlign.center,
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 16,
                                    fontFamily:
                                        FontFamily.plusJakartaSansMedium,
                                    fontWeight: FontWeight.w600,
                                  ),

                                  text(
                                    "to check balance for RuPay card,\nbank accounts & more.",

                                    textColor: greyColor,
                                    fontSize: 12,
                                    fontFamily:
                                        FontFamily.plusJakartaSansMedium,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          Icon(Icons.arrow_forward_ios, color: greyColor),
                        ],
                      ),
                    ],
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
