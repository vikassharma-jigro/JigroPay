import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/custom_dialog_widget.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';
import '../../app_utils/custom_textFiled.dart';

class LandlineDetailsScreen extends StatefulWidget {
  final String? serviceNo;

  const LandlineDetailsScreen({super.key, this.serviceNo});

  @override
  State<LandlineDetailsScreen> createState() => _LandlineDetailsScreenState();
}

class _LandlineDetailsScreenState extends State<LandlineDetailsScreen> {
  TextEditingController mobileNumberController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: blackColor),
            ),
            text(
              widget.serviceNo ?? "",
              textAlign: TextAlign.center,
              isCentered: true,
              textColor: blackColor,
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
              CustomRoundTextField(
                controller: mobileNumberController,
                keyboardType: TextInputType.phone,
                hintText: "Telephone Number",
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
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
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
    showCustomAppDialog(
      context,
      type: CustomDialogType.info,
      title: "View Sample Bill",
      primaryButtonText: "Got it",
      customContent: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        color: greyColor,
        strokeWidth: 2,
        dashPattern: const [6, 3],
        child: Container(
          height: 150,
          width: 280,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              text(
                "BSNL",
                textColor: red1Color,
                fontSize: 18,
                textAlign: TextAlign.center,
                isCentered: true,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),
              text(
                "Connecting India",
                textColor: blueColor,
                fontSize: 14,
                textAlign: TextAlign.center,
                isCentered: true,
                fontFamily: FontFamily.plusJakartaSansMedium,
              ),
              const SizedBox(height: 10),
              text(
                "Telephone Number: 08022334455",
                textColor: blackColor,
                fontSize: 14,
                textAlign: TextAlign.center,
                isCentered: true,
                fontFamily: FontFamily.plusJakartaSansMedium,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
