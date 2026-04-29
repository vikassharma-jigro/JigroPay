import 'package:flutter/material.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';
import 'hotel_details_screen.dart';

class SearchHotelsScreen extends StatefulWidget {
  const SearchHotelsScreen({super.key});
  @override
  State<SearchHotelsScreen> createState() => _SearchHotelsScreenState();
}

class _SearchHotelsScreenState extends State<SearchHotelsScreen> {
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
            text(
              "Hotel",
              textAlign: TextAlign.center,
              isCentered: true,
              textColor: white,
              fontSize: 18,
              fontFamily: FontFamily.plusJakartaSansBold,
              fontWeight: FontWeight.w600,
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: white),
              ),
              child: text(
                "About",
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
            children: [
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                itemCount: 10,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HotelDetailsScreen(),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(AppImages.modernElevationImage),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: blueColor),

                              Expanded(
                                child: text(
                                  "New Delhi • Hanuman Road • Janpath • Connaught Place",
                                  textColor: blackColor,
                                  fontSize: 14,
                                  fontFamily: FontFamily.plusJakartaSansRegular,
                                  fontWeight: FontWeight.w500,
                                  maxLine: 2,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: blueColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: text(
                                    "4.2",
                                    textColor: white,
                                    fontSize: 14,
                                    fontFamily: FontFamily.plusJakartaSansBold,
                                    fontWeight: FontWeight.w600,
                                    maxLine: 2,
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  text(
                                    "Excellent",
                                    textColor: blackColor,
                                    fontSize: 14,
                                    fontFamily:
                                        FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w500,
                                    maxLine: 2,
                                  ),
                                  text(
                                    "6336 reviews",
                                    textColor: greyColor,
                                    fontSize: 14,
                                    fontFamily:
                                        FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w500,
                                    maxLine: 2,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: 10),
                          Row(
                            children: [
                              text(
                                "₹19,499",
                                lineThrough: true,
                                textColor: greyColor,
                                fontSize: 14,
                                fontFamily: FontFamily.plusJakartaSansBold,
                                fontWeight: FontWeight.w600,
                                maxLine: 2,
                              ),
                              SizedBox(width: 10),
                              text(
                                "₹14,984",
                                textColor: blackColor,
                                fontSize: 14,
                                fontFamily: FontFamily.plusJakartaSansRegular,
                                fontWeight: FontWeight.w500,
                                maxLine: 2,
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          text(
                            "Couple friendly Free wifi",
                            textColor: greyColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w400,
                            maxLine: 2,
                          ),
                          text(
                            "Gym • Swimming Pool",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w400,
                            maxLine: 2,
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: yellowColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    text(
                                      "SUPER DEAL",
                                      textColor: blackColor,
                                      fontSize: 14,
                                      fontFamily:
                                          FontFamily.plusJakartaSansBold,
                                      fontWeight: FontWeight.w400,
                                      maxLine: 2,
                                    ),
                                  ],
                                ),
                                text(
                                  "• 10% Discount on Food & Soft Beverages",
                                  textColor: blackColor,
                                  fontSize: 14,
                                  fontFamily: FontFamily.plusJakartaSansBold,
                                  fontWeight: FontWeight.w400,
                                  maxLine: 2,
                                ),
                                text(
                                  "• Flat ₹500 Cashback on Bookings above ₹5000",
                                  textColor: blackColor,
                                  fontSize: 14,
                                  fontFamily: FontFamily.plusJakartaSansBold,
                                  fontWeight: FontWeight.w400,
                                  maxLine: 2,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: lightGreyColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    text(
                                      "Punjab Bank Credit Card",
                                      textColor: blackColor,
                                      fontSize: 14,
                                      fontFamily:
                                          FontFamily.plusJakartaSansMedium,
                                      fontWeight: FontWeight.w400,
                                      maxLine: 2,
                                    ),
                                  ],
                                ),
                                text(
                                  "Get flat ₹6000 Off",
                                  textColor: blackColor,
                                  fontSize: 14,
                                  fontFamily: FontFamily.plusJakartaSansMedium,
                                  fontWeight: FontWeight.w400,
                                  maxLine: 2,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
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
