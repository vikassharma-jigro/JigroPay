import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/font_family.dart';
import '../../app_utils/text_widget.dart';
import 'package:get/get.dart';
import '../../../getx_controller/recharge_controller.dart';
import '../../api_services/api_base_helper.dart';
import '../../app_utils/razorpay_helper.dart';


class GenericServiceFormScreen extends StatefulWidget {
  final String title;
  final String? opcode;
  const GenericServiceFormScreen({super.key, required this.title, this.opcode});

  @override
  State<GenericServiceFormScreen> createState() => _GenericServiceFormScreenState();
}


class _GenericServiceFormScreenState extends State<GenericServiceFormScreen> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String> _dropdownValues = {};
  final RechargeController rechargeController = Get.put(RechargeController());
  
  List<Map<String, dynamic>> _getFormFields() {
    switch (widget.title) {
      case "Mobile Recharge":
        return [
          {"label": "Mobile Number", "type": "phone", "hint": "Enter mobile number"},
          {"label": "Operator", "type": "dropdown", "hint": "Select operator"},
          {"label": "Amount", "type": "number", "hint": "Enter amount"},
        ];
      case "Postpaid Bill":
        return [
          {"label": "Mobile Number", "type": "phone", "hint": "Enter mobile number"},
          {"label": "Operator", "type": "dropdown", "hint": "Select operator"},
          {"label": "Amount", "type": "number", "hint": "Enter amount"},
        ];
      case "Broadband Bill":
        return [
          {"label": "User ID / Account No", "type": "text", "hint": "Enter account number"},
          {"label": "Operator", "type": "dropdown", "hint": "Select operator"},
          {"label": "Amount", "type": "number", "hint": "Enter amount"},
        ];
      case "Landline Postpaid":
        return [
          {"label": "Telephone Number (with STD Code)", "type": "phone", "hint": "Enter telephone number"},
          {"label": "Operator", "type": "dropdown", "hint": "Select operator"},
          {"label": "Amount", "type": "number", "hint": "Enter amount"},
        ];
      case "Water Bill":
        return [
          {"label": "Connection Number / RR No", "type": "text", "hint": "Enter connection number"},
          {"label": "Water Board", "type": "dropdown", "hint": "Select water board"},
          {"label": "Amount", "type": "number", "hint": "Enter amount"},
        ];
      case "Cable TV":
        return [
          {"label": "Subscriber ID", "type": "text", "hint": "Enter subscriber ID"},
          {"label": "Cable Provider", "type": "dropdown", "hint": "Select provider"},
          {"label": "Amount", "type": "number", "hint": "Enter amount"},
        ];
      case "Credit Card":
        return [
          {"label": "Credit Card Number", "type": "number", "hint": "Enter card number"},
          {"label": "Card Holder Name", "type": "text", "hint": "Enter name on card"},
          {"label": "Bank Name", "type": "dropdown", "hint": "Select bank"},
          {"label": "Amount", "type": "number", "hint": "Enter amount"},
        ];
      case "Loan Repayment":
        return [
          {"label": "Loan Account Number", "type": "text", "hint": "Enter loan account number"},
          {"label": "Bank / NBFC", "type": "dropdown", "hint": "Select bank/NBFC"},
          {"label": "Amount", "type": "number", "hint": "Enter amount"},
        ];
      case "Insurance":
        return [
          {"label": "Policy Number", "type": "text", "hint": "Enter policy number"},
          {"label": "Insurer Name", "type": "dropdown", "hint": "Select insurer"},
          {"label": "Amount", "type": "number", "hint": "Enter amount"},
        ];
      case "Municipal Taxes":
        return [
          {"label": "Property ID", "type": "text", "hint": "Enter property ID"},
          {"label": "Municipality", "type": "dropdown", "hint": "Select municipality"},
          {"label": "Amount", "type": "number", "hint": "Enter amount"},
        ];
      case "PAN Services":
        return [
          {"label": "Mobile Number", "type": "phone", "hint": "Enter mobile number"},
        ];
      case "Digital Voucher":
        return [
          {"label": "Brand", "type": "dropdown", "hint": "Select brand"},
          {"label": "Voucher Value", "type": "dropdown", "hint": "Select value"},
          {"label": "Quantity", "type": "number", "hint": "Enter quantity"},
        ];
      case "Donation":
        return [
          {"label": "NGO/Charity Name", "type": "dropdown", "hint": "Select NGO"},
          {"label": "Donor Name", "type": "text", "hint": "Enter your name"},
          {"label": "PAN Number", "type": "text", "hint": "Enter PAN (Optional)"},
          {"label": "Amount", "type": "number", "hint": "Enter amount"},
        ];
      default:
        return [
          {"label": "Customer ID", "type": "text", "hint": "Enter ID"},
          {"label": "Amount", "type": "number", "hint": "Enter amount"},
        ];
    }
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
                  "${widget.title} Bill Details",
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
                        opcode: widget.opcode ?? "SERVICE_PAY",
                        number: kNumber.isNotEmpty ? kNumber : "CUSTOMER",
                        amount: amount,
                        description: "${widget.title} Payment",
                        serviceName: widget.title,
                        providerName: widget.title,
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

  @override
  Widget build(BuildContext context) {
    final fields = _getFormFields();
    
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back_ios, color: blackColor),
            ),
            Expanded(
              child: text(
                widget.title,
                textAlign: TextAlign.center,
                isCentered: true,
                textColor: blackColor,
                fontSize: 18,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 24),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            text(
              "Enter Details",
              textColor: blackColor,
              fontSize: 20,
              fontFamily: FontFamily.plusJakartaSansBold,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 5),
            text(
              "Please fill the form below for ${widget.title}",
              textColor: greyColor,
              fontSize: 14,
              fontFamily: FontFamily.plusJakartaSansRegular,
            ),
            SizedBox(height: 20),
            ...fields.map((field) {
              String label = field["label"];
              _controllers.putIfAbsent(label, () => TextEditingController());
              
              if (field["type"] == "dropdown") {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text(
                        label,
                        textColor: blackColor,
                        fontSize: 14,
                        fontFamily: FontFamily.plusJakartaSansMedium,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: greyColor.withOpacity(0.5)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: text(field["hint"], textColor: greyColor, fontSize: 14, fontFamily: FontFamily.plusJakartaSansRegular),
                            value: _dropdownValues[label],
                            items: (field["options"] as List<String>? ?? ["Option 1", "Option 2", "Option 3"]).map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _dropdownValues[label] = val!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              bool isDate = field["type"] == "date" || label.contains("Date of Birth") || label.contains("DOB");
              bool isPhone = field["type"] == "phone" || label.contains("Mobile");
              bool isAadhaar = label.contains("Aadhaar");
              bool isPan = label.contains("PAN") && !label.contains("PAN Mode");
              bool isName = label.contains("Name");
              bool isNumber = field["type"] == "number" || label.contains("Amount") || label.contains("Quantity");

              TextInputType keyboardType = TextInputType.text;
              TextCapitalization textCapitalization = TextCapitalization.none;

              if (isPhone) {
                keyboardType = TextInputType.phone;
              } else if (isAadhaar || isNumber) {
                keyboardType = TextInputType.number;
              } else if (isPan) {
                keyboardType = TextInputType.text;
                textCapitalization = TextCapitalization.characters;
              } else if (isName) {
                keyboardType = TextInputType.name;
                textCapitalization = TextCapitalization.words;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text(
                      label,
                      textColor: blackColor,
                      fontSize: 14,
                      fontFamily: FontFamily.plusJakartaSansMedium,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: greyColor.withOpacity(0.5)),
                      ),
                      child: TextField(
                        controller: _controllers[label],
                        readOnly: isDate,
                        keyboardType: keyboardType,
                        textCapitalization: textCapitalization,
                        onTap: isDate
                            ? () async {
                                FocusScope.of(context).unfocus();
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(2000, 1, 1),
                                  firstDate: DateTime(1920),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  String formattedDate =
                                      "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                                  _controllers[label]?.text = formattedDate;
                                }
                              }
                            : null,
                        inputFormatters: [
                          if (isPhone) ...[
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.digitsOnly,
                          ] else if (isAadhaar) ...[
                            LengthLimitingTextInputFormatter(12),
                            FilteringTextInputFormatter.digitsOnly,
                          ] else if (isPan) ...[
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                            TextInputFormatter.withFunction(
                              (oldVal, newVal) => TextEditingValue(
                                text: newVal.text.toUpperCase(),
                                selection: newVal.selection,
                              ),
                            ),
                          ] else if (isNumber) ...[
                            FilteringTextInputFormatter.digitsOnly,
                          ] else if (!isDate) ...[
                            LengthLimitingTextInputFormatter(50),
                          ],
                        ],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          hintText: field["hint"],
                          hintStyle: const TextStyle(color: greyColor, fontFamily: FontFamily.plusJakartaSansRegular, fontSize: 14),
                          suffixIcon: isDate ? const Icon(Icons.calendar_month, color: primaryColor) : null,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [primaryColor, secondaryColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ElevatedButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  // Perform field validations before submitting
                  for (var field in fields) {
                    String label = field["label"];
                    String type = field["type"];

                    if (type == "dropdown") {
                      String? val = _dropdownValues[label];
                      if (val == null || val.trim().isEmpty) {
                        Fluttertoast.showToast(
                          msg: "Please select $label",
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                        return;
                      }
                    } else {
                      String val = _controllers[label]?.text.trim() ?? "";
                      if (val.isEmpty) {
                        Fluttertoast.showToast(
                          msg: "Please enter $label",
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                        return;
                      }

                      if (type == "phone" || label.contains("Mobile")) {
                        if (!RegExp(r'^[6-9]\d{9}$').hasMatch(val)) {
                          Fluttertoast.showToast(
                            msg: "Please enter a valid 10-digit mobile number",
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                          return;
                        }
                      } else if (label.contains("Aadhaar")) {
                        if (!RegExp(r'^\d{12}$').hasMatch(val)) {
                          Fluttertoast.showToast(
                            msg: "Please enter a valid 12-digit Aadhaar number",
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                          return;
                        }
                      } else if (label.contains("PAN") && !label.contains("PAN Mode")) {
                        if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(val.toUpperCase())) {
                          Fluttertoast.showToast(
                            msg: "Please enter a valid 10-character PAN number (e.g. ABCDE1234F)",
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                          return;
                        }
                      } else if (label.contains("Name") && val.length < 2) {
                        Fluttertoast.showToast(
                          msg: "Please enter a valid full name",
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                        return;
                      }
                    }
                  }

                  if (widget.title == "PAN Services") {
                    String mobileNumber = _controllers["Mobile Number"]?.text.trim() ?? "";
                    var response = await rechargeController.createNsdlPan(
                      context: context,
                      mobileNumber: mobileNumber,
                    );

                    if (response != null &&
                        (response['status'] == true ||
                         response['status'] == 'Success' ||
                         response['status'] == 'success' ||
                         response['success'] == true)) {
                      String? redirectUrl = response['url']?.toString() ??
                          response['redirect_url']?.toString() ??
                          response['link']?.toString() ??
                          response['data']?['url']?.toString() ??
                          response['data']?['redirect_url']?.toString() ??
                          response['data']?['link']?.toString();

                      if (redirectUrl != null && redirectUrl.isNotEmpty) {
                        Uri uri = Uri.parse(redirectUrl);
                        try {
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                          } else {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        } catch (e) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        }
                      } else {
                        String msg = response['message']?.toString() ?? "PAN Service initiated successfully";
                        Fluttertoast.showToast(msg: msg, backgroundColor: Colors.green);
                      }
                    } else {
                      String msg = cleanApiMessage(response);
                      if (msg.isEmpty) msg = "Failed to initiate PAN service";
                      Fluttertoast.showToast(msg: msg, backgroundColor: Colors.red);
                    }
                    return;
                  }

                  if (widget.opcode != null && _controllers.isNotEmpty) {
                    String consumerId = _controllers.values.first.text.trim();
                    if (consumerId.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "Please enter consumer/K number",
                        backgroundColor: Colors.red,
                      );
                      return;
                    }
                    
                    var response = await rechargeController.fetchUtilityBill(
                      context: context, 
                      consumerId: consumerId, 
                      opcode: widget.opcode!
                    );
                    
                    if (response != null && (response['status'] == true || response['status'] == 'Success')) {
                      _showBillDetailsModal(context, response, consumerId);
                    } else {
                      String errorMsg = cleanApiMessage(response);
                      if (errorMsg.isEmpty) errorMsg = "Failed to fetch bill details";
                      Fluttertoast.showToast(
                        msg: errorMsg,
                        backgroundColor: Colors.red,
                      );
                    }
                  } else {
                    String inputNumber = _controllers["Mobile Number"]?.text.trim() ??
                        _controllers["Consumer Number / Account ID / K Number"]?.text.trim() ??
                        (_controllers.isNotEmpty ? _controllers.values.first.text.trim() : "");
                    String inputAmount = _controllers["Amount"]?.text.trim() ?? "100";
                    double amountVal = double.tryParse(inputAmount) ?? 100.0;

                    RazorpayHelper(context: context).startPaymentWithOrderFlow(
                      context: context,
                      opcode: widget.opcode ?? "SERVICE_PAY",
                      number: inputNumber.isNotEmpty ? inputNumber : "CUSTOMER",
                      amount: amountVal,
                      description: "${widget.title} Payment",
                      serviceName: widget.title,
                      providerName: widget.title,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: text(
                  "Proceed",
                  textColor: white,
                  fontSize: 16,
                  fontFamily: FontFamily.plusJakartaSansBold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
