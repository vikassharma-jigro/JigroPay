import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../app_utils/custom_textFiled.dart';
import 'package:get/get.dart';
import '../../../getx_controller/recharge_controller.dart';
class WaterRrnumberScreen extends StatefulWidget {
  final String? serviceNo;
  final String? opcode;

  const WaterRrnumberScreen({super.key, this.serviceNo, this.opcode});

  @override
  State<WaterRrnumberScreen> createState() => _WaterRrnumberScreenState();
}



class _WaterRrnumberScreenState extends State<WaterRrnumberScreen> {
  TextEditingController rrNoController = TextEditingController();
  final RechargeController rechargeController = Get.put(RechargeController());
  String? _rrError;

  String? _validateRrNo(String val) {
    if (val.trim().isEmpty) return 'RR Number is required';
    if (val.trim().length < 5) return 'Minimum 5 characters required';
    if (!RegExp(r'^[a-zA-Z0-9/-]+$').hasMatch(val.trim())) return 'Only letters, digits, / or - allowed';
    return null;
  }
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
                maxLine: 2,
                textColor: blackColor,
                fontSize: 18,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
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
                "Enter your RR Number",
                maxLine: 2,
                textColor: blackColor,
                fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansRegular,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 10),
              CustomRoundTextField(
                controller: rrNoController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                hintText: "RR Number",
                maxLines: 1,
                fillColor: Colors.transparent,
                onChanged: (val) {
                  setState(() {
                    _rrError = _validateRrNo(val);
                  });
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(20),
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9/\-]')),
                ],
              ),
              if (_rrError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 5.0),
                  child: Text(
                    _rrError!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              // SizedBox(height: 20),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Row(
              //       children: [
              //         Icon(Icons.copy),
              //         SizedBox(width: 10),
              //         text(
              //           "View Sample Bill",
              //           textColor: blackColor,
              //           fontWeight: FontWeight.w400,
              //           fontSize: 16,
              //           fontFamily: FontFamily.plusJakartaSansRegular,
              //         ),
              //       ],
              //     ),
              //     Icon(Icons.arrow_forward_ios),
              //   ],
              // ),

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
                  onPressed: () async {
                    final error = _validateRrNo(rrNoController.text);
                    setState(() { _rrError = error; });
                    if (error != null) return;

                    if (widget.opcode != null) {
                      var response = await rechargeController.fetchUtilityBill(
                        context: context, 
                        consumerId: rrNoController.text.trim(), 
                        opcode: widget.opcode!
                      );

                      if (response != null && (response['status'] == true || response['status'] == 'Success')) {
                        showDialogBox(context);
                      }
                    } else {
                      showDialogBox(context);
                    }
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
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(12),
                color: greyColor, // ✅ defined here, not inside Container
                strokeWidth: 2,
                dashPattern: [6, 3],
                child: Container(
                  height: 140,
                  width: 300,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        text(
                          "Tenement No - J8K067HB09678HB",
                          textColor: blackColor,
                          fontSize: 18,
                          textAlign: TextAlign.center,
                          isCentered: true,
                          fontFamily: FontFamily.plusJakartaSansBold,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
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
