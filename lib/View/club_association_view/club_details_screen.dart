import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';
import '../../app_utils/custom_textFiled.dart';

class ClubDetailsScreen extends StatefulWidget {
  final String? clubServiceName;
  const ClubDetailsScreen({super.key, this.clubServiceName});

  @override
  State<ClubDetailsScreen> createState() => _ClubDetailsScreenState();
}

class _ClubDetailsScreenState extends State<ClubDetailsScreen> {
  TextEditingController memberShipController = TextEditingController();
  TextEditingController bankingNameController = TextEditingController();

  dynamic date;
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
            text(
              widget.clubServiceName ?? "",
              textAlign: TextAlign.center,
              isCentered: true,
              textColor: white,
              fontSize: 18,
              fontFamily: FontFamily.plusJakartaSansBold,
              fontWeight: FontWeight.w600,
            ),
            Icon(Icons.help),

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
              SizedBox(height: 10),
              text(
                "Enter your Membership No to retrieve your account details",
                textColor: blackColor,
                fontSize: 18,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),

              SizedBox(height: 15),
              text(
                "Membership No",
                fontFamily: FontFamily.plusJakartaSansMedium,
                textColor: blackColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 10),
              CustomRoundTextField(
                controller: memberShipController,

                keyboardType: TextInputType.phone,
                hintText: "Enter your Membership No ",
                maxLines: 2,
                fillColor: Colors.transparent,
                //padding: const EdgeInsets.symmetric(vertical: 2),
                inputFormatters: [LengthLimitingTextInputFormatter(12)],
              ),
              SizedBox(height: 15),
              text(
                "Banking name",
                fontFamily: FontFamily.plusJakartaSansMedium,
                textColor: blackColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 10),
              CustomRoundTextField(
                controller: bankingNameController,
                hintText: "Enter your Banking name",
                maxLines: 2,
                fillColor: Colors.transparent,
                //padding: const EdgeInsets.symmetric(vertical: 2),
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
              ),
              SizedBox(height: 15),
              text(
                "Add a message (optional)",
                fontFamily: FontFamily.plusJakartaSansMedium,
                textColor: blackColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 10),
              CustomRoundTextField(
                controller: bankingNameController,
                hintText: "Enter your Add a message (optional)",
                maxLines: 2,
                fillColor: Colors.transparent,
                //padding: const EdgeInsets.symmetric(vertical: 2),
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
              ),

              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  showDialogBox(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: lightBlueColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.copy),
                          SizedBox(width: 10),
                          text(
                            "View Sample Bill",
                            textColor: blackColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 50),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 55,
                child: CommonButton(
                  text: "Proceed To Pay",
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
                textColor: greyColor,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansRegular,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDialogBox(BuildContext context) {
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
          children: [
            Container(
              //height: 170,
              width: 300,
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: red1Color,
                      ),
                      child: text(
                        "AL Ashraf Trust",
                        textColor: white,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 10),

                    text(
                      "Clubs and Associations",
                      textColor: blackColor,
                      fontFamily: FontFamily.plusJakartaSansRegular,
                      fontSize: 14,
                    ),
                    SizedBox(height: 10),
                    Divider(thickness: .5, color: greyColor),
                    text(
                      "Membership No : ALat223344",
                      textColor: blackColor,
                      fontFamily: FontFamily.plusJakartaSansMedium,
                      fontSize: 13,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: 55,
              child: CommonButton(
                text: "Close",
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
