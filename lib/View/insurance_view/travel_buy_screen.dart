import 'package:flutter/material.dart';
import 'package:jigrotech/View/insurance_view/travel_calender_screen.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';

class TravelBuyScreen extends StatefulWidget {
  const TravelBuyScreen({super.key});

  @override
  State<TravelBuyScreen> createState() => _TravelBuyScreenState();
}

class _TravelBuyScreenState extends State<TravelBuyScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientAppScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: white),
            ),
            Expanded(
              child: text(
                "Review and Buy",
                textColor: white,
                isCentered: true,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansBold,
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: asmaColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: text(
                          "You're just one step away from securing your trip. Plus, a FREE International e-SIM awaits!",
                          textAlign: TextAlign.center,
                          isCentered: true,
                          maxLine: 3,
                          textColor: blackColor,
                          fontSize: 14,
                          fontFamily: FontFamily.plusJakartaSansMedium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      Image.asset(AppImages.travelBuyImage, height: 50),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15),
              text(
                "Your Plan",
                textColor: blackColor,
                isCentered: true,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansBold,
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text(
                    "Group Silver Cover",
                    textColor: blackColor,
                    isCentered: true,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: FontFamily.plusJakartaSansBold,
                  ),
                  text(
                    "View Benefits",
                    textColor: pinkColor,
                    isCentered: true,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    fontFamily: FontFamily.plusJakartaSansMedium,
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text(
                    "Selected countries:",
                    textColor: blackColor,
                    isCentered: true,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    fontFamily: FontFamily.plusJakartaSansRegular,
                  ),
                  text(
                    "Vietnam",
                    textColor: blackColor,
                    isCentered: true,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    fontFamily: FontFamily.plusJakartaSansMedium,
                  ),
                ],
              ),

              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text(
                    "Cover validity:",
                    textColor: blackColor,
                    isCentered: true,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    fontFamily: FontFamily.plusJakartaSansRegular,
                  ),
                  text(
                    "16 Oct 2025 - 28 Oct 2025",
                    textColor: blackColor,
                    isCentered: true,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    fontFamily: FontFamily.plusJakartaSansMedium,
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text(
                    "Sum insured:",
                    textColor: blackColor,
                    isCentered: true,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    fontFamily: FontFamily.plusJakartaSansRegular,
                  ),
                  text(
                    "250,000/traveller",
                    textColor: blackColor,
                    isCentered: true,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    fontFamily: FontFamily.plusJakartaSansMedium,
                  ),
                ],
              ),

              SizedBox(height: 20),
              text(
                "Traveller details",
                textColor: blackColor,
                isCentered: true,
                fontWeight: FontWeight.w600,
                fontSize: 18,
                fontFamily: FontFamily.plusJakartaSansBold,
              ),

              text(
                "Traveller 1",
                textColor: blackColor,
                isCentered: true,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansMedium,
              ),
              text(
                "Vikash Sharma",
                textColor: blackColor,
                isCentered: true,
                fontWeight: FontWeight.w600,
                fontSize: 18,
                fontFamily: FontFamily.plusJakartaSansBold,
              ),
              text(
                "DOB: 01 Mar 2006",
                textColor: blackColor,
                isCentered: true,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansMedium,
              ),
              text(
                "Nominee: Default",
                textColor: blackColor,
                isCentered: true,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansMedium,
              ),
              text(
                "No medical conditions declared",
                textColor: blackColor,
                isCentered: true,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansMedium,
              ),
              const SizedBox(height: 60),
              text(
                "By proceeding, you agree to our Terms & Conditions and Privacy Policy. Premium includes taxes and fees. Coverage subject to policy terms and conditions.",
                textColor: greyColor,
                isCentered: true,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansMedium,
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 55,
                child: CommonButton(
                  text: "BUY ₹552",
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectTravelDatesScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
