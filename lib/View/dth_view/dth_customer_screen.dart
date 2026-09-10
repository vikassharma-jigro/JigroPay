import 'package:dotted_border/dotted_border.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jigrotech/app_utils/app_images.dart';

import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';
import '../../app_utils/custom_textFiled.dart';

import 'package:get/get.dart';
import '../../../getx_controller/recharge_controller.dart';

class DthCustomerScreen extends StatefulWidget {
  final String? operatorDetails;
  final String? operatorName;
  const DthCustomerScreen({super.key, this.operatorDetails, this.operatorName});

  @override
  State<DthCustomerScreen> createState() => _DthCustomerScreenState();
}

class _DthCustomerScreenState extends State<DthCustomerScreen> {
  TextEditingController customerController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  RxString searchQuery = "".obs;
  
  final RechargeController rechargeController = Get.put(RechargeController());
  
  Timer? _debounce;
  final RxInt selectedPlanIndex = (-1).obs;

  @override
  void initState() {
    super.initState();
    rechargeController.plansList.value = [];
    customerController.addListener(_onSearchChanged);
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
  }

  @override
  void dispose() {
    customerController.removeListener(_onSearchChanged);
    customerController.dispose();
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  bool _validateCustomerId(String id, String? operatorName) {
    if (operatorName == null) return id.length >= 6;
    
    String op = operatorName.toLowerCase();
    
    if (op.contains('tata')) {
      return id.length == 10 || id.length == 11;
    } else if (op.contains('airtel')) {
      return id.length == 10;
    } else if (op.contains('dish')) {
      return id.length == 11;
    } else if (op.contains('d2h') || op.contains('videocon')) {
      return id.length == 11;
    } else if (op.contains('sun')) {
      return id.length == 11 || id.length == 12;
    }
    
    return id.length >= 6;
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      if (_validateCustomerId(customerController.text, widget.operatorName)) {
        _fetchDthInfo();
      }
    });
  }

  _fetchDthInfo() {
    String orderId = "TXN${DateTime.now().millisecondsSinceEpoch}";
    
    rechargeController.fetchDthPlans(
      context: context,
      dthNumber: customerController.text,
      opcode: widget.operatorDetails.toString(),
      orderId: orderId);
  }

  void _showPlanDetailsSheet(Map<String, dynamic> plan) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        String amount = plan['amount']?.toString() ?? plan['rs']?.toString() ?? plan['monthlyRecharge']?.toString() ?? '0';
        String name = plan['planName']?.toString() ?? plan['desc']?.toString() ?? plan['customerName']?.toString() ?? plan['name']?.toString() ?? 'Plan';
        String duration = plan['month']?.toString() ?? 'N/A';

        return Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text(
                name,
                textColor: blackColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: FontFamily.plusJakartaSansBold,
              ),
              const SizedBox(height: 10),
              if (duration != 'N/A') ...[
                text(
                  "Duration: $duration",
                  textColor: greyColor,
                  fontSize: 14,
                  fontFamily: FontFamily.plusJakartaSansMedium,
                ),
                const SizedBox(height: 10),
              ],
              text(
                "Amount: ₹$amount",
                textColor: primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: FontFamily.plusJakartaSansBold,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 55,
                child: CommonButton(
                  text: "Pay ₹$amount",
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
                    Navigator.pop(context);
                    // Add pay logic here if needed
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
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
                "DTH",
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
              text(
                "Enter your Customer Id",
                textColor: blackColor,
                fontSize: 20,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 15),
              Form(
                //key: _formKey,
                child: SizedBox(
                  height: 50,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Customer Id",
                      hintStyle: TextStyle(
                        color: greyColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: FontFamily.plusJakartaSansRegular,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: greyColor),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: greyColor),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    controller: customerController,
                    style: const TextStyle(
                      color: blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: FontFamily.plusJakartaSansMedium,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15),
              Obx(() => Visibility(
                visible: rechargeController.plansList.isNotEmpty,
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: greyColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: searchController,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search plans...",
                      prefixIcon: Icon(Icons.search, color: greyColor,size: 20,),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              )),
              Obx(() {
                if (rechargeController.isLoading.value) {
                  return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
                }
                
                if (rechargeController.plansList.isNotEmpty) {
                  List<Map<String, dynamic>> flattenedPlans = [];
                  
                  for (var languageItem in rechargeController.plansList) {
                    if (languageItem is Map && languageItem['Details'] != null && languageItem['Details'] is List) {
                      for (var detail in languageItem['Details']) {
                        String planName = detail['PlanName']?.toString() ?? '';
                        if (detail['PricingList'] != null && detail['PricingList'] is List) {
                          for (var pricing in detail['PricingList']) {
                            flattenedPlans.add({
                              'planName': planName,
                              'amount': pricing['Amount']?.toString() ?? '',
                              'month': pricing['Month']?.toString() ?? '',
                            });
                          }
                        }
                      }
                    }
                  }

                  if (searchQuery.value.isNotEmpty) {
                    flattenedPlans = flattenedPlans.where((plan) => 
                      plan['planName'].toString().toLowerCase().contains(searchQuery.value.toLowerCase()) ||
                      plan['amount'].toString().toLowerCase().contains(searchQuery.value.toLowerCase())
                    ).toList();
                  }

                  Widget contentWidget;
                  if (flattenedPlans.isEmpty && rechargeController.plansList.isNotEmpty && searchQuery.value.isEmpty) {
                    contentWidget = ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: rechargeController.plansList.length,
                      itemBuilder: (context, index) {
                        var plan = rechargeController.plansList[index];
                        return InkWell(
                          onTap: () {
                            if (plan['amount'] != null || plan['rs'] != null || plan['monthlyRecharge'] != null) {
                              selectedPlanIndex.value = index;
                              _showPlanDetailsSheet(Map<String, dynamic>.from(plan as Map));
                            }
                          },
                          child: Obx(() => Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: selectedPlanIndex.value == index ? secondaryColor : greyColor),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (plan['customerName'] != null || plan['name'] != null || plan['CustomerName'] != null)
                                  text("Name: ${plan['customerName'] ?? plan['name'] ?? plan['CustomerName']}", textColor: blackColor, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: FontFamily.plusJakartaSansBold),
                                if (plan['balance'] != null || plan['Balance'] != null)
                                  text("Balance: ₹${plan['balance'] ?? plan['Balance']}", textColor: blackColor, fontSize: 14, fontFamily: FontFamily.plusJakartaSansMedium),
                                if (plan['monthlyRecharge'] != null || plan['MonthlyRecharge'] != null)
                                  text("Monthly Recharge: ₹${plan['monthlyRecharge'] ?? plan['MonthlyRecharge']}", textColor: blackColor, fontSize: 14, fontFamily: FontFamily.plusJakartaSansMedium),
                                if (plan['nextRechargeDate'] != null || plan['NextRechargeDate'] != null)
                                  text("Next Recharge Date: ${plan['nextRechargeDate'] ?? plan['NextRechargeDate']}", textColor: blackColor, fontSize: 14, fontFamily: FontFamily.plusJakartaSansMedium),
                                if (plan['status'] != null || plan['Status'] != null)
                                  text("Status: ${plan['status'] ?? plan['Status']}", textColor: blackColor, fontSize: 14, fontFamily: FontFamily.plusJakartaSansMedium),
                                if (plan['planName'] != null)
                                  text("Plan: ${plan['planName']}", textColor: blackColor, fontSize: 14, fontFamily: FontFamily.plusJakartaSansMedium),
                                if (plan['desc'] != null)
                                  text("${plan['desc']}", textColor: blackColor, fontSize: 14, fontFamily: FontFamily.plusJakartaSansMedium),
                                if (plan['amount'] != null || plan['rs'] != null)
                                  text("Amount: ₹${plan['amount'] ?? plan['rs']}", textColor: blackColor, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: FontFamily.plusJakartaSansBold),
                              ],
                            ),
                          )),
                        );
                      }
                    );
                  } else if (flattenedPlans.isEmpty && searchQuery.value.isNotEmpty) {
                    contentWidget = const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: Text("No plans found")),
                    );
                  } else {
                    contentWidget = GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.98,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: flattenedPlans.length,
                    itemBuilder: (context, index) {
                      var item = flattenedPlans[index];
                      return InkWell(
                        onTap: () {
                          selectedPlanIndex.value = index;
                          _showPlanDetailsSheet(item);
                        },
                        child: Obx(() => Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: selectedPlanIndex.value == index ? secondaryColor : primaryColor),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              text(
                                item['planName'], 
                                textColor: blackColor, 
                                fontSize: 14, 
                                fontWeight: FontWeight.w600, 
                                fontFamily: FontFamily.plusJakartaSansBold,
                                maxLine: 3
                              ),
                              SizedBox(height: 8),
                              text(
                                "Duration: ${item['month']}", 
                                textColor: greyColor, 
                                fontSize: 12, 
                                fontFamily: FontFamily.plusJakartaSansMedium
                              ),
                              SizedBox(height: 8),
                              text(
                                "₹${item['amount']}", 
                                textColor: primaryColor, 
                                fontSize: 16, 
                                fontWeight: FontWeight.w600, 
                                fontFamily: FontFamily.plusJakartaSansBold
                              ),
                            ],
                          ),
                        )),
                      );
                    }
                  );
                  }

                  return contentWidget;
                }
                return const SizedBox.shrink();
              }),
              
              // SizedBox(height: 15),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              //   decoration: BoxDecoration(
              //     border: Border.all(color: pinkColor),
              //     borderRadius: BorderRadius.circular(10),
              //     color: lightPinkColor,
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Row(
              //         children: [
              //           Icon(Icons.copy),
              //           SizedBox(width: 15),
              //           text(
              //             "View Sample Bill",
              //             textAlign: TextAlign.center,
              //             isCentered: true,
              //             textColor: pinkColor,
              //             fontSize: 18,
              //             fontFamily: FontFamily.plusJakartaSansBold,
              //             fontWeight: FontWeight.w600,
              //           ),
              //         ],
              //       ),
              //       Icon(Icons.arrow_forward_ios),
              //     ],
              //   ),
              // ),
              //
              // SizedBox(height: 50),
              // text(
              //   "We'll save your details for future payments. You can always go to Bills to pay your upcoming dues.",
              //   textAlign: TextAlign.center,
              //   isCentered: true,
              //   textColor: greyColor,
              //   fontSize: 16,
              //   fontFamily: FontFamily.plusJakartaSansRegular,
              //   fontWeight: FontWeight.w600,
              // ),
              //
              // const SizedBox(height: 50),
              // SizedBox(
              //   width: MediaQuery.sizeOf(context).width,
              //   height: 55,
              //   child: CommonButton(
              //     text: "Continue",
              //     textColor: white,
              //     gradient: const LinearGradient(
              //       colors: [primaryColor, secondaryColor],
              //       begin: Alignment.topLeft,
              //       end: Alignment.bottomRight,
              //     ),
              //     fontWeight: FontWeight.w600,
              //     fontFamily: FontFamily.plusJakartaSansBold,
              //     fontSize: 16.0,
              //
              //     //padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              //     //borderRadius: BorderRadius.circular(40.0),
              //     onPressed: () {
              //       showDialogBox(context);
              //     },
              //   ),
              // ),
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
                  height: 170,
                  width: 300,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(AppImages.sunImage),
                            text(
                              "AIRTEL",
                              textColor: blackColor,
                              fontFamily: FontFamily.plusJakartaSansBold,
                              fontSize: 14,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        text(
                          "AIRTEL DTH",
                          textColor: blackColor,
                          fontFamily: FontFamily.plusJakartaSansBold,
                          fontSize: 14,
                        ),
                        text(
                          "DTH RECHARGE",
                          textColor: greyColor,
                          fontFamily: FontFamily.plusJakartaSansRegular,
                          fontSize: 14,
                        ),
                        SizedBox(height: 10),
                        Divider(thickness: .5, color: greyColor, height: 10),
                        SizedBox(height: 10),
                        text(
                          "Customer Id: 1598745630*",
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
