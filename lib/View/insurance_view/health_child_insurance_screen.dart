import 'package:flutter/material.dart';

import '../../app_utils/app_colors.dart';
import '../../app_utils/font_family.dart';
import '../../app_utils/text_widget.dart';
import '../../main.dart';
import 'health_plan_insurance_screen.dart';

class HealthChildInsuranceScreen extends StatefulWidget {
  const HealthChildInsuranceScreen({super.key});

  @override
  State<HealthChildInsuranceScreen> createState() =>
      _HealthChildInsuranceScreenState();
}

class _HealthChildInsuranceScreenState
    extends State<HealthChildInsuranceScreen> {
  String? firstChildRelation;
  String? secondChildRelation;
  bool firstNominee = false;
  bool secondNominee = false;

  @override
  Widget build(BuildContext context) {
    final purple = const Color(0xFF6E2AE9);
    final borderColor = const Color(0xFFCED4DA);

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
                "Relationship",
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Relationship"),
            const SizedBox(height: 8),
            _relationSelector(
              "first",
              (val) {
                setState(() => firstChildRelation = val);
              },
              firstChildRelation,
              purple,
              borderColor,
            ),

            const SizedBox(height: 16),
            _textField("Date of Birth (DD/MM/YYYY)"),

            const SizedBox(height: 4),
            text(
              "Age should be upto 20 years",
              textColor: greyColor,
              fontFamily: FontFamily.plusJakartaSansRegular,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),

            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: firstNominee,
                  activeColor: purple,
                  onChanged: (v) => setState(() => firstNominee = v ?? false),
                ),
                Expanded(
                  child: text(
                    "Make my first child the nominee in this policy",
                    textColor: greyColor,
                    fontFamily: FontFamily.plusJakartaSansRegular,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.group, color: pinkColor, size: 20),
                const SizedBox(width: 8),
                text(
                  "Second child's details",
                  textColor: blackColor,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),

            const SizedBox(height: 12),
            _textField("Full Name"),
            const SizedBox(height: 12),
            _sectionTitle("Relationship"),
            const SizedBox(height: 8),

            _relationSelector(
              "second",
              (val) {
                setState(() => secondChildRelation = val);
              },
              secondChildRelation,
              purple,
              borderColor,
            ),

            const SizedBox(height: 16),
            _textField("Date of Birth (DD/MM/YYYY)"),

            const SizedBox(height: 4),
            text(
              "Age should be upto 20 years",
              textColor: greyColor,
              fontFamily: FontFamily.plusJakartaSansRegular,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),

            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: secondNominee,
                  activeColor: purple,
                  onChanged: (v) => setState(() => secondNominee = v ?? false),
                ),
                Expanded(
                  child: text(
                    "Make my second child the nominee in this policy",
                    textColor: greyColor,
                    fontFamily: FontFamily.plusJakartaSansRegular,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text(
                  "Premium (Incl. of GST)",
                  textColor: blackColor,
                  fontFamily: FontFamily.plusJakartaSansRegular,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                text(
                  "₹2,899/month",
                  textColor: blackColor,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),

            const SizedBox(height: 16),
            SizedBox(
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
                fontSize: 18.0,

                //padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                //borderRadius: BorderRadius.circular(40.0),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HealthPlanInsuranceScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: purple,
        child: const Icon(Icons.phone, color: Colors.white),
      ),
    );
  }

  Widget _textField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: purpleGradientColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: purpleGradientColor),
        ),
      ),
    );
  }

  Widget _relationSelector(
    String group,
    Function(String) onSelect,
    String? selected,
    Color purple,
    Color borderColor,
  ) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onSelect("Son"),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: purpleGradientColor, width: 1.5),
                color: selected == "Son"
                    ? purpleGradientColor.withOpacity(0.1)
                    : Colors.white,
              ),
              child: text(
                "Son",
                textAlign: TextAlign.center,
                isCentered: true,
                textColor: selected == "Daughter"
                    ? purpleGradientColor
                    : blackColor,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => onSelect("Daughter"),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: purpleGradientColor, width: 1.5),
                color: selected == "Daughter"
                    ? purpleGradientColor.withOpacity(0.1)
                    : Colors.white,
              ),
              child: text(
                "Daughter",
                textAlign: TextAlign.center,
                isCentered: true,
                textColor: selected == "Daughter"
                    ? purpleGradientColor
                    : blackColor,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return text(
      title,
      textAlign: TextAlign.center,
      isCentered: true,
      textColor: blackColor,
      fontSize: 16,
      fontFamily: FontFamily.plusJakartaSansBold,
      fontWeight: FontWeight.w600,
    );
  }
}
