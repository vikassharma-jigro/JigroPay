import 'package:flutter/material.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/font_family.dart';
import '../../app_utils/text_widget.dart';
import '../../main.dart';

class BankListScreen extends StatefulWidget {
  const BankListScreen({super.key});

  @override
  State<BankListScreen> createState() => _BankListScreenState();
}

class _BankListScreenState extends State<BankListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GradientAppScaffold(
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'JIGROPAY',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: FontFamily.plusJakartaSansBold,
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: <Color>[
                    pinkColor,
                    purpleGradientColor, // purple shade
                    // pink shade
                  ],
                ).createShader(Rect.fromLTWH(110.0, 0.0, 200.0, 70.0)),
            ),
          ),
          SizedBox(width: 10),
          text(
            "Powered By UPI",
            textAlign: TextAlign.center,
            isCentered: true,
            textColor: blackColor,
            fontSize: 18,
            fontFamily: FontFamily.plusJakartaSansMedium,
            fontWeight: FontWeight.w500,
          ),
        ],
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
                "Self Transfer",
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

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: lightGreyColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text(
                    "Send Money To",
                    textAlign: TextAlign.center,
                    isCentered: true,
                    textColor: blackColor,
                    fontSize: 16,
                    fontFamily: FontFamily.plusJakartaSansBold,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: blue1Color,
                            ),
                            child: text(
                              "SBI",
                              textAlign: TextAlign.center,
                              isCentered: true,
                              textColor: white,
                              fontSize: 16,
                              fontFamily: FontFamily.plusJakartaSansBold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 17),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text(
                                "State Bank of India - 1461",
                                textAlign: TextAlign.center,
                                isCentered: true,
                                textColor: blackColor,
                                fontSize: 16,
                                fontFamily: FontFamily.plusJakartaSansMedium,
                                fontWeight: FontWeight.w600,
                              ),

                              text(
                                "Check Balance",
                                textAlign: TextAlign.center,
                                isCentered: true,
                                textColor: blue1Color,
                                fontSize: 16,
                                fontFamily: FontFamily.plusJakartaSansMedium,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ],
                      ),

                      Icon(Icons.arrow_forward_ios, color: greyColor),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: red1Color,
                            ),
                            child: text(
                              "HDFC",
                              textAlign: TextAlign.center,
                              isCentered: true,
                              textColor: white,
                              fontSize: 16,
                              fontFamily: FontFamily.plusJakartaSansBold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text(
                                "HDFC Bank - 8420",
                                textAlign: TextAlign.center,
                                isCentered: true,
                                textColor: blackColor,
                                fontSize: 16,
                                fontFamily: FontFamily.plusJakartaSansMedium,
                                fontWeight: FontWeight.w600,
                              ),

                              text(
                                "Check Balance",
                                textAlign: TextAlign.center,
                                isCentered: true,
                                textColor: blue1Color,
                                fontSize: 16,
                                fontFamily: FontFamily.plusJakartaSansMedium,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ],
                      ),

                      Icon(Icons.arrow_forward_ios, color: greyColor),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(AppImages.divIcon, height: 55),
                          SizedBox(width: 17),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text(
                                "UPI Lite",
                                textAlign: TextAlign.center,
                                isCentered: true,
                                textColor: blackColor,
                                fontSize: 16,
                                fontFamily: FontFamily.plusJakartaSansMedium,
                                fontWeight: FontWeight.w600,
                              ),

                              text(
                                "Activate your UPI Lite",
                                textAlign: TextAlign.center,
                                isCentered: true,
                                textColor: greyColor,
                                fontSize: 16,
                                fontFamily: FontFamily.plusJakartaSansMedium,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ],
                      ),

                      Icon(Icons.arrow_forward_ios, color: greyColor),
                    ],
                  ),

                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(AppImages.addIcon, height: 55),
                          SizedBox(width: 20),
                          text(
                            "Add Bank Account",
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
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: lightGreyColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(AppImages.goldIcon, height: 50),
                          SizedBox(width: 23),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text(
                                "Save in Gold",
                                textAlign: TextAlign.center,
                                isCentered: true,
                                textColor: blackColor,
                                fontSize: 16,
                                fontFamily: FontFamily.plusJakartaSansBold,
                                fontWeight: FontWeight.w600,
                              ),

                              text(
                                "Build your wealth. Start with just ₹51.",
                                textAlign: TextAlign.center,
                                isCentered: true,
                                textColor: greyColor,
                                fontSize: 13,
                                fontFamily: FontFamily.plusJakartaSansMedium,
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
    );
  }
}
