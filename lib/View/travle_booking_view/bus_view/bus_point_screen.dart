import 'package:flutter/material.dart';
import 'package:jigrotech/View/travle_booking_view/bus_view/bus_passenger_screen.dart';
import 'package:jigrotech/View/travle_booking_view/flight_view/flight_travle_form_screen.dart';

import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';

class BusPointScreen extends StatefulWidget {
  const BusPointScreen({super.key});
  @override
  State<BusPointScreen> createState() => _BusPointScreenState();
}

class _BusPointScreenState extends State<BusPointScreen> {
  bool isChecked = false;
  int? isSelected;
  bool? isSelectedPoint;
  bool? isSelectedEndPoint;
  @override
  void initState() {
    super.initState();
  }

  List<Map<String, dynamic>> allDate = [
    {
      "name": "Gajraj Travels Kamla bhawan Opp. Hotel Neelam jaipur",
      "time": "18:15",
    },
    {"name": "Gajraj Travels Ajmeri Pulliya", "time": "18:20"},
    {"name": "200 feet bypass 9414114515", "time": "18:35"},
  ];

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
            Column(
              children: [
                Row(
                  children: [
                    text(
                      "JAI",
                      textAlign: TextAlign.center,
                      isCentered: true,
                      textColor: white,
                      fontSize: 18,
                      fontFamily: FontFamily.plusJakartaSansBold,
                      fontWeight: FontWeight.w600,
                    ),
                    Icon(Icons.arrow_forward, color: white),
                    text(
                      "DEL",
                      textAlign: TextAlign.center,
                      isCentered: true,
                      textColor: white,
                      fontSize: 18,
                      fontFamily: FontFamily.plusJakartaSansBold,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                text(
                  "13 Oct • 1 Traveller • Economy",
                  textAlign: TextAlign.center,
                  isCentered: true,
                  textColor: white,
                  fontSize: 14,
                  fontFamily: FontFamily.plusJakartaSansRegular,
                  fontWeight: FontWeight.w400,
                ),
              ],
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: 55,
          child: CommonButton(
            text: "Proceed",
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
                MaterialPageRoute(builder: (context) => BusPassengerScreen()),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isSelectedPoint = true;
                      });
                    },
                    child: text(
                      "Boarding Point",
                      textColor: isSelectedPoint != true
                          ? greyColor
                          : purpleGradientColor,
                      fontSize: 18,
                      fontFamily: FontFamily.plusJakartaSansBold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      setState(() {
                        isSelectedPoint = false;
                      });
                    },
                    child: text(
                      "Dropping Points",
                      textColor: isSelectedPoint == true
                          ? greyColor
                          : purpleGradientColor,
                      fontSize: 18,
                      fontFamily: FontFamily.plusJakartaSansBold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              text(
                isSelectedPoint == true
                    ? "Select your Boarding Point"
                    : "Select your Dropping Point",
                textColor: blackColor,
                fontSize: 18,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),
              isSelectedPoint == true
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: allDate.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        bool isSelectedColor = isSelected == index;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isSelected = index;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: isSelectedColor
                                    ? lightBlueColor
                                    : lightWhite1Color,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // ✅ Radio button added here
                                  Radio<int>(
                                    value: index,
                                    groupValue: isSelected,
                                    activeColor:
                                        blue1Color, // optional custom color
                                    onChanged: (value) {
                                      setState(() {
                                        isSelected = value!;
                                      });
                                    },
                                  ),

                                  // ✅ Name text
                                  Expanded(
                                    child: text(
                                      allDate[index]["name"],
                                      maxLine: 2,
                                      textColor: isSelectedColor
                                          ? blue1Color
                                          : blackColor,
                                      fontSize: 14,
                                      fontFamily:
                                          FontFamily.plusJakartaSansMedium,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                  // ✅ Time text
                                  text(
                                    allDate[index]["time"],
                                    textAlign: TextAlign.center,
                                    isCentered: true,
                                    textColor: isSelectedColor
                                        ? blue1Color
                                        : blackColor,
                                    fontSize: 14,
                                    fontFamily: FontFamily.plusJakartaSansBold,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: allDate.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        bool isSelectedColor = isSelected == index;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isSelected = index;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: isSelectedColor
                                    ? yellowColor
                                    : lightWhite1Color,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // ✅ Radio button added here
                                  Radio<int>(
                                    value: index,
                                    groupValue: isSelected,
                                    activeColor:
                                        blue1Color, // optional custom color
                                    onChanged: (value) {
                                      setState(() {
                                        isSelected = value!;
                                      });
                                    },
                                  ),

                                  // ✅ Name text
                                  Expanded(
                                    child: text(
                                      allDate[index]["name"],
                                      maxLine: 2,
                                      textColor: isSelectedColor
                                          ? blue1Color
                                          : blackColor,
                                      fontSize: 14,
                                      fontFamily:
                                          FontFamily.plusJakartaSansMedium,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                  // ✅ Time text
                                  text(
                                    allDate[index]["time"],
                                    textAlign: TextAlign.center,
                                    isCentered: true,
                                    textColor: isSelectedColor
                                        ? blue1Color
                                        : blackColor,
                                    fontSize: 14,
                                    fontFamily: FontFamily.plusJakartaSansBold,
                                    fontWeight: FontWeight.w600,
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
