import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/custom_dialog_widget.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';
import '../../app_utils/custom_textFiled.dart';

class MutualRegistrationScreen extends StatefulWidget {
  final String? serviceNo;

  const MutualRegistrationScreen({super.key, this.serviceNo});

  @override
  State<MutualRegistrationScreen> createState() =>
      _MutualRegistrationScreenState();
}

class _MutualRegistrationScreenState extends State<MutualRegistrationScreen> {
  TextEditingController registrationNoController = TextEditingController();

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
            Expanded(
              child: text(
                widget.serviceNo ?? "",
                textAlign: TextAlign.center,
                isCentered: true,
                textColor: blackColor,
                fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),
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
                controller: registrationNoController,
                keyboardType: TextInputType.phone,
                hintText: "Unique Registration No.",
                maxLines: 2,
                fillColor: Colors.transparent,
                //padding: const EdgeInsets.symmetric(vertical: 2),
                inputFormatters: [LengthLimitingTextInputFormatter(20)],
              ),

              SizedBox(height: 20),
              Row(
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

              const SizedBox(height: 150),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 55,
                child: CommonButton(
                  text: "Continue",
                  textColor: white,
                  gradient: const LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  fontWeight: FontWeight.w600,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontSize: 16.0,

                  //padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  //borderRadius: BorderRadius.circular(40.0),
                  onPressed: () {
                    showDialogBox(context);
                  },
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
          height: 120,
          width: 280,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: text(
            "Tenement No - J8K067HB09678HB",
            textColor: blackColor,
            fontSize: 16,
            textAlign: TextAlign.center,
            isCentered: true,
            fontFamily: FontFamily.plusJakartaSansBold,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
