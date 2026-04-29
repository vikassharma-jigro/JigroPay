import 'package:flutter/material.dart';
import 'package:jigrotech/View/insurance_view/travel_buy_screen.dart';
import 'package:jigrotech/View/insurance_view/travel_calender_screen.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';

class TravelMedicalHistoryScreen extends StatefulWidget {
  const TravelMedicalHistoryScreen({super.key});

  @override
  State<TravelMedicalHistoryScreen> createState() =>
      _TravelMedicalHistoryScreenState();
}

class _TravelMedicalHistoryScreenState
    extends State<TravelMedicalHistoryScreen> {
  String? selectedOption;

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
                "Group Silver Cover",
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
                "Medical History",
                textAlign: TextAlign.center,
                isCentered: true,
                textColor: blackColor,
                fontSize: 18,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),

              text(
                "Do any of the travellers have any pre-existing diseases like diabetes, hypertension, heart disease, etc. or are unfit for travel?",
                textColor: blackColor,
                fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansRegular,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 15),
              Column(
                children: [
                  RadioListTile<String>(
                    title: const Text("Yes"),
                    value: "Yes",
                    groupValue: selectedOption,
                    activeColor: Colors.deepPurple,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text("No"),
                    value: "No",
                    groupValue: selectedOption,
                    activeColor: Colors.deepPurple,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 50),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 55,
                child: CommonButton(
                  text: "CONTINUE",
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
                        builder: (context) => TravelBuyScreen(),
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
