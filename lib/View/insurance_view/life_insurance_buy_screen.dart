import 'package:flutter/material.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';

class LifeInsuranceBuyScreen extends StatefulWidget {
  const LifeInsuranceBuyScreen({super.key});

  @override
  State<LifeInsuranceBuyScreen> createState() => _LifeInsuranceBuyScreenState();
}

class _LifeInsuranceBuyScreenState extends State<LifeInsuranceBuyScreen> {
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
                  "Review and Buy",
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          //crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    text(
                      "₹918/month",
                      textColor: blackColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.plusJakartaSansBold,
                      fontSize: 18.0,
                    ),
                    text(
                      "Premium amount",
                      textColor: greyColor,
                      fontWeight: FontWeight.w400,
                      fontFamily: FontFamily.plusJakartaSansRegular,
                      fontSize: 12.0,
                    ),
                  ],
                ),
                Container(
                  width: 130,
                  //alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [pinkColor, purpleGradientColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.call, color: white),
                      text(
                        "Talk To Us",
                        textColor: white,

                        fontWeight: FontWeight.w600,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontSize: 18.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              // width: MediaQuery.sizeOf(context).width,
              height: 55,
              child: CommonButton(
                text: "BUY PLAN",
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
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => LifeInsuranceBuyScreen(),));
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
              Card(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "TATA AIA Sampoorna Raksha\nPromise",
                            textColor: blackColor,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w400,
                          ),
                          Image.asset(AppImages.iciBnkImage, height: 30),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Cover Amount",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w400,
                          ),

                          text(
                            "₹1,00,00,000",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),

                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Covered Till",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w400,
                          ),

                          text(
                            "Age of 60",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),

                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Payment till",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w400,
                          ),

                          text(
                            "End of policy cover",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: lightColor1,
                        ),
                        child: text(
                          "Premium from second year onwards will be ₹1,124",
                          textColor: blue1Color,
                          fontSize: 14,
                          fontFamily: FontFamily.plusJakartaSansRegular,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),
              text(
                "Policyholder Details",
                textColor: blackColor,
                fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 10),
              Card(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Name",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w400,
                          ),
                          text(
                            "Vikash Sharma",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Annual Income",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w400,
                          ),

                          text(
                            "₹1,00,00,000",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),

                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "PAN Number",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w400,
                          ),

                          text(
                            "PYKPS7432D",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),

                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Pincode",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w400,
                          ),

                          text(
                            "302029",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),
              text(
                "Additional details",
                textColor: blackColor,
                fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 10),
              Card(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Date of birth",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w400,
                          ),
                          text(
                            "30 Oct 2000",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Gender",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w400,
                          ),

                          text(
                            "Male",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),

                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Occupation",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w400,
                          ),

                          text(
                            "Salaried",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),

                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Education",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w400,
                          ),

                          text(
                            "Post graduate",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: lightGreen,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: text(
                        "No GST amount will be collected on Life Insurance Premiums",
                        textColor: lightGreenColor,
                        fontSize: 14,
                        maxLine: 2,
                        fontFamily: FontFamily.plusJakartaSansRegular,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
