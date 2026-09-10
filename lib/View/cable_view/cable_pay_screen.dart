import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jigrotech/View/cable_view/cable_amount_screen.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import 'package:get/get.dart';
import '../../../getx_controller/recharge_controller.dart';

class CablePayScreen extends StatefulWidget {
  final String? cableServiceName;
  final String? opcode;
  const CablePayScreen({super.key, this.cableServiceName, this.opcode});

  @override
  State<CablePayScreen> createState() => _CablePayScreenState();
}



class _CablePayScreenState extends State<CablePayScreen> {
  TextEditingController customerIdController = TextEditingController();
  final RechargeController rechargeController = Get.put(RechargeController());
  String? _customerError;

  String? _validateCustomerId(String val) {
    if (val.trim().isEmpty) return 'Customer ID is required';
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
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: blackColor),
            ),
            Expanded(
              child: text(
                widget.cableServiceName ?? "",
                textAlign: TextAlign.center,
                isCentered: true,
                textColor: blackColor,
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: text(
                "We'll save your details for future payments. You can always go to Bills to pay your upcoming dues.",
                isCentered: true,
                fontSize: 14,
                textColor: greyColor,
                fontWeight: FontWeight.w400,
                fontFamily: FontFamily.plusJakartaSansRegular,
              ),
            ),
            SizedBox(height: 15),
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
                  final error = _validateCustomerId(customerIdController.text);
                  setState(() { _customerError = error; });
                  if (error != null) return;

                  if (widget.opcode != null) {
                    var response = await rechargeController.fetchUtilityBill(
                      context: context, 
                      consumerId: customerIdController.text.trim(), 
                      opcode: widget.opcode!
                    );

                    if (response != null && (response['status'] == true || response['status'] == 'Success')) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CableAmountScreen(
                            cableServiceName: widget.cableServiceName,
                            opcode: widget.opcode,
                            consumerNumber: customerIdController.text.trim(),
                          ),
                        ),
                      );
                    }
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CableAmountScreen(
                          cableServiceName: widget.cableServiceName,
                          opcode: widget.opcode,
                          consumerNumber: customerIdController.text.trim(),
                        ),
                      ),
                    );
                  }
                },
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
                "Enter your Card No to retrieve your account details.",
                textColor: blackColor,
                fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansRegular,
                fontWeight: FontWeight.w400,
              ),

              SizedBox(height: 30),
              text(
                "Customer Id",
                textColor: blackColor,
                fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansMedium,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 10),
              TextField(
                controller: customerIdController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(20),
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9/\-]')),
                ],
                onChanged: (val) {
                  setState(() {
                    _customerError = _validateCustomerId(val);
                  });
                },
                onSubmitted: (v) {},
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _customerError != null ? Colors.red : primaryColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _customerError != null ? Colors.red : primaryColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: _customerError != null ? Colors.red : primaryColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  errorText: _customerError,
                  filled: true,
                  fillColor: white,
                  hintText: "Enter Customer Id",
                  counterText: '${customerIdController.text.length}/20',
                  hintStyle: const TextStyle(
                    fontSize: 16.0,
                    color: greyColor,
                    fontFamily: FontFamily.plusJakartaSansRegular,
                  ),
                  contentPadding: const EdgeInsets.only(
                    top: 5,
                    left: 10,
                    bottom: 5,
                    right: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
