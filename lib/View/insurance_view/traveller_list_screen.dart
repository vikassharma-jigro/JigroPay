import 'package:flutter/material.dart';
import 'package:jigrotech/View/insurance_view/travel_medical_history_screen.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';

class TravellerListScreen extends StatefulWidget {
  const TravellerListScreen({super.key});

  @override
  State<TravellerListScreen> createState() => _TravellerListScreenState();
}

class _TravellerListScreenState extends State<TravellerListScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> travellingList = [
    {"name": "Vikash Sharma", "dob": "07/10/1997"},
    {"name": "Jitender", "dob": "07/10/1997"},
    {"name": "Ashok", "dob": "07/10/1997"},
    {"name": "Rocky", "dob": "07/10/1997"},
  ];
  List<bool> isCheckedList = [];

  @override
  void initState() {
    isCheckedList = List.generate(
      travellingList.length,
      (_) => false,
    ); // initially show all
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
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
                "List of Travellers",
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
              text(
                "Select traveller",
                textAlign: TextAlign.center,
                isCentered: true,
                textColor: blackColor,
                fontSize: 18,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 15),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: travellingList.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          // border: Border.all(color:greyColor)
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: isCheckedList[index],
                                  onChanged: (value) {
                                    setState(() {
                                      isCheckedList[index] = value!;
                                    });
                                  },
                                  activeColor:
                                      purpleGradientColor, // customize color if you want
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    text(
                                      travellingList[index]["name"],
                                      maxLine: 2,
                                      textColor: blackColor,
                                      fontSize: 13,
                                      fontFamily:
                                          FontFamily.plusJakartaSansMedium,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    text(
                                      travellingList[index]["dob"],
                                      maxLine: 2,
                                      textColor: blackColor,
                                      fontSize: 13,
                                      fontFamily:
                                          FontFamily.plusJakartaSansMedium,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 50),
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
                        builder: (context) => TravelMedicalHistoryScreen(),
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
