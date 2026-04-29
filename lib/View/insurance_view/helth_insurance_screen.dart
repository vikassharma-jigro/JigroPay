import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import 'package:flutter/gestures.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';
import 'health_child_insurance_screen.dart';

class HealthInsuranceScreen extends StatefulWidget {
  const HealthInsuranceScreen({super.key});

  @override
  State<HealthInsuranceScreen> createState() => _HealthInsuranceScreenState();
}

class _HealthInsuranceScreenState extends State<HealthInsuranceScreen> {
  String? selectedMember;
  String? selectedAgeGroup;
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: white),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(AppImages.iImage, color: white),
                    text(
                      "Jigropay",
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
                  "Insurance Broking",
                  textAlign: TextAlign.center,
                  isCentered: true,
                  textColor: lightGreyColor,
                  fontSize: 13,
                  fontFamily: FontFamily.plusJakartaSansRegular,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),

            text(
              "My Policies",
              textAlign: TextAlign.center,
              isCentered: true,
              textColor: lightGreyColor,
              fontSize: 13,
              fontFamily: FontFamily.plusJakartaSansRegular,
              fontWeight: FontWeight.w600,
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
                          "A healthcare plan like no other",
                          textAlign: TextAlign.center,
                          isCentered: true,
                          textColor: blackColor,
                          fontSize: 18,
                          fontFamily: FontFamily.plusJakartaSansBold,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),

                    text(
                      "Made with by Jigropay",
                      textAlign: TextAlign.center,
                      isCentered: true,
                      textColor: greyColor,
                      fontSize: 16,
                      fontFamily: FontFamily.plusJakartaSansRegular,
                      fontWeight: FontWeight.w400,
                    ),

                    text(
                      "Curated group health insurance",
                      textAlign: TextAlign.center,
                      isCentered: true,
                      textColor: greyColor,
                      fontSize: 16,
                      fontFamily: FontFamily.plusJakartaSansRegular,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              _sectionTitle("Whom do you want to insure?"),

              _optionButton(
                "Only me",
                Icons.person,
                selectedMember == "Only me",
                () {
                  setState(() => selectedMember = "Only me");
                },
              ),
              _optionButton(
                "Me & my spouse",
                Icons.person,
                selectedMember == "Me & my spouse",
                () {
                  setState(() => selectedMember = "Me & my spouse");
                },
              ),
              _optionButton(
                "Me, my spouse & 1 child",
                Icons.person,
                selectedMember == "Me, my spouse & 1 child",
                () {
                  setState(() => selectedMember = "Me, my spouse & 1 child");
                },
              ),
              _optionButton(
                "Me, my spouse & 2 children",
                Icons.person,
                selectedMember == "Me, my spouse & 2 children",
                () {
                  setState(() => selectedMember = "Me, my spouse & 2 children");
                },
              ),

              const SizedBox(height: 25),
              _sectionTitle("What age group do you fall into?"),

              _ageButton("18–35 years", selectedAgeGroup == "18–35 years", () {
                setState(() => selectedAgeGroup = "18–35 years");
              }),
              _ageButton("36–45 years", selectedAgeGroup == "36–45 years", () {
                setState(() => selectedAgeGroup = "36–45 years");
              }),
              _ageButton("46–55 years", selectedAgeGroup == "46–55 years", () {
                setState(() => selectedAgeGroup = "46–55 years");
              }),
              SizedBox(height: 10),
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
                    side: const BorderSide(
                      color: purpleGradientColor,
                      width: 1,
                    ),
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
              const SizedBox(height: 50),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 55,
                child: CommonButton(
                  text: "View Plans",
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
                        builder: (context) => HealthChildInsuranceScreen(),
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

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: text(
        title,
        textColor: blackColor,
        fontSize: 20,
        fontFamily: FontFamily.plusJakartaSansBold,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _optionButton(
    String text1,
    IconData icon,
    bool selected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF1E7FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF6E2AE9) : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? const Color(0xFF6E2AE9) : Colors.grey,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: text(
                text1,
                textColor: blackColor,
                fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(icon, color: const Color(0xFF6E2AE9)),
          ],
        ),
      ),
    );
  }

  Widget _ageButton(String text1, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF1E7FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF6E2AE9) : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: text(
          text1,
          textColor: blackColor,
          fontSize: 16,
          fontFamily: FontFamily.plusJakartaSansMedium,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
