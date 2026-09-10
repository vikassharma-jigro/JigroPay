import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../app_utils/razorpay_helper.dart';
import '../../../main.dart';

class TrainBookHistoryScreen extends StatefulWidget {
  const TrainBookHistoryScreen({super.key});
  @override
  State<TrainBookHistoryScreen> createState() => _TrainBookHistoryScreenState();
}

class _TrainBookHistoryScreenState extends State<TrainBookHistoryScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: blackColor),
            ),
            Expanded(
              child: text(
                "Payment",
                textAlign: TextAlign.center,
                isCentered: true,
                textColor: blackColor,
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
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 55,
          child: CommonButton(
            text: "Proceed To Pay ₹855",
            textColor: white,
            gradient: const LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            fontWeight: FontWeight.w600,
            fontFamily: FontFamily.plusJakartaSansBold,
            fontSize: 16.0,

            //padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            //borderRadius: BorderRadius.circular(40.0),
            onPressed: () {
              RazorpayHelper(context: context, type: "train").startPaymentWithOrderFlow(
                context: context,
                opcode: "TRAIN",
                number: "TRAIN_BOOKING",
                amount: 855.0,
                type: "train",
                description: "Train Ticket Payment",
                serviceName: "Train Ticket",
                providerName: "IRCTC Train Booking",
              );
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Card(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Order ID",
                            textColor: greyColor,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                          ),

                          text(
                            "#158022281",
                            textColor: blackColor,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Trip to",
                            textColor: greyColor,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                          ),

                          text(
                            "UDZ",
                            textColor: blackColor,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Trip from",
                            textColor: greyColor,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                          ),

                          text(
                            "JP",
                            textColor: blackColor,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Date",
                            textColor: greyColor,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                          ),

                          text(
                            "20-10-2025 06:20 AM",
                            textColor: blackColor,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "₹855",
                            textColor: blackColor,
                            fontSize: 18,
                            fontFamily: FontFamily.plusJakartaSansBold,
                          ),

                          text(
                            "Price Valid for 14:57",
                            textColor: blackColor,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansMedium,
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
