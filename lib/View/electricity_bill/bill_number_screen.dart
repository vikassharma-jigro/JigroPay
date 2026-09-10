import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jigrotech/View/bank_view/pin_screen.dart';
import 'package:get/get.dart';
import '../../../getx_controller/recharge_controller.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../app_utils/razorpay_helper.dart';
import '../../../api_services/api_base_helper.dart';
import '../../../main.dart';
import '../../app_utils/app_images.dart';

class BillNumberScreen extends StatefulWidget {
  final String? billServiceName;
  final String? opcode;
  const BillNumberScreen({super.key, this.billServiceName, this.opcode});

  @override
  State<BillNumberScreen> createState() => _BillNumberScreenState();
}



class _BillNumberScreenState extends State<BillNumberScreen> {
  TextEditingController billNumberController = TextEditingController();
  final RechargeController rechargeController = Get.put(RechargeController());
  String? _billError;

  String? _validateBillNo(String val) {
    if (val.trim().isEmpty) return 'Bill number is required';
    if (val.trim().length < 6) return 'Minimum 6 characters required';
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
                "Pay Bill",
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

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: text(
                  widget.billServiceName??"",
                  textAlign: TextAlign.center,
                  isCentered: true,
                  textColor: blackColor,
                  fontSize: 14,
                  fontFamily: FontFamily.plusJakartaSansRegular,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              text(
                "Enter K Number",
                textAlign: TextAlign.center,
                isCentered: true,
                textColor: blackColor,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansRegular,
                fontWeight: FontWeight.w600,
              ),

              SizedBox(height: 10),
              TextField(
                controller: billNumberController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(20),
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9/\-]')),
                ],
                onChanged: (val) {
                  setState(() {
                    _billError = _validateBillNo(val);
                  });
                },
                onSubmitted: (v) {},
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _billError != null ? Colors.red : primaryColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _billError != null ? Colors.red : primaryColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: _billError != null ? Colors.red : primaryColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  errorText: _billError,
                  filled: true,
                  fillColor: white,
                  hintText: "e.g. AB123456",
                  counterText: '${billNumberController.text.length}/20',
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


              const SizedBox(height: 50),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 55,
                child: CommonButton(
                  text: "Next ",
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
                    final error = _validateBillNo(billNumberController.text);
                    setState(() { _billError = error; });
                    if (error != null) return;

                    String consumerId = billNumberController.text.trim();
                    if (widget.opcode != null) {
                      var response = await rechargeController.fetchUtilityBill(
                        context: context, 
                        consumerId: consumerId, 
                        opcode: widget.opcode!
                      );

                      if (response != null && (response['status'] == true || response['status'] == 'Success')) {
                        _showBillDetailsModal(context, response, consumerId);
                      } else {
                        String apiMsg = cleanApiMessage(response);
                        if (apiMsg.isEmpty) apiMsg = "Failed to fetch bill details";
                        Fluttertoast.showToast(
                          msg: apiMsg,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    } else {
                      RazorpayHelper(context: context).startPaymentWithOrderFlow(
                        context: context,
                        opcode: widget.opcode ?? "ELECTRICITY",
                        number: consumerId.isNotEmpty ? consumerId : "CONSUMER",
                        amount: 100.0,
                        description: "Electricity Bill Payment",
                        serviceName: widget.billServiceName ?? "Electricity Bill",
                        providerName: widget.billServiceName ?? "Electricity Provider",
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBillDetailsModal(BuildContext context, Map<String, dynamic> response, String consumerId) {
    Map<String, dynamic> billData = {};
    if (response['data'] != null) {
      if (response['data'] is List && (response['data'] as List).isNotEmpty) {
        billData = Map<String, dynamic>.from(response['data'][0]);
      } else if (response['data'] is Map) {
        billData = Map<String, dynamic>.from(response['data']);
      }
    } else {
      billData = response;
    }

    Map<String, dynamic> additionalDetails = {};
    if (billData['additionalDetails'] is Map) {
      additionalDetails = Map<String, dynamic>.from(billData['additionalDetails']);
    }

    String customerName = billData['userName']?.toString() ??
        additionalDetails['Customer Name']?.toString() ??
        billData['customer_name']?.toString() ??
        "Customer";
    String billAmount = billData['billAmount']?.toString() ??
        billData['billnetamount']?.toString() ??
        billData['amount']?.toString() ??
        "0";
    String billDate = billData['billdate']?.toString() ??
        billData['bill_date']?.toString() ??
        "-";
    String dueDate = billData['dueDate']?.toString() ??
        billData['due_date']?.toString() ??
        "-";
    String kNumber = billData['cellNumber']?.toString() ??
        additionalDetails['K Number']?.toString() ??
        consumerId;
    String billNumber = additionalDetails['billNumber']?.toString() ??
        billData['billNumber']?.toString() ??
        "-";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 25,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: text(
                  "${widget.billServiceName ?? 'Electricity'} Bill Details",
                  textColor: blackColor,
                  fontSize: 18,
                  fontFamily: FontFamily.plusJakartaSansBold,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: lightBlueColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: primaryColor.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text(
                      "Customer Name",
                      textColor: greyColor,
                      fontSize: 12,
                      fontFamily: FontFamily.plusJakartaSansRegular,
                    ),
                    text(
                      customerName,
                      textColor: blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.plusJakartaSansBold,
                    ),
                    const SizedBox(height: 12),
                    text(
                      "Bill Amount",
                      textColor: greyColor,
                      fontSize: 12,
                      fontFamily: FontFamily.plusJakartaSansRegular,
                    ),
                    text(
                      "₹ $billAmount",
                      textColor: primaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      fontFamily: FontFamily.plusJakartaSansBold,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: greyColor.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    _buildRowDetail("Consumer / K Number", kNumber),
                    if (billNumber != "-") ...[
                      const Divider(height: 16, thickness: 0.5),
                      _buildRowDetail("Bill Number", billNumber),
                    ],
                    const Divider(height: 16, thickness: 0.5),
                    _buildRowDetail("Bill Date", billDate),
                    const Divider(height: 16, thickness: 0.5),
                    _buildRowDetail("Due Date", dueDate),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: CommonButton(
                  text: "Proceed to Pay ₹ $billAmount",
                  textColor: white,
                  gradient: const LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  fontWeight: FontWeight.w600,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontSize: 16.0,
                  onPressed: () {
                    Navigator.pop(ctx);
                    double amount = double.tryParse(billAmount) ?? 100.0;
                    RazorpayHelper(context: context).startPaymentWithOrderFlow(
                      context: context,
                      opcode: widget.opcode ?? "ELECTRICITY",
                      number: kNumber,
                      amount: amount,
                      description: "Electricity Bill Payment",
                      serviceName: widget.billServiceName ?? "Electricity Bill",
                      providerName: widget.billServiceName ?? "Electricity Provider",
                      billMonth: billDate.isNotEmpty && billDate != '-' ? billDate : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRowDetail(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        text(
          title,
          textColor: greyColor,
          fontSize: 13,
          fontFamily: FontFamily.plusJakartaSansRegular,
        ),
        text(
          value.isNotEmpty ? value : "-",
          textColor: blackColor,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          fontFamily: FontFamily.plusJakartaSansBold,
        ),
      ],
    );
  }
}
