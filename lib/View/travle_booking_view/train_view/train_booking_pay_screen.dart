import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jigrotech/View/travle_booking_view/train_view/train_book_history_screen.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/custom_textFiled.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';

class TrainBookingPayScreen extends StatefulWidget {
  const TrainBookingPayScreen({super.key});
  @override
  State<TrainBookingPayScreen> createState() => _TrainBookingPayScreenState();
}

class _TrainBookingPayScreenState extends State<TrainBookingPayScreen> {
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  String? _selectedGender;
  bool isChecked = false;
  bool isCheckedInsurance = false;
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
            children: [
              Card(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text(
                            "Boarding Station",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor: blackColor,
                            fontSize: 18,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: 5),
                          text(
                            "Boarding Details",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w600,
                          ),

                          SizedBox(height: 10),
                          text(
                            "JP - Jaipur Jn (19 Oct, 06:15)",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15),
              Card(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Select Passengers",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor: blackColor,
                            fontSize: 18,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600,
                          ),

                          text(
                            "0/6 Selected",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor: greyColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          _showAddPassengers(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [pinkColor, purpleGradientColor],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: white, size: 30),
                              SizedBox(width: 10),
                              text(
                                "Add New Passengers",
                                textAlign: TextAlign.center,
                                isCentered: true,
                                textColor: white,
                                fontSize: 16,
                                fontFamily: FontFamily.plusJakartaSansBold,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15),
              Card(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text(
                        "Contact Details",
                        textAlign: TextAlign.center,
                        isCentered: true,
                        textColor: blackColor,
                        fontSize: 18,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontWeight: FontWeight.w600,
                      ),

                      text(
                        "Your booking details will be sent here",
                        textAlign: TextAlign.center,
                        isCentered: true,
                        textColor: greyColor,
                        fontSize: 14,
                        fontFamily: FontFamily.plusJakartaSansRegular,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(height: 15),
                      CustomRoundTextField(
                        controller: mobileNumberController,

                        keyboardType: TextInputType.phone,
                        hintText: "Enter your mobile number",
                        maxLines: 2,
                        fillColor: Colors.transparent,
                        //padding: const EdgeInsets.symmetric(vertical: 2),
                        inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      ),
                      SizedBox(height: 10),
                      CustomRoundTextField(
                        controller: emailAddressController,

                        keyboardType: TextInputType.emailAddress,
                        hintText: "Enter your email address",
                        maxLines: 2,
                        fillColor: Colors.transparent,
                        //padding: const EdgeInsets.symmetric(vertical: 2),
                        inputFormatters: [LengthLimitingTextInputFormatter(20)],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Card(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Additional Preferences (Optional)",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor: blackColor,
                            fontSize: 18,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600,
                          ),

                          Icon(Icons.keyboard_arrow_down, color: greyColor),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Card(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Add GST for Tax Benefits (Optional)",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor: blackColor,
                            fontSize: 18,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600,
                          ),

                          Icon(Icons.keyboard_arrow_down, color: greyColor),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Card(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Opted Previously",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor: blackColor,
                            fontSize: 18,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600,
                          ),

                          Icon(Icons.keyboard_arrow_down, color: greyColor),
                        ],
                      ),
                      text(
                        "Free Cancellation Opted",
                        textAlign: TextAlign.center,
                        isCentered: true,
                        textColor: blackColor,
                        fontSize: 16,
                        fontFamily: FontFamily.plusJakartaSansRegular,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15),
              Card(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            value: isCheckedInsurance,
                            onChanged: (bool? value) {
                              setState(() {
                                isCheckedInsurance = value!;
                                print("hhh>>>$isCheckedInsurance");
                              });
                            },
                            activeColor: purpleGradientColor,
                            //checkColor: Colors.white,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            side: const BorderSide(
                              color: purpleGradientColor,
                              width: 1,
                            ),
                          ),

                          SizedBox(width: 10),
                          Expanded(
                            child: text(
                              "Do you want to take Travel Insurance (₹0.45/person)?",
                              textColor: greyColor,
                              fontFamily: FontFamily.plusJakartaSansRegular,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              maxLine: 3,
                            ),
                          ),
                        ],
                      ),
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
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            side: const BorderSide(
                              color: purpleGradientColor,
                              width: 1,
                            ),
                          ),

                          SizedBox(width: 10),
                          Expanded(
                            child: text(
                              "Consider for auto upgradation",
                              textColor: greyColor,
                              fontFamily: FontFamily.plusJakartaSansRegular,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              maxLine: 3,
                            ),
                          ),
                        ],
                      ),
                      text(
                        "By proceeding, you agree to our Cancellation & Refund Policy, Privacy Policy and Terms of use.",
                        textAlign: TextAlign.center,
                        isCentered: true,
                        textColor: blackColor,
                        fontSize: 13,
                        fontFamily: FontFamily.plusJakartaSansRegular,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15),
              Card(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      text(
                        "IRCTC",

                        textColor: blackColor,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        maxLine: 3,
                      ),
                      text(
                        "IRCTC authorised partner",

                        textColor: greyColor,
                        fontFamily: FontFamily.plusJakartaSansRegular,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        maxLine: 3,
                      ),
                      text(
                        "Fare may change due to dynamic pricing by the railways",
                        textAlign: TextAlign.center,
                        isCentered: true,
                        textColor: blackColor,
                        fontSize: 13,
                        fontFamily: FontFamily.plusJakartaSansRegular,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 55,
                child: CommonButton(
                  text: "Proceed to Pay",
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
                        builder: (context) => TrainBookHistoryScreen(),
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

  String? selectedNationality;

  // You can add or modify this list as per your requirement
  final List<String> nationalities = [
    'Indian',
    'American',
    'British',
    'Canadian',
    'Australian',
    'German',
    'French',
    'Chinese',
    'Japanese',
    'Other',
  ];

  String? selectedBerth;

  // Common railway berth preferences
  final List<String> berthPreferences = [
    'Lower Berth',
    'Middle Berth',
    'Upper Berth',
    'Side Lower',
    'Side Upper',
    'No Preference',
  ];
  void _showAddPassengers(context) {
    // FocusScope.of(context).unfocus();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        text(
                          "Add New Passenger",
                          textAlign: TextAlign.center,
                          isCentered: true,
                          textColor: blackColor,
                          fontSize: 20,
                          fontFamily: FontFamily.plusJakartaSansBold,
                          fontWeight: FontWeight.w600,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: blue1Color,
                            ),
                            child: Icon(Icons.close, color: white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(thickness: .5, color: greyColor),
                    SizedBox(height: 15),
                    text(
                      "Full name as per Govt. ID",
                      fontFamily: FontFamily.plusJakartaSansMedium,
                      textColor: blackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    const SizedBox(height: 10),
                    CustomRoundTextField(
                      controller: fullNameController,

                      keyboardType: TextInputType.phone,
                      hintText: "Enter your full name",
                      maxLines: 2,
                      fillColor: Colors.transparent,
                      //padding: const EdgeInsets.symmetric(vertical: 2),
                      inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    ),

                    SizedBox(height: 15),
                    text(
                      "Age",
                      fontFamily: FontFamily.plusJakartaSansMedium,
                      textColor: blackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    const SizedBox(height: 10),
                    CustomRoundTextField(
                      controller: ageController,

                      keyboardType: TextInputType.phone,
                      hintText: "Enter your Age",
                      maxLines: 2,
                      fillColor: Colors.transparent,
                      //padding: const EdgeInsets.symmetric(vertical: 2),
                      inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    ),
                    const SizedBox(height: 10),
                    text(
                      "Gender",
                      fontFamily: FontFamily.plusJakartaSansMedium,
                      textColor: blackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 20, // gap between items
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<String>(
                              value: "Male",
                              activeColor: pinkColor,
                              groupValue: _selectedGender,
                              onChanged: (value) =>
                                  setState(() => _selectedGender = value),
                            ),
                            const Text("Male"),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<String>(
                              value: "Female",
                              activeColor: pinkColor,
                              groupValue: _selectedGender,
                              onChanged: (value) =>
                                  setState(() => _selectedGender = value),
                            ),
                            const Text("Female"),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<String>(
                              value: "Other",
                              activeColor: pinkColor,
                              groupValue: _selectedGender,
                              onChanged: (value) =>
                                  setState(() => _selectedGender = value),
                            ),
                            const Text("Other"),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    text(
                      "Nationality",
                      fontFamily: FontFamily.plusJakartaSansMedium,
                      textColor: blackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedNationality,
                      decoration: InputDecoration(
                        hintText: "Nationality",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      icon: const Icon(Icons.arrow_drop_down),
                      items: nationalities.map((String nationality) {
                        return DropdownMenuItem<String>(
                          value: nationality,
                          child: Text(nationality),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedNationality = newValue;
                        });
                      },
                    ),

                    const SizedBox(height: 10),
                    text(
                      "Berth Preference",
                      fontFamily: FontFamily.plusJakartaSansMedium,
                      textColor: blackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedBerth,
                      decoration: InputDecoration(
                        hintText: "Berth Preference",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      icon: const Icon(Icons.train),
                      items: berthPreferences.map((String berth) {
                        return DropdownMenuItem<String>(
                          value: berth,
                          child: Text(berth),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedBerth = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      height: 55,
                      child: CommonButton(
                        text: "Save Passenger",
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
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => TrainBookHistoryScreen(),));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
