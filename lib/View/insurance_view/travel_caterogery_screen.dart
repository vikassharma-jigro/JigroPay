import 'package:flutter/material.dart';
import 'package:jigrotech/View/insurance_view/travel_plan_screen.dart';
import 'package:jigrotech/View/travle_booking_view/flight_view/flight_travle_form_screen.dart';

import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';

class TravelCategoryScreen extends StatefulWidget {
  const TravelCategoryScreen({super.key});
  @override
  State<TravelCategoryScreen> createState() => _TravelCategoryScreenState();
}

class _TravelCategoryScreenState extends State<TravelCategoryScreen> {
  bool isChecked = false;
  int? isSelected;
  @override
  void initState() {
    super.initState();
  }

  List<Map<String, dynamic>> travellingList = [
    {"name": "Adults", "dis": "(age above 18 and below 60 years)", "qty": 0},
    {"name": "Children", "dis": "(age below 18 years)", "qty": 0},
    {"name": "Senior Citizens", "dis": "(age above 60 years)", "qty": 0},
  ];

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
                "Select Travellers",
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            text(
              "By proceeding, you agree to our Terms & Conditions and Privacy Policy",
              textAlign: TextAlign.center,
              isCentered: true,
              textColor: blackColor,
              fontSize: 12,
              fontFamily: FontFamily.plusJakartaSansRegular,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 55,
              child: CommonButton(
                text: "GET QUOTE",
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
                    MaterialPageRoute(builder: (context) => TravelPlanScreen()),
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
              text(
                "Select Travellers",
                textAlign: TextAlign.center,
                isCentered: true,
                textColor: blackColor,
                fontSize: 18,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),

              text(
                "Choose the number of travellers for your trip",
                textAlign: TextAlign.center,
                isCentered: true,
                textColor: blackColor,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansRegular,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 20),
              ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: travellingList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                text(
                                  travellingList[index]["name"],
                                  textAlign: TextAlign.center,
                                  isCentered: true,
                                  textColor: blackColor,
                                  fontSize: 14,
                                  fontFamily: FontFamily.plusJakartaSansBold,
                                  fontWeight: FontWeight.w600,
                                ),

                                text(
                                  travellingList[index]["dis"],
                                  textAlign: TextAlign.center,
                                  isCentered: true,
                                  textColor: blackColor,
                                  fontSize: 14,
                                  fontFamily: FontFamily.plusJakartaSansRegular,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                _quantityButton(
                                  icon: Icons.remove,
                                  onTap: () {
                                    setState(() {
                                      if (travellingList[index]["qty"] > 0) {
                                        travellingList[index]["qty"]--;
                                      }
                                    });
                                  },
                                ),
                                SizedBox(width: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    travellingList[index]["qty"].toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                _quantityButton(
                                  icon: Icons.add,
                                  onTap: () {
                                    setState(() {
                                      travellingList[index]["qty"]++;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
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

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 20, color: Colors.deepPurple),
      ),
    );
  }
}
