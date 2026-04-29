import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';

class HotelOrderHistoryScreen extends StatefulWidget {
  const HotelOrderHistoryScreen({super.key});
  @override
  State<HotelOrderHistoryScreen> createState() =>
      _HotelOrderHistoryScreenState();
}

class _HotelOrderHistoryScreenState extends State<HotelOrderHistoryScreen> {
  String? _selectedCard;
  String? _selectedUpi;
  String? _selectedBanking;
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 55,
          child: CommonButton(
            text: "Proceed To Pay ₹3,398",
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: lightRedColor,
                ),
                child: Row(
                  children: [
                    text(
                      "Complete payment within 14:56 minutes",
                      textColor: red1Color,
                      fontSize: 14,
                      fontFamily: FontFamily.plusJakartaSansMedium,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              Card(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(AppImages.roomImage, height: 50),
                          const SizedBox(width: 10),
                          Column(
                            children: [
                              text(
                                "Classic Room",
                                textColor: blackColor,
                                fontSize: 16,
                                fontFamily: FontFamily.plusJakartaSansMedium,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: yellowColor,
                                    size: 20,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: yellowColor,
                                    size: 20,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: yellowColor,
                                    size: 20,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: yellowColor,
                                    size: 20,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: yellowColor,
                                    size: 20,
                                  ),
                                  text(
                                    "4.2",
                                    textColor: blackColor,
                                    fontSize: 12,
                                    fontFamily:
                                        FontFamily.plusJakartaSansMedium,
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 20),
                                  text(
                                    "New Delhi Airport",
                                    textColor: blackColor,
                                    fontSize: 14,
                                    fontFamily:
                                        FontFamily.plusJakartaSansMedium,
                                  ),
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
                            "Check-in",
                            textColor: greyColor,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                          ),

                          text(
                            "15 Oct 2024",
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
                            "Check-out",
                            textColor: greyColor,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                          ),

                          text(
                            "16 Oct 2024",
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
                            "Room & Guests",
                            textColor: greyColor,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                          ),

                          text(
                            "1 Room, 2 Adults",
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
                            "Duration",
                            textColor: greyColor,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                          ),

                          text(
                            "1 Night",
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

              const SizedBox(height: 10),
              Card(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text(
                        "Price Breakdown",
                        textColor: greyColor,
                        fontSize: 18,
                        fontFamily: FontFamily.plusJakartaSansBold,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Room Price (1 night)",
                            textColor: greyColor,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                          ),

                          text(
                            "₹2,890",
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
                            "Taxes & Fees",
                            textColor: greyColor,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                          ),

                          text(
                            "₹508",
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
                            "Check-out",
                            textColor: greyColor,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                          ),

                          text(
                            "16 Oct 2024",
                            textColor: blackColor,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(thickness: .5, color: greyColor),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Total Amount",
                            textColor: blackColor,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                          ),

                          text(
                            "₹3,398",
                            textColor: purpleGradientColor,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansBold,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Card(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text(
                        "Payment Options",
                        textColor: blackColor,
                        fontSize: 18,
                        fontFamily: FontFamily.plusJakartaSansBold,
                      ),

                      SizedBox(height: 10),
                      Row(
                        children: [
                          Radio<String>(
                            value: "Card",
                            activeColor: pinkColor,
                            groupValue: _selectedCard,
                            onChanged: (value) =>
                                setState(() => _selectedCard = value),
                          ),
                          //SizedBox(width: 10,),
                          SvgPicture.asset(
                            AppImages.creditCardIcon,
                            height: 20,
                          ),
                          SizedBox(width: 10),
                          text(
                            "Credit/Debit Card",
                            textColor: blackColor,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Radio<String>(
                            value: "Upi",
                            activeColor: pinkColor,
                            groupValue: _selectedCard,
                            onChanged: (value) =>
                                setState(() => _selectedCard = value),
                          ),
                          // SizedBox(width: 10,),
                          SvgPicture.asset(AppImages.upiImage, height: 30),
                          SizedBox(width: 10),
                          text(
                            "UPI",
                            textColor: blackColor,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Radio<String>(
                            value: "Banking",
                            activeColor: pinkColor,
                            groupValue: _selectedCard,
                            onChanged: (value) =>
                                setState(() => _selectedCard = value),
                          ),
                          //SizedBox(width: 10,),
                          SvgPicture.asset(
                            AppImages.netBankingImage,
                            height: 30,
                          ),
                          SizedBox(width: 10),
                          text(
                            "Net Banking",
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
