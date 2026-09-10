import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../app_utils/custom_textFiled.dart';
import '../../../getx_controller/recharge_controller.dart';
import '../../app_utils/razorpay_helper.dart';

class CreditCardDetailsScreen extends StatefulWidget {
  final String? creditBankServiceName;
  final String? opcode;
  const CreditCardDetailsScreen({super.key, this.creditBankServiceName, this.opcode});

  @override
  State<CreditCardDetailsScreen> createState() =>
      _CreditCardDetailsScreenState();
}

class _CreditCardDetailsScreenState extends State<CreditCardDetailsScreen> {
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController creditCardNumberController = TextEditingController();
  final RechargeController rechargeController = Get.put(RechargeController());

  String? _mobileError;
  String? _cardError;

  String? _validateMobile(String val) {
    if (val.trim().isEmpty) return 'Mobile number is required';
    if (val.trim().length != 10 || !RegExp(r'^[0-9]{10}$').hasMatch(val.trim())) {
      return 'Valid 10-digit mobile number required';
    }
    return null;
  }

  String? _validateCard(String val) {
    if (val.trim().isEmpty) return 'Last 4 digits required';
    if (val.trim().length != 4 || !RegExp(r'^[0-9]{4}$').hasMatch(val.trim())) {
      return 'Exactly 4 digits required';
    }
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
            Expanded(
              child: text(
                widget.creditBankServiceName ?? "",
                textAlign: TextAlign.center,
                isCentered: true,
                textColor: blackColor,
                fontSize: 18,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),
            ),
            //Icon(Icons.help),

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
                "Enter the details to retrieve your account",
                textColor: blackColor,
                fontSize: 18,
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
                hintText: "Enter your Registered Mobile Number",
                maxLines: 1,
                fillColor: Colors.transparent,
                onChanged: (val) {
                  setState(() {
                    _mobileError = _validateMobile(val);
                  });
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              if (_mobileError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 5.0),
                  child: Text(
                    _mobileError!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              SizedBox(height: 15),
              text(
                "Last 4 digits of Credit Card Number",
                fontFamily: FontFamily.plusJakartaSansMedium,
                textColor: blackColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 10),
              CustomRoundTextField(
                controller: creditCardNumberController,
                keyboardType: TextInputType.number,
                hintText: "Enter Last 4 digits of Credit Card",
                maxLines: 1,
                fillColor: Colors.transparent,
                onChanged: (val) {
                  setState(() {
                    _cardError = _validateCard(val);
                  });
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(4),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              if (_cardError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 5.0),
                  child: Text(
                    _cardError!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              //SizedBox(height: 20),
              // GestureDetector(
              //   onTap: () {
              //     showBillBottomSheet(context, {
              //       'customerName': 'Sample Cardholder',
              //       'billAmount': '5000.00',
              //       'billDate': '2026-07-01',
              //       'billDueDate': '2026-07-20',
              //       'minimum_due': '500.00',
              //     });
              //   },
              //   child: Container(
              //     padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       color: lightBlueColor,
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Row(
              //           children: [
              //             Icon(Icons.copy),
              //             SizedBox(width: 10),
              //             text(
              //               "View Sample Bill",
              //               textColor: blackColor,
              //               fontWeight: FontWeight.w500,
              //               fontSize: 16,
              //               fontFamily: FontFamily.plusJakartaSansMedium,
              //             ),
              //           ],
              //         ),
              //         Icon(Icons.arrow_forward_ios),
              //       ],
              //     ),
              //   ),
              // ),

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
                    final mErr = _validateMobile(mobileNumberController.text);
                    final cErr = _validateCard(creditCardNumberController.text);

                    setState(() {
                      _mobileError = mErr;
                      _cardError = cErr;
                    });

                    if (mErr != null || cErr != null) return;

                    String mobile = mobileNumberController.text.trim();
                    String card = creditCardNumberController.text.trim();
                    String opcode = widget.opcode ?? "KKBK";

                    var response = await rechargeController.fetchCreditCardBill(
                      context: context,
                      card: card,
                      opcode: opcode,
                      mobile: mobile,
                    );

                    if (response != null && (response['status'] == true || response['status'] == 'Success')) {
                      showBillBottomSheet(context, response);
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

  void showBillBottomSheet(BuildContext context, Map<String, dynamic> data) {
    String customerName = data['customerName']?.toString() ??
        data['data']?['customerName']?.toString() ??
        data['name']?.toString() ??
        'Cardholder';
    String billAmount = data['billAmount']?.toString() ??
        data['data']?['billAmount']?.toString() ??
        data['amount']?.toString() ??
        '0';
    String billDate = data['billDate']?.toString() ?? data['data']?['billDate']?.toString() ?? '';
    String billDueDate = data['billDueDate']?.toString() ?? data['data']?['billDueDate']?.toString() ?? '';
    String minimumDue = data['minimum_due']?.toString() ?? data['data']?['minimum_due']?.toString() ?? '0';
    String fetchId = data['fetch_id']?.toString() ??
        data['data']?['fetch_id']?.toString() ??
        data['id']?.toString() ??
        data['data']?['id']?.toString() ??
        '';

    TextEditingController customAmountController = TextEditingController(text: billAmount);
    TextEditingController panController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (sheetCtx, setModalState) {
            double currentPayAmount = double.tryParse(customAmountController.text.trim()) ?? 0.0;
            bool isPanRequired = currentPayAmount >= 50000;

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 15,
                bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 25,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: greyColor.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: text(
                            widget.creditBankServiceName ?? "Credit Card Bill",
                            textColor: blackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: FontFamily.plusJakartaSansBold,
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(sheetCtx),
                          child: const Icon(Icons.close, color: blackColor),
                        ),
                      ],
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
                            "Cardholder Name",
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
                            "Fetched Bill Amount",
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
                          _buildRowDetail("Bill Date", billDate),
                          const Divider(height: 16, thickness: 0.5),
                          _buildRowDetail("Bill Due Date", billDueDate),
                          const Divider(height: 16, thickness: 0.5),
                          _buildRowDetail("Minimum Due", "₹ $minimumDue"),
                          const Divider(height: 16, thickness: 0.5),
                          _buildRowDetail("Mobile Number", mobileNumberController.text),
                          const Divider(height: 16, thickness: 0.5),
                          _buildRowDetail("Card Ending With", "**** ${creditCardNumberController.text}"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Custom Amount Field
                    text(
                      "Payment Amount",
                      fontFamily: FontFamily.plusJakartaSansMedium,
                      textColor: blackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 8),
                    CustomRoundTextField(
                      controller: customAmountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      hintText: "Enter Custom Amount",
                      maxLines: 1,

                      fillColor: Colors.transparent,
                      prefixIcon: Container(
                        width: 10,
                        alignment: Alignment.center,
                        child: const Text(
                          "₹",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: blackColor,
                          ),
                        ),
                      ),
                      onChanged: (val) {
                        setModalState(() {});
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(7),
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // PAN Card Field
                    text(
                      isPanRequired ? "PAN Card Number (Required for ≥ ₹50,000)" : "PAN Card Number (Optional)",
                      fontFamily: FontFamily.plusJakartaSansMedium,
                      textColor: isPanRequired ? Colors.red.shade700 : blackColor,
                      fontSize: 14,
                      fontWeight: isPanRequired ? FontWeight.w600 : FontWeight.w500,
                    ),
                    const SizedBox(height: 8),
                    CustomRoundTextField(
                      controller: panController,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                      hintText: isPanRequired ? "Enter 10-character PAN (Required)" : "Enter 10-character PAN",
                      maxLines: 1,
                      fillColor: Colors.transparent,
                      onChanged: (val) {
                        setModalState(() {});
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                      ],
                    ),
                    if (isPanRequired)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 8.0, left: 4.0),
                        child: Text(
                          "⚠️ PAN Card number is mandatory for bill payments of ₹50,000 or above.",
                          style: TextStyle(color: Colors.red.shade700, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: CommonButton(
                        text: "Pay ₹ ${customAmountController.text.trim().isNotEmpty ? customAmountController.text.trim() : billAmount}",
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
                          double payAmount = double.tryParse(customAmountController.text.trim()) ?? 0.0;
                          if (payAmount <= 0) {
                            Fluttertoast.showToast(
                              msg: "Please enter a valid payment amount",
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                            );
                            return;
                          }

                          String panVal = panController.text.trim().toUpperCase();
                          if (payAmount >= 50000) {
                            if (panVal.isEmpty || panVal.length != 10) {
                              Fluttertoast.showToast(
                                msg: "Valid 10-character PAN Card number is required for payments of ₹50,000 or above",
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                              return;
                            }
                          }

                          Navigator.pop(sheetCtx);

                          RazorpayHelper(context: context, type: "cc_bill_pay").startPaymentWithOrderFlow(
                            context: context,
                            opcode: widget.opcode ?? "cc_bill_pay",
                            number: mobileNumberController.text.trim(),
                            amount: payAmount,
                            type: "cc_bill_pay",
                            fetchId: fetchId,
                            pan: panVal,
                            card: creditCardNumberController.text.trim(),
                            description: "Credit Card Bill Payment",
                            serviceName: widget.creditBankServiceName ?? "Credit Card Bill",
                            providerName: widget.creditBankServiceName ?? "Credit Card Provider",
                            billMonth: billDate.isNotEmpty && billDate != '-' ? billDate : null,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: FontFamily.plusJakartaSansMedium,
        ),
      ],
    );
  }
}
