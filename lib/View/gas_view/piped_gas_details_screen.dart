import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../app_utils/custom_textFiled.dart';
import 'package:get/get.dart';
import '../../../getx_controller/recharge_controller.dart';

class PipedGasDetailsScreen extends StatefulWidget {
  final String? pipedServiceName;
  final String? opcode;
  const PipedGasDetailsScreen({super.key, this.pipedServiceName, this.opcode});

  @override
  State<PipedGasDetailsScreen> createState() => _PipedGasDetailsScreenState();
}



class _PipedGasDetailsScreenState extends State<PipedGasDetailsScreen> {
  TextEditingController caCardNumberController = TextEditingController();
  final RechargeController rechargeController = Get.put(RechargeController());
  String? _caError;

  String? _validateCaNo(String val) {
    if (val.trim().isEmpty) return 'CA Number is required';
    if (val.trim().length < 5) return 'Minimum 5 characters required';
    if (!RegExp(r'^[a-zA-Z0-9/-]+$').hasMatch(val.trim())) return 'Only letters, digits, / or - allowed';
    return null;
  }

  dynamic date;
  bool isChecked = false;
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
              widget.pipedServiceName ?? "",
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
              SizedBox(height: 10),
              text(
                "Enter your CA Number to retrieve your account details.",
                textColor: blackColor,
                fontSize: 18,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),

              SizedBox(height: 15),
              text(
                "CA Number",
                fontFamily: FontFamily.plusJakartaSansMedium,
                textColor: blackColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 10),
              CustomRoundTextField(
                controller: caCardNumberController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                hintText: "Enter your CA Number",
                maxLines: 1,
                fillColor: Colors.transparent,
                onChanged: (val) {
                  setState(() {
                    _caError = _validateCaNo(val);
                  });
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(20),
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9/\-]')),
                ],
              ),
              if (_caError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 5.0),
                  child: Text(
                    _caError!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
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
                    final error = _validateCaNo(caCardNumberController.text);
                    setState(() { _caError = error; });
                    if (error != null) return;

                    if (widget.opcode != null) {
                      var response = await rechargeController.fetchUtilityBill(
                        context: context, 
                        consumerId: caCardNumberController.text.trim(), 
                        opcode: widget.opcode!
                      );
                      
                      if (response != null && (response['status'] == true || response['status'] == 'Success')) {
                        // show success dialog or navigation
                      }
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
}
