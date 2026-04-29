import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/app_utils/app_images.dart';

import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  String? selectedDonorType;

  // List of donor options
  final List<String> donorOptions = [
    'Whole Blood Donor',
    'Platelet Donor',
    'Plasma Donor',
    'Double Red Cell Donor',
    'Organ Donor',
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
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: white),
            ),
            Expanded(
              child: text(
                "AID India",
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(AppImages.gasImage),
            SizedBox(width: 10),
            text(
              "Bharat Connect",
              textColor: purpleGradientColor,
              fontSize: 18,
              isCentered: true,
              fontFamily: FontFamily.plusJakartaSansBold,
              fontWeight: FontWeight.w600,
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
                "Enter the details to retrieve your account",
                textColor: blackColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 30),
              text(
                "Name",
                textColor: blackColor,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansMedium,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 10),

              TextField(
                controller: nameController,
                onChanged: (i) {},

                // filterSearch,
                // });
                onSubmitted: (v) {},
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: greyColor),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: greyColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: greyColor),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  // Other decoration properties...
                  filled: true,
                  fillColor: white,
                  hintText: "Name",
                  hintStyle: const TextStyle(
                    fontSize: 16.0,
                    color: greyColor,
                    fontFamily: FontFamily.plusJakartaSansRegular,
                  ),
                  contentPadding: const EdgeInsets.only(
                    top: 5,
                    left: 10,
                    bottom: 5,
                    right: 0,
                  ),
                ),
              ),
              SizedBox(height: 20),
              text(
                "Address",
                textColor: blackColor,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansMedium,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 10),

              TextField(
                controller: addressController,
                onChanged: (i) {},

                // filterSearch,
                // });
                onSubmitted: (v) {},
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: greyColor),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: greyColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: greyColor),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  // Other decoration properties...
                  filled: true,
                  fillColor: white,
                  hintText: "Address",
                  hintStyle: const TextStyle(
                    fontSize: 16.0,
                    color: greyColor,
                    fontFamily: FontFamily.plusJakartaSansRegular,
                  ),
                  contentPadding: const EdgeInsets.only(
                    top: 5,
                    left: 10,
                    bottom: 5,
                    right: 0,
                  ),
                ),
              ),

              SizedBox(height: 20),
              text(
                "Phone Number",
                textColor: blackColor,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansMedium,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 10),

              TextField(
                controller: phoneNumberController,
                keyboardType: TextInputType.number,
                onChanged: (i) {},

                // filterSearch,
                // });
                onSubmitted: (v) {},
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: greyColor),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: greyColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: greyColor),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  // Other decoration properties...
                  filled: true,
                  fillColor: white,
                  hintText: "Enter Phone Number",
                  hintStyle: const TextStyle(
                    fontSize: 16.0,
                    color: greyColor,
                    fontFamily: FontFamily.plusJakartaSansRegular,
                  ),
                  contentPadding: const EdgeInsets.only(
                    top: 5,
                    left: 10,
                    bottom: 5,
                    right: 0,
                  ),
                ),
              ),

              SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: selectedDonorType,
                decoration: InputDecoration(
                  hintText: "Select Donor Type",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: donorOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: text(
                      value,
                      textColor: blackColor,
                      fontSize: 14,
                      fontFamily: FontFamily.plusJakartaSansRegular,
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedDonorType = newValue!;
                  });
                },
              ),

              SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  showDialogBox(
                    context,
                    nameController.text,
                    phoneNumberController.text,
                    addressController.text,
                    selectedDonorType,
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: lightColor,
                    border: Border.all(color: pinkColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      text(
                        "View Sample Bill",
                        textAlign: TextAlign.center,
                        isCentered: true,
                        textColor: purpleGradientColor,
                        fontSize: 14,
                        fontFamily: FontFamily.plusJakartaSansMedium,
                        fontWeight: FontWeight.w600,
                      ),
                      Icon(Icons.arrow_forward_ios, color: purpleGradientColor),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 50),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 55,
                child: CommonButton(
                  text: "Continue",
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
                  onPressed: () {},
                ),
              ),
              SizedBox(height: 20),
              text(
                "We'll save your details for future payments. You can always go to Bills to pay your upcoming dues.",
                textAlign: TextAlign.center,
                isCentered: true,
                textColor: greyColor,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansRegular,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDialogBox(
    BuildContext context,
    String? name,
    String? phoneNumber,
    String? address,
    String? donor,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            text(
              "View Sample Bill",
              textColor: blackColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: FontFamily.plusJakartaSansBold,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.close),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Container(
                //height: 170,
                width: 300,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: blackColor,
                            ),
                            child: text(
                              "aid",
                              textColor: white,
                              fontFamily: FontFamily.plusJakartaSansBold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 15),
                          text(
                            "AID India",
                            textColor: blackColor,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontSize: 14,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(thickness: .5, color: greyColor),
                      SizedBox(height: 10),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          text(
                            "Name : ",
                            textColor: blackColor,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                            fontSize: 14,
                          ),
                          SizedBox(width: 15),
                          text(
                            name ?? "",
                            textColor: blackColor,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                            fontSize: 14,
                          ),
                        ],
                      ),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          text(
                            "Phone : ",
                            textColor: blackColor,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                            fontSize: 14,
                          ),
                          SizedBox(width: 15),
                          text(
                            name ?? "",
                            textColor: blackColor,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                            fontSize: 14,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          text(
                            "Address : ",
                            textColor: blackColor,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                            fontSize: 14,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: text(
                              address ?? "",
                              maxLine: 2,

                              textColor: blackColor,
                              fontFamily: FontFamily.plusJakartaSansMedium,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          text(
                            "Donor Type : ",
                            textColor: blackColor,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                            fontSize: 14,
                          ),
                          SizedBox(width: 15),
                          text(
                            donor ?? "",
                            textColor: blackColor,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: 55,
              child: CommonButton(
                text: "Got it",
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
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
