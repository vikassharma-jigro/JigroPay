import 'package:flutter/material.dart';
import 'package:jigrotech/View/bank_view/pin_screen.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';
import 'package:flutter/gestures.dart';

class CarReviewInsuranceDetailsScreen extends StatefulWidget {
  const CarReviewInsuranceDetailsScreen({super.key});

  @override
  State<CarReviewInsuranceDetailsScreen> createState() =>
      _CarReviewInsuranceDetailsScreenState();
}

class _CarReviewInsuranceDetailsScreenState
    extends State<CarReviewInsuranceDetailsScreen> {
  bool isChecked = false;
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
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: white),
            ),
            Expanded(
              child: Center(
                child: text(
                  "Review Other Details",
                  textAlign: TextAlign.center,
                  isCentered: true,
                  textColor: white,
                  fontSize: 18,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // SizedBox(width: 10,),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                      print("hhh>>>$isChecked");
                    });
                  },
                  activeColor: purpleGradientColor,
                  //checkColor: Colors.white,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  side: const BorderSide(color: purpleGradientColor, width: 1),
                ),

                SizedBox(width: 10),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'By proceeding, I agree to the ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: FontFamily.plusJakartaSansRegular,
                        ),
                      ),
                      TextSpan(
                        text: 'Terms & Conditions\n',
                        recognizer: TapGestureRecognizer()..onTap = () {},
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: purpleGradientColor,
                          fontSize: 12,
                          fontFamily: FontFamily.plusJakartaSansRegular,
                        ),
                      ),
                      TextSpan(
                        text: 'and confirm that my vehicle is not a co.',
                        recognizer: TapGestureRecognizer()..onTap = () {},
                        style: const TextStyle(
                          // decoration: TextDecoration.underline,
                          color: greyColor,
                          fontSize: 12,
                          fontFamily: FontFamily.plusJakartaSansRegular,
                        ),
                      ),
                      TextSpan(
                        text: 'view more',
                        recognizer: TapGestureRecognizer()..onTap = () {},
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: purpleGradientColor,
                          fontSize: 12,
                          fontFamily: FontFamily.plusJakartaSansRegular,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text(
                  "Premium (Incl. of GST)",
                  textAlign: TextAlign.center,
                  isCentered: true,
                  textColor: greyColor,
                  fontSize: 14,
                  fontFamily: FontFamily.plusJakartaSansRegular,
                  fontWeight: FontWeight.w600,
                ),

                text(
                  "₹1,249/month",
                  textAlign: TextAlign.center,
                  isCentered: true,
                  textColor: blackColor,
                  fontSize: 16,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: 55,
              child: CommonButton(
                text: "Proceed to Pay",
                textColor: white,
                gradient: const LinearGradient(
                  colors: [pinkColor, purpleGradientColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                fontWeight: FontWeight.w600,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontSize: 18.0,

                //padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                //borderRadius: BorderRadius.circular(40.0),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpiPinScreen()),
                  );
                },
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: pinkColor.withOpacity(.4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        text(
                          "Honda Dream Yuga",
                          textAlign: TextAlign.center,
                          isCentered: true,
                          textColor: blackColor,
                          fontSize: 14,
                          fontFamily: FontFamily.plusJakartaSansMedium,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),

                    text(
                      "RJ 19 KS 8896",
                      textAlign: TextAlign.center,
                      isCentered: true,
                      textColor: greyColor,
                      fontSize: 16,
                      fontFamily: FontFamily.plusJakartaSansRegular,
                      fontWeight: FontWeight.w400,
                    ),

                    SizedBox(height: 10),

                    text(
                      "NCB: 50%",
                      textAlign: TextAlign.center,
                      isCentered: true,
                      textColor: blackColor,
                      fontSize: 16,
                      fontFamily: FontFamily.plusJakartaSansBold,
                      fontWeight: FontWeight.w600,
                    ),

                    text(
                      "Download Policy Brochure",
                      textAlign: TextAlign.center,
                      isCentered: true,
                      textColor: blue1Color,
                      fontSize: 12,
                      fontFamily: FontFamily.plusJakartaSansMedium,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: lightYellowColor.withOpacity(.7),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 9),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: brownColor,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: text(
                          "i",
                          textColor: white,
                          fontSize: 14,
                          fontFamily: FontFamily.plusJakartaSansBold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: text(
                        "You will need to complete the KYC after successful payment.",
                        maxLine: 2,
                        textColor: brownColor,
                        fontSize: 13,
                        fontFamily: FontFamily.plusJakartaSansRegular,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text(
                    "Personal Details ",
                    textColor: blackColor,
                    fontSize: 18,
                    fontFamily: FontFamily.plusJakartaSansBold,
                    maxLine: 2,
                  ),
                  text(
                    "Edit",
                    textColor: blue1Color,
                    fontSize: 16,
                    fontFamily: FontFamily.plusJakartaSansBold,
                    maxLine: 2,
                  ),
                ],
              ),
              text(
                "Policy document will be sent here ",
                textColor: blackColor,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansRegular,
                maxLine: 2,
              ),

              SizedBox(height: 15),
              text(
                "Full name (as mentioned on RC):",
                textColor: blackColor,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansRegular,
                maxLine: 2,
              ),
              text(
                "MHS* KMR",
                textColor: blackColor,
                fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansMedium,
                maxLine: 2,
              ),

              SizedBox(height: 15),
              text(
                "Mobile number:",
                textColor: blackColor,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansRegular,
                maxLine: 2,
              ),
              text(
                "9696969969",
                textColor: blackColor,
                fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansMedium,
                maxLine: 2,
              ),
              SizedBox(height: 15),
              text(
                "Email ID:",
                textColor: blackColor,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansRegular,
                maxLine: 2,
              ),
              text(
                "vs@gmail.com",
                textColor: blackColor,
                fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansMedium,
                maxLine: 2,
              ),

              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text(
                    "Previous / Existing Policy Details",
                    textColor: blackColor,
                    fontSize: 18,
                    fontFamily: FontFamily.plusJakartaSansBold,
                    maxLine: 2,
                  ),
                  text(
                    "Edit",
                    textColor: blue1Color,
                    fontSize: 16,
                    fontFamily: FontFamily.plusJakartaSansBold,
                    maxLine: 2,
                  ),
                ],
              ),
              SizedBox(height: 10),
              text(
                "Existing Policy Insurer:",
                textColor: blackColor,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansRegular,
                maxLine: 2,
              ),
              text(
                "Iffco Tokio",
                textColor: blackColor,
                fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansMedium,
                maxLine: 2,
              ),
              SizedBox(height: 10),
              text(
                "Existing Policy Number:",
                textColor: blackColor,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansRegular,
                maxLine: 2,
              ),
              text(
                "MP7***47",
                textColor: blackColor,
                fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansMedium,
                maxLine: 2,
              ),

              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text(
                    "Vehicle Details",
                    textColor: blackColor,
                    fontSize: 18,
                    fontFamily: FontFamily.plusJakartaSansBold,
                    maxLine: 2,
                  ),
                  text(
                    "Edit",
                    textColor: blue1Color,
                    fontSize: 16,
                    fontFamily: FontFamily.plusJakartaSansBold,
                    maxLine: 2,
                  ),
                ],
              ),
              SizedBox(height: 10),
              text(
                "Vehicle Registration Number:",
                textColor: blackColor,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansRegular,
                maxLine: 2,
              ),
              text(
                "RJ19KS8896",
                textColor: blackColor,
                fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansMedium,
                maxLine: 2,
              ),
              SizedBox(height: 10),
              text(
                "Engine Number:",
                textColor: blackColor,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansRegular,
                maxLine: 2,
              ),
              text(
                "JC58ET31***15",
                textColor: blackColor,
                fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansMedium,
                maxLine: 2,
              ),
              SizedBox(height: 10),
              text(
                "Chassis Number:",
                textColor: blackColor,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansRegular,
                maxLine: 2,
              ),
              text(
                "ME4JC586KDT0*1",
                textColor: blackColor,
                fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansMedium,
                maxLine: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
