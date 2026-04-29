import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/View/travle_booking_view/flight_view/search_flight_screen.dart';
import 'package:jigrotech/View/travle_booking_view/hotel_view/search_hotels_screen.dart';
import 'package:jigrotech/app_utils/app_images.dart';

import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';

class HotelHomeScreen extends StatefulWidget {
  const HotelHomeScreen({super.key});
  @override
  State<HotelHomeScreen> createState() => _HotelHomeScreenState();
}

class _HotelHomeScreenState extends State<HotelHomeScreen> {
  bool isChecked = false;
  TextEditingController searchStationController = TextEditingController();
  TextEditingController checkInController = TextEditingController();
  TextEditingController checkOutController = TextEditingController();

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
              "JigroPay",
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: text(
                      "EaseMyTrip",
                      textAlign: TextAlign.center,
                      isCentered: true,
                      textColor: blue1Color,
                      fontSize: 24,
                      fontFamily: FontFamily.plusJakartaSansBold,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: 4),
                  text(
                    ".com",
                    textAlign: TextAlign.center,
                    isCentered: true,
                    textColor: purpleGradientColor,
                    fontSize: 24,
                    fontFamily: FontFamily.plusJakartaSansBold,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              Center(
                child: text(
                  "SAME HOTEL, CHEAPEST PRICE, GUARANTEED!",
                  textAlign: TextAlign.center,
                  isCentered: true,
                  textColor: greyColor,
                  fontSize: 12,
                  fontFamily: FontFamily.plusJakartaSansRegular,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(height: 10),
              TextField(
                controller: searchStationController,
                keyboardType: TextInputType.name,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(15),

                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
                ],
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: lightGreyColor),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: lightGreyColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: lightGreyColor),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  filled: true,

                  fillColor: white,
                  hintText: "Enter City name, Location or Specific hotel",
                  hintStyle: const TextStyle(
                    fontSize: 16.0,
                    color: lightWhiteColor,
                    fontFamily: 'Roboto-Light',
                  ),
                  contentPadding: const EdgeInsets.only(
                    top: 5,
                    left: 10,
                    bottom: 5,
                    right: 0,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text(
                    "CHECK-IN",
                    textAlign: TextAlign.center,
                    isCentered: true,
                    textColor: greyColor,
                    fontSize: 14,
                    fontFamily: FontFamily.plusJakartaSansRegular,
                    fontWeight: FontWeight.w400,
                  ),

                  text(
                    "CHECK-OUT",
                    textAlign: TextAlign.center,
                    isCentered: true,
                    textColor: greyColor,
                    fontSize: 14,
                    fontFamily: FontFamily.plusJakartaSansRegular,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
                    child: TextField(
                      controller: checkInController,
                      keyboardType: TextInputType.name,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(15),

                        FilteringTextInputFormatter.allow(
                          RegExp('[a-zA-Z0-9]'),
                        ),
                      ],
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: lightGreyColor),
                          borderRadius: BorderRadius.circular(10),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: lightGreyColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: lightGreyColor),
                          borderRadius: BorderRadius.circular(10),
                        ),

                        filled: true,

                        fillColor: white,
                        hintText: "CheckIn",
                        hintStyle: const TextStyle(
                          fontSize: 16.0,
                          color: lightWhiteColor,
                          fontFamily: 'Roboto-Light',
                        ),
                        contentPadding: const EdgeInsets.only(
                          top: 5,
                          left: 10,
                          bottom: 5,
                          right: 0,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 150,
                    child: TextField(
                      controller: checkOutController,
                      keyboardType: TextInputType.name,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(15),

                        FilteringTextInputFormatter.allow(
                          RegExp('[a-zA-Z0-9]'),
                        ),
                      ],
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: lightGreyColor),
                          borderRadius: BorderRadius.circular(10),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: lightGreyColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: lightGreyColor),
                          borderRadius: BorderRadius.circular(10),
                        ),

                        filled: true,

                        fillColor: white,
                        hintText: "CheckOut",
                        hintStyle: const TextStyle(
                          fontSize: 16.0,
                          color: lightWhiteColor,
                          fontFamily: 'Roboto-Light',
                        ),
                        contentPadding: const EdgeInsets.only(
                          top: 5,
                          left: 10,
                          bottom: 5,
                          right: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.person, color: greyColor),
                  SizedBox(width: 10),
                  text(
                    "2 Guest, 1 Room",
                    textAlign: TextAlign.center,
                    isCentered: true,
                    textColor: blackColor,
                    fontSize: 16,
                    fontFamily: FontFamily.plusJakartaSansBold,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),

              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchHotelsScreen(),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [lightBtnColor, lightBtn1Color],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, color: white),
                      text(
                        "Search Hotel",
                        textColor: white,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        maxLine: 3,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SvgPicture.asset(AppImages.bookingImage),
                      SizedBox(height: 5),
                      text(
                        "My Bookings",
                        textColor: blackColor,
                        fontFamily: FontFamily.plusJakartaSansRegular,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        maxLine: 3,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SvgPicture.asset(AppImages.supportImage),
                      SizedBox(height: 5),
                      text(
                        "Customer Support",
                        textColor: blackColor,
                        fontFamily: FontFamily.plusJakartaSansRegular,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        maxLine: 3,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Image.asset(AppImages.hotalImage),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text(
                    "Our Top Hotel Chains",
                    textColor: blackColor,
                    fontFamily: FontFamily.plusJakartaSansBold,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    maxLine: 3,
                  ),

                  Row(
                    children: [
                      text(
                        "View All",
                        textColor: blue1Color,
                        fontFamily: FontFamily.plusJakartaSansRegular,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        maxLine: 3,
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: blue1Color,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          //borderRadius: BorderRadius.circular(20),
                          color: lightRedColor,
                          shape: BoxShape.circle,
                        ),
                        child: text(
                          "Spree",
                          textColor: red1Color,
                          fontFamily: FontFamily.plusJakartaSansBold,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          maxLine: 3,
                        ),
                      ),
                      text(
                        "20% OFF",
                        textColor: lightGreenColor,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        maxLine: 3,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          //borderRadius: BorderRadius.circular(20),
                          color: lightWhite1Color,
                          shape: BoxShape.circle,
                        ),
                        child: text(
                          "Hosteller",
                          textColor: blackColor,
                          fontFamily: FontFamily.plusJakartaSansBold,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          maxLine: 3,
                        ),
                      ),
                      text(
                        "20% OFF",
                        textColor: lightGreenColor,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        maxLine: 3,
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          //borderRadius: BorderRadius.circular(20),
                          color: lightPink1Color,
                          shape: BoxShape.circle,
                        ),
                        child: text(
                          "The Fern",
                          textColor: pinkColor,
                          fontFamily: FontFamily.plusJakartaSansBold,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          maxLine: 3,
                        ),
                      ),
                      text(
                        "20% OFF",
                        textColor: lightGreenColor,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        maxLine: 3,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              text(
                "Why Book With Us?",
                textColor: blackColor,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                maxLine: 3,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: lightRedColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(AppImages.ratingImage),
                          text(
                            "Best Hotels",
                            textColor: blackColor,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            maxLine: 3,
                          ),
                          text(
                            "Find hotels for different destinations",
                            textColor: greyColor,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            maxLine: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: lightGreyColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(AppImages.moneyImage),
                          text(
                            "Massive Savings",
                            textColor: blackColor,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            maxLine: 3,
                          ),
                          text(
                            "Enjoy hotel bookings with best offers",
                            textColor: greyColor,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                            maxLine: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: lightYellowColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(AppImages.ratingImage),
                          text(
                            "Hotel Ratings",
                            textColor: blackColor,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            maxLine: 3,
                          ),
                          text(
                            "Good ratings based on Trip Advisor",
                            textColor: greyColor,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            maxLine: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: lightGreyColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(AppImages.bestPriceImage),
                          text(
                            "Best Price",
                            textColor: blackColor,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            maxLine: 3,
                          ),
                          text(
                            "Get excellent hotels/resorts",
                            textColor: greyColor,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            maxLine: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
