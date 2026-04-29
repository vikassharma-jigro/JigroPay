import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';
import '../../app_utils/custom_textFiled.dart';

class NcmcAccountScreen extends StatefulWidget {
  final String? ncmcServiceName;
  const NcmcAccountScreen({super.key, this.ncmcServiceName});

  @override
  State<NcmcAccountScreen> createState() => _NcmcAccountScreenState();
}

class _NcmcAccountScreenState extends State<NcmcAccountScreen> {
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
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
              widget.ncmcServiceName ?? "",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [SvgPicture.asset(AppImages.nhmcImage)],
              ),
              SizedBox(height: 10),
              text(
                "Enter the details to retrieve your account",
                textColor: blackColor,
                fontSize: 20,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),

              SizedBox(height: 15),
              text(
                "Registered Mobile Number",
                fontFamily: FontFamily.plusJakartaSansMedium,
                textColor: blackColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 10),
              CustomRoundTextField(
                controller: mobileNumberController,

                keyboardType: TextInputType.phone,
                hintText: "Enter your mobile number",
                maxLines: 2,
                fillColor: Colors.transparent,
                //padding: const EdgeInsets.symmetric(vertical: 2),
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
              ),
              SizedBox(height: 15),
              text(
                "Last 4 digits of NCMC Card Number",
                fontFamily: FontFamily.plusJakartaSansMedium,
                textColor: blackColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 10),
              CustomRoundTextField(
                controller: cardNumberController,
                keyboardType: TextInputType.phone,
                hintText: "Enter last 4 digits",
                maxLines: 2,
                fillColor: Colors.transparent,
                //padding: const EdgeInsets.symmetric(vertical: 2),
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
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
            Center(
              child: Container(
                //height: 170,
                width: 300,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                          "Payments Bank",
                          textColor: white,
                          fontFamily: FontFamily.plusJakartaSansBold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10),

                      text(
                        "Airtel Payments Bank RuPay NCMC",
                        textColor: blackColor,
                        fontFamily: FontFamily.plusJakartaSansRegular,
                        fontSize: 14,
                      ),
                      SizedBox(height: 10),
                      Divider(thickness: .5, color: greyColor),
                      SizedBox(height: 10),
                      text(
                        "NCMC Recharge",
                        textColor: blackColor,
                        fontFamily: FontFamily.plusJakartaSansMedium,
                        fontSize: 14,
                      ),
                      text(
                        "Mobile number:9911223344",
                        textColor: blackColor,
                        fontFamily: FontFamily.plusJakartaSansMedium,
                        fontSize: 14,
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
