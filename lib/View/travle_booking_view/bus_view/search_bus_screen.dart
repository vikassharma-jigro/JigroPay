import 'package:flutter/material.dart';
import 'package:jigrotech/View/travle_booking_view/bus_view/bus_point_screen.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';

class SearchBusScreen extends StatefulWidget {
  const SearchBusScreen({super.key});
  @override
  State<SearchBusScreen> createState() => _SearchBusScreenState();
}

class _SearchBusScreenState extends State<SearchBusScreen> {
  bool isChecked = false;
  int? isSelected;
  @override
  void initState() {
    super.initState();
  }

  List<Map<String, dynamic>> allDate = [
    {"name": "Boarding Points"},
    {"name": "Operators"},
    {"name": "Sindhi Camp"},
  ];

  List<Map<String, dynamic>> trainData = [
    {
      "name": "RSRTC",
      "dis": "Ganganagar Sado Road Trans.",
      "amount": "₹6,645",
      "timeFrom": "36 SEATER 2X2 NONAC Available",
      "offer": "50% off for Female Travellers",
    },
    {
      "name": "Suryavanshi Travels",
      "dis": "AC Seater (2+1)",
      "amount": "₹3,335",
      "timeFrom": "1 Single Berth (LB-1)",
      "offer": "",
    },
    {
      "name": "Suryavanshi Travels",
      "dis": "AC Sleeper (2+1)",
      "amount": "₹3,645",
      "timeFrom": "1 Single Berth (LB-1)",
      "offer": "",
    },
    {
      "name": "Pooja Yaduvanshi Travels",
      "dis": "AC Sleeper (2+1)",
      "amount": "₹3,645",
      "timeFrom": "1 Single Berth (LB-1)",
      "offer": "",
    },
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text(
                "Popular Filters",
                textColor: blackColor,
                fontSize: 18,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: allDate.length,
                  scrollDirection: Axis.horizontal,
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
                          child: text(
                            allDate[index]["name"],
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor: isSelectedColor
                                ? blue1Color
                                : blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                itemCount: trainData.length,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BusPointScreen(),
                          ),
                        );
                      },
                      child: Card(
                        color: white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  text(
                                    trainData[index]["name"],
                                    textAlign: TextAlign.center,
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 18,
                                    fontFamily: FontFamily.plusJakartaSansBold,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  text(
                                    trainData[index]["amount"],
                                    textAlign: TextAlign.center,
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 16,
                                    fontFamily: FontFamily.plusJakartaSansBold,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  text(
                                    trainData[index]["dis"],
                                    textAlign: TextAlign.center,
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 14,
                                    fontFamily:
                                        FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: yellowColor),
                                      text(
                                        "4.0",
                                        textAlign: TextAlign.center,
                                        isCentered: true,
                                        textColor: blackColor,
                                        fontSize: 14,
                                        fontFamily:
                                            FontFamily.plusJakartaSansBold,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              text(
                                trainData[index]["timeFrom"],
                                textAlign: TextAlign.center,
                                isCentered: true,
                                textColor: blackColor,
                                fontSize: 14,
                                fontFamily: FontFamily.plusJakartaSansRegular,
                                fontWeight: FontWeight.w400,
                              ),
                              SizedBox(height: 10),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  text(
                                    "22:00",
                                    textAlign: TextAlign.center,
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 16,
                                    fontFamily: FontFamily.plusJakartaSansBold,
                                    fontWeight: FontWeight.w600,
                                  ),

                                  text(
                                    "9h",
                                    textAlign: TextAlign.center,
                                    isCentered: true,
                                    textColor: greyColor,
                                    fontSize: 13,
                                    fontFamily:
                                        FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  text(
                                    "06:00",
                                    textAlign: TextAlign.center,
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 16,
                                    fontFamily: FontFamily.plusJakartaSansBold,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),

                              SizedBox(height: 10),

                              text(
                                trainData[index]["offer"],
                                textAlign: TextAlign.center,
                                isCentered: true,
                                textColor: red1Color,
                                fontSize: 13,
                                fontFamily: FontFamily.plusJakartaSansRegular,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
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
