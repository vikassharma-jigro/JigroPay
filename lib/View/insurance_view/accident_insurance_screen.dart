import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jigrotech/View/bank_view/pin_screen.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';
import 'accident_form_screen.dart';

class AccidentInsuranceScreen extends StatefulWidget {
  const AccidentInsuranceScreen({super.key});

  @override
  State<AccidentInsuranceScreen> createState() =>
      _AccidentInsuranceScreenState();
}

class _AccidentInsuranceScreenState extends State<AccidentInsuranceScreen> {
  String? _selectValue;
  List<String> options = [
    "₹50,000",
    "₹10,000",
    "₹30,0000",
    "₹40,0000",
    "₹50,0000",
    "₹10,0000",
  ];
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
                  "Accident Insurance",
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
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: 55,
          child: CommonButton(
            text: "GET POLICY in just 2 minutes",
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
                MaterialPageRoute(builder: (context) => AccidentFormScreen()),
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
              Image.asset(AppImages.imgImage),
              SizedBox(height: 20),
              Center(
                child: text(
                  "Death due to accident",
                  textAlign: TextAlign.center,
                  isCentered: true,
                  textColor: blackColor,
                  fontSize: 18,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Center(
                child: text(
                  "Legal Heir receives the full cover amount",
                  textAlign: TextAlign.center,
                  isCentered: true,
                  textColor: greyColor,
                  fontSize: 16,
                  fontFamily: FontFamily.plusJakartaSansRegular,
                  fontWeight: FontWeight.w400,
                ),
              ),

              SizedBox(height: 15),

              text(
                "Select sum insured",
                textColor: blackColor,
                fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w400,
              ),
              //SizedBox(height: 10,),
              text(
                "Personal Accident cover for 1 year",
                textColor: greyColor,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansRegular,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 15),

              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: options.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  String item = options[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: pinkColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Radio<String>(
                                value: item,
                                activeColor: lightGreenColor,
                                groupValue: _selectValue,
                                onChanged: (value) {
                                  setState(() => _selectValue = value);
                                },
                              ),
                              text(
                                item,
                                textAlign: TextAlign.center,
                                isCentered: true,
                                textColor: blackColor,
                                fontSize: 16,
                                fontFamily: FontFamily.plusJakartaSansMedium,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 28.0),
                            child: text(
                              "₹147",
                              textAlign: TextAlign.center,
                              isCentered: true,
                              textColor: blackColor,
                              fontSize: 16,
                              fontFamily: FontFamily.plusJakartaSansMedium,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
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
