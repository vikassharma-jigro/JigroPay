import 'package:flutter/material.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/font_family.dart';
import '../../app_utils/text_widget.dart';
import '../../main.dart';

class ViewReceiptScreen extends StatefulWidget {
  const ViewReceiptScreen({super.key});

  @override
  State<ViewReceiptScreen> createState() => _ViewReceiptScreenState();
}

class _ViewReceiptScreenState extends State<ViewReceiptScreen> {
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
            // SizedBox(width: 10,),
          ],
        ),
      ),

      body: Container(
        color: white,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                text(
                  "Jaipur Vidyut Vitran Nigam Limited (JVVNL)",
                  textColor: blackColor,
                  fontSize: 12,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 20),
                Divider(height: 10, thickness: .5),
                SizedBox(height: 20),
                Row(
                  children: [
                    Image.asset(AppImages.jvvnlImage),
                    SizedBox(width: 20),
                    text(
                      "Bill Payment Receipt",
                      textColor: purpleGradientColor,
                      fontSize: 18,
                      fontFamily: FontFamily.plusJakartaSansBold,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Divider(thickness: .5, color: pinkColor),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text(
                      "Service Name",
                      textColor: blackColor,
                      fontSize: 14,
                      fontFamily: FontFamily.plusJakartaSansMedium,
                      fontWeight: FontWeight.w400,
                    ),
                    text(
                      "DESCO Postpaid",
                      textColor: greyColor,
                      fontSize: 14,
                      fontFamily: FontFamily.plusJakartaSansBold,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),

                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text(
                      "Bill No",
                      textColor: blackColor,
                      fontSize: 14,
                      fontFamily: FontFamily.plusJakartaSansMedium,
                      fontWeight: FontWeight.w400,
                    ),
                    text(
                      "0922452641151",
                      textColor: greyColor,
                      fontSize: 14,
                      fontFamily: FontFamily.plusJakartaSansBold,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),

                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text(
                      "Bill Month Year",
                      textColor: blackColor,
                      fontSize: 14,
                      fontFamily: FontFamily.plusJakartaSansMedium,
                      fontWeight: FontWeight.w400,
                    ),
                    text(
                      "092022",
                      textColor: greyColor,
                      fontSize: 14,
                      fontFamily: FontFamily.plusJakartaSansBold,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text(
                      "Bill Amount",
                      textColor: blackColor,
                      fontSize: 14,
                      fontFamily: FontFamily.plusJakartaSansMedium,
                      fontWeight: FontWeight.w400,
                    ),
                    text(
                      "₹459",
                      textColor: greyColor,
                      fontSize: 14,
                      fontFamily: FontFamily.plusJakartaSansBold,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),

                SizedBox(height: 15),
                Divider(height: 10),

                SizedBox(height: 15),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text(
                              "Amount",
                              textColor: blackColor,
                              fontSize: 14,
                              fontFamily: FontFamily.plusJakartaSansMedium,
                              fontWeight: FontWeight.w400,
                            ),
                            text(
                              "₹459",
                              textColor: greyColor,
                              fontSize: 14,
                              fontFamily: FontFamily.plusJakartaSansBold,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text(
                              "Date & Time",
                              textColor: blackColor,
                              fontSize: 14,
                              fontFamily: FontFamily.plusJakartaSansMedium,
                              fontWeight: FontWeight.w400,
                            ),
                            text(
                              "06 Nov 2022, 08:40 AM",
                              textColor: greyColor,
                              fontSize: 14,
                              fontFamily: FontFamily.plusJakartaSansBold,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text(
                              "Transaction ID",
                              textColor: blackColor,
                              fontSize: 14,
                              fontFamily: FontFamily.plusJakartaSansMedium,
                              fontWeight: FontWeight.w400,
                            ),
                            text(
                              "71J8KPL892",
                              textColor: greyColor,
                              fontSize: 14,
                              fontFamily: FontFamily.plusJakartaSansBold,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text(
                              "Status",
                              textColor: blackColor,
                              fontSize: 14,
                              fontFamily: FontFamily.plusJakartaSansMedium,
                              fontWeight: FontWeight.w400,
                            ),
                            text(
                              "SUCCESS",
                              textColor: greyColor,
                              fontSize: 14,
                              fontFamily: FontFamily.plusJakartaSansBold,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          height: 55,
                          child: CommonButton(
                            text: "Payment Receive   463.13",
                            textColor: white,
                            gradient: const LinearGradient(
                              colors: [pinkColor, purpleGradientColor],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            fontWeight: FontWeight.w600,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontSize: 13.0,

                            //padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                            //borderRadius: BorderRadius.circular(40.0),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                text(
                  "This receipt has been generated generated electronically",
                  textColor: greyColor,
                  fontSize: 14,
                  fontFamily: FontFamily.plusJakartaSansMedium,
                  fontWeight: FontWeight.w400,
                ),

                SizedBox(height: 20),

                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: 55,
                  child: CommonButton(
                    text: "Download",
                    textColor: white,
                    gradient: const LinearGradient(
                      colors: [pinkColor, purpleGradientColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    fontWeight: FontWeight.w600,
                    fontFamily: FontFamily.plusJakartaSansBold,
                    fontSize: 13.0,

                    //padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    //borderRadius: BorderRadius.circular(40.0),
                    onPressed: () {},
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
