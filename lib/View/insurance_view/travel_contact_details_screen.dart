import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jigrotech/View/insurance_view/traveller_details.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';
import '../../app_utils/custom_textFiled.dart';

class TravelContactDetailsScreen extends StatefulWidget {
  final String? serviceNo;

  const TravelContactDetailsScreen({super.key, this.serviceNo});

  @override
  State<TravelContactDetailsScreen> createState() =>
      _TravelContactDetailsScreenState();
}

class _TravelContactDetailsScreenState
    extends State<TravelContactDetailsScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
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
                widget.serviceNo ?? "",
                textAlign: TextAlign.center,
                isCentered: true,
                maxLine: 2,
                textColor: white,
                fontSize: 18,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
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
              Image.asset(AppImages.bannerTextImage),
              SizedBox(height: 10),
              text(
                "Primary Contact Details",
                maxLine: 2,
                textColor: blackColor,
                fontSize: 18,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 10),
              CustomRoundTextField(
                controller: nameController,
                keyboardType: TextInputType.name,
                hintText: "Full Name",
                maxLines: 2,
                fillColor: Colors.transparent,
                //padding: const EdgeInsets.symmetric(vertical: 2),
                inputFormatters: [LengthLimitingTextInputFormatter(20)],
              ),
              text(
                "As mentioned on traveller's passport",
                maxLine: 2,
                textColor: blackColor,
                fontSize: 13,
                fontFamily: FontFamily.plusJakartaSansRegular,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 20),
              CustomRoundTextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: "Email Id",
                maxLines: 2,
                fillColor: Colors.transparent,
                //padding: const EdgeInsets.symmetric(vertical: 2),
                inputFormatters: [LengthLimitingTextInputFormatter(20)],
              ),
              text(
                "All communication related to your policy will be sent on this Email Id",
                maxLine: 2,
                textColor: blackColor,
                fontSize: 13,
                fontFamily: FontFamily.plusJakartaSansRegular,
                fontWeight: FontWeight.w400,
              ),

              SizedBox(height: 120),
              text(
                "Please complete your journey within next 30 mins to secure your insurance at the current premium. Post 30 mins, premium may change based on risk assessment.",
                textColor: greyColor,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansRegular,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 55,
                child: CommonButton(
                  text: "Next",
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
                        builder: (context) => TravellerDetails(),
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
