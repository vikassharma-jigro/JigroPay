import 'package:flutter/material.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';
import 'life_policy_details_screen.dart';

class LifeQuotationsScreen extends StatefulWidget {
  const LifeQuotationsScreen({super.key});

  @override
  State<LifeQuotationsScreen> createState() => _LifeQuotationsScreenState();
}

class _LifeQuotationsScreenState extends State<LifeQuotationsScreen> {
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
                  "Term Life Insurance",
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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 130,
              alignment: Alignment.centerRight,
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: lightColor1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "FEMALE - 24 years",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w400,
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text(
                                "Sum Assured",
                                textColor: blackColor,
                                fontSize: 14,
                                fontFamily: FontFamily.plusJakartaSansRegular,
                                fontWeight: FontWeight.w400,
                              ),

                              text(
                                "₹1 Crore",
                                textColor: blackColor,
                                fontSize: 14,
                                fontFamily: FontFamily.plusJakartaSansBold,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Cover till age 60 years",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w400,
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text(
                                "Payment Frequency",
                                textColor: blackColor,
                                fontSize: 14,
                                fontFamily: FontFamily.plusJakartaSansRegular,
                                fontWeight: FontWeight.w400,
                              ),
                              text(
                                "Monthly",
                                textColor: blackColor,
                                fontSize: 14,
                                fontFamily: FontFamily.plusJakartaSansBold,
                                fontWeight: FontWeight.w400,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text(
                                "Pay Till",
                                textColor: blackColor,
                                fontSize: 14,
                                fontFamily: FontFamily.plusJakartaSansRegular,
                                fontWeight: FontWeight.w400,
                              ),
                              text(
                                "End of cover",
                                textColor: blackColor,
                                fontSize: 14,
                                fontFamily: FontFamily.plusJakartaSansBold,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),

                          text(
                            "Additional Benefits",
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
              SizedBox(height: 20),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Card(
                      color: white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(AppImages.iciBnkImage, height: 30),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        text(
                                          "₹918",
                                          textColor: blackColor,
                                          fontSize: 20,
                                          fontFamily:
                                              FontFamily.plusJakartaSansBold,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        text(
                                          "per Month",
                                          textColor: blackColor,
                                          fontSize: 14,
                                          fontFamily:
                                              FontFamily.plusJakartaSansRegular,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: red1Color,
                                      ),
                                      child: text(
                                        "19% Off",
                                        textColor: white,
                                        fontSize: 13,
                                        fontFamily:
                                            FontFamily.plusJakartaSansRegular,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            text(
                              "Sampoorna Raksha Promise",
                              textColor: blackColor,
                              fontSize: 14,
                              fontFamily: FontFamily.plusJakartaSansBold,
                              fontWeight: FontWeight.w400,
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.green,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: white,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 10),
                                text(
                                  "Claim settlement 99.13%",
                                  textColor: blackColor,
                                  fontSize: 14,
                                  fontFamily: FontFamily.plusJakartaSansRegular,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.green,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: white,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 10),
                                text(
                                  "Flexipay Benefit",
                                  textColor: blackColor,
                                  fontSize: 14,
                                  fontFamily: FontFamily.plusJakartaSansRegular,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.green,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: white,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 10),
                                text(
                                  "Instant Claim",
                                  textColor: blackColor,
                                  fontSize: 14,
                                  fontFamily: FontFamily.plusJakartaSansRegular,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                height: 55,
                                child: CommonButton(
                                  text: "Select",
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
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            LifePolicyDetailsScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
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
