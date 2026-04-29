import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jigrotech/View/travle_booking_view/flight_view/flight_travle_form_screen.dart';

import '../../../app_utils/app_colors.dart';
import '../../../app_utils/app_images.dart';
import '../../../app_utils/custom_textFiled.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';

class BusTicketPayScreen extends StatefulWidget {
  const BusTicketPayScreen({super.key});
  @override
  State<BusTicketPayScreen> createState() => _BusTicketPayScreenState();
}

class _BusTicketPayScreenState extends State<BusTicketPayScreen> {
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
                "Payment",
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SizedBox(
          height: 55,
          child: CommonButton(
            text: "Proceed To Pay",
            textColor: white,
            gradient: const LinearGradient(
              colors: [pinkColor, purpleGradientColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            fontWeight: FontWeight.w600,
            fontFamily: FontFamily.plusJakartaSansBold,
            fontSize: 16.0,

            //padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            //borderRadius: BorderRadius.circular(40.0),
            onPressed: () {},
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Order ID",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w500,
                          ),
                          text(
                            "OFU5395107520M",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Trip",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w500,
                          ),
                          text(
                            "Jaipur (Rajasthan) to Udaipur (Rajasthan)",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Operator",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w500,
                          ),
                          text(
                            "Gajraj Travels",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Date",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w500,
                          ),
                          text(
                            "15-10-2025 06:20 PM",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Number of tickets",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w500,
                          ),
                          text(
                            "1",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "₹ 842.00",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor: blackColor,
                            fontSize: 18,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600,
                          ),
                          text(
                            "Price Valid for 9:57",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
