import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import 'package:get/get.dart';
import '../../../getx_controller/recharge_controller.dart';
import '../../../api_services/api_base_helper.dart';
import '../../common/payment_success_screen.dart';

class RechargePlanScreen extends StatefulWidget {
  final String? mobileRechargeNumber;
  final String? photo;
  final String? number;
  final String? contactName;
  const RechargePlanScreen({
    super.key,
    this.mobileRechargeNumber,
    this.photo,
    this.number,
    this.contactName,
  });

  @override
  State<RechargePlanScreen> createState() => _RechargePlanScreenState();
}

class _RechargePlanScreenState extends State<RechargePlanScreen> {
  final RechargeController rechargeController = Get.put(RechargeController());
  TextEditingController searchController = TextEditingController();
  int selectedTabIndex = 0;
  String searchQuery = "";
  String _lastSelectedAmount = "0"; // tracks amount of last selected plan

  @override
  void initState() {
    super.initState();
    if (widget.mobileRechargeNumber != null && widget.mobileRechargeNumber!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        rechargeController.fetchOperatorAndPlans(
          context: context, 
          mobileNumber: widget.mobileRechargeNumber!
        );
      });
    }
  }

  String _extractData(dynamic plan) {
    if (plan == null) return "N/A";

    String rawData = plan['data']?.toString().trim() ?? '';
    if (rawData.isNotEmpty && 
        rawData.toUpperCase() != "N/A" && 
        rawData.toUpperCase() != "NA" && 
        rawData != "0" && 
        rawData.toLowerCase() != "null") {
      return rawData;
    }

    String desc = (plan['desc']?.toString() ?? plan['description']?.toString() ?? '').trim();
    if (desc.isEmpty) return "N/A";

    RegExp perDayRegex = RegExp(r'(\d+(?:\.\d+)?\s*(?:GB|MB))\s*/\s*(?:day|d)', caseSensitive: false);
    var match = perDayRegex.firstMatch(desc);
    if (match != null) {
      return "${match.group(1)}/Day";
    }

    RegExp totalDataRegex = RegExp(r'(\d+(?:\.\d+)?\s*(?:GB|MB))', caseSensitive: false);
    var match2 = totalDataRegex.firstMatch(desc);
    if (match2 != null) {
      String matchedStr = match2.group(0)!;
      int endIdx = desc.indexOf(matchedStr) + matchedStr.length;
      String snippet = desc.substring(endIdx, (endIdx + 10).clamp(0, desc.length)).toLowerCase();
      if (snippet.contains("day") || snippet.contains("/d")) {
        return "$matchedStr/Day";
      }
      return matchedStr;
    }

    if (desc.toLowerCase().contains("unlimited data")) {
      return "Unlimited";
    }

    return "N/A";
  }

  String _extractValidity(dynamic plan) {
    if (plan == null) return "N/A";

    String rawVal = plan['validity']?.toString().trim() ?? '';
    if (rawVal.isNotEmpty && 
        rawVal.toUpperCase() != "N/A" && 
        rawVal.toUpperCase() != "NA" && 
        rawVal != "0" && 
        rawVal.toLowerCase() != "null") {
      return rawVal;
    }

    String desc = (plan['desc']?.toString() ?? plan['description']?.toString() ?? '').trim();
    if (desc.isEmpty) return "N/A";

    RegExp valRegex = RegExp(r'(?:validity[:\s]*)?(\d+)\s*(days|day|month|months|year)', caseSensitive: false);
    var match = valRegex.firstMatch(desc);
    if (match != null) {
      return "${match.group(1)} ${match.group(2)}";
    }

    if (desc.toLowerCase().contains("existing plan") || desc.toLowerCase().contains("same as active")) {
      return "Existing Plan";
    }

    return "N/A";
  }

  void _showPlanDetailsBottomSheet(BuildContext context, dynamic plan) {
    String amount = plan['rs']?.toString() ?? plan['amount']?.toString() ?? plan['price']?.toString() ?? "0";
    String validity = _extractValidity(plan);
    String data = _extractData(plan); 
    String desc = plan['desc']?.toString() ?? plan['description']?.toString() ?? "No additional details available.";
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      text(
                        "₹$amount Plan Details",
                        textColor: Colors.black,
                        fontSize: 20,
                        fontFamily: FontFamily.plusJakartaSansBold,
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.close, color: Colors.black54),
                      )
                    ],
                  ),
                ),
                
                // Validity & Data
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text("Validity", textColor: Colors.grey, fontSize: 12),
                            SizedBox(height: 5),
                            text(
                              validity,
                              textColor: Colors.black,
                              fontSize: 16,
                              fontFamily: FontFamily.plusJakartaSansMedium,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text("Data", textColor: Colors.grey, fontSize: 12),
                            SizedBox(height: 5),
                            text(
                              data,
                              textColor: Colors.black,
                              fontSize: 16,
                              fontFamily: FontFamily.plusJakartaSansMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Divider(color: Colors.grey.shade200, thickness: 1),
                
                // Additional Benefits
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(
                          "Additional Benefits",
                          textColor: Colors.black,
                          fontSize: 16,
                          fontFamily: FontFamily.plusJakartaSansBold,
                        ),
                        SizedBox(height: 15),
                        // Displaying desc text
                        text(
                          desc,
                          textColor: Colors.grey[800],
                          fontSize: 14,
                          fontFamily: FontFamily.plusJakartaSansRegular,
                        ),
                        SizedBox(height: 20),
                        
                        // Fake benefits just to match UI look if desc isn't structured well
                        if (desc.toLowerCase().contains("5g"))
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                              child: text("5G", textColor: Colors.white, fontSize: 12, fontFamily: FontFamily.plusJakartaSansBold),
                            ),
                            title: text("Unlimited 5G Data", textColor: Colors.black, fontSize: 14, fontFamily: FontFamily.plusJakartaSansMedium),
                            subtitle: text("Unlimited 5G Data is over and above your plan limit.", textColor: Colors.grey[600], fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                ),
                
                // Proceed Button
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, -5)
                      )
                    ]
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [primaryColor, secondaryColor],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        print("👉 Proceed button clicked!");

                        var opData = rechargeController.operatorData.value;
                        dynamic nested = (opData is Map && opData.containsKey('data')) ? opData['data'] : opData;
                        if (nested is List && nested.isNotEmpty) {
                          nested = nested.first;
                        }

                        String opcode = "";
                        if (nested is Map) {
                          opcode = nested['mapped_opcode']?.toString() ??
                              nested['company_code']?.toString() ??
                              nested['opcode']?.toString() ??
                              nested['operator_code']?.toString() ??
                              nested['operator']?.toString() ??
                              "";
                        }
                        if (opcode.isEmpty && opData is Map) {
                          opcode = opData['mapped_opcode']?.toString() ??
                              opData['company_code']?.toString() ??
                              opData['opcode']?.toString() ??
                              opData['operator_code']?.toString() ??
                              "";
                        }

                        String rawNumber = widget.number ?? widget.mobileRechargeNumber ?? "";
                        String number = rawNumber.replaceAll(RegExp(r'\D'), '');
                        if (number.length > 10) {
                          number = number.substring(number.length - 10);
                        }
                        if (number.isEmpty) {
                          number = rawNumber;
                        }

                        print("👉 Calling createRechargeOrder with opcode='$opcode', number='$number', amount='$amount'");

                        var orderResponse = await rechargeController.createRechargeOrder(
                          context: context,
                          opcode: opcode,
                          number: number,
                          amount: amount,
                        );

                        print("👉 Order creation API completed. Response: $orderResponse");

                        bool isSuccess = orderResponse != null &&
                            (orderResponse['status'] == true ||
                             orderResponse['status'] == 'Success' ||
                             orderResponse['status'] == 'success' ||
                             orderResponse['success'] == true ||
                             orderResponse['status'] == 1 ||
                             orderResponse['status'] == '1' ||
                             orderResponse['statusCode'] == 200 ||
                             orderResponse['statusCode'] == '200' ||
                             orderResponse['order_id'] != null ||
                             orderResponse['data'] != null) &&
                            (orderResponse['status'] != 'Failure' && orderResponse['status'] != false && orderResponse['status'] != 'false');

                        if (isSuccess && orderResponse != null) {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }

                          double parsedAmount = double.tryParse(amount) ?? 0;
                          int razorpayAmount = (parsedAmount * 100).round();
                          if (razorpayAmount <= 0) {
                            razorpayAmount = 1000 * 100;
                          }

                          String orderId = orderResponse['order_id']?.toString() ??
                              orderResponse['data']?['order_id']?.toString() ??
                              orderResponse['data']?['id']?.toString() ??
                              '';

                          Razorpay razorpay = Razorpay();
                          var options = {
                            //'key': "rzp_live_TLKy91eX8x6Xum",
                            'key': "rzp_test_TK6QbAu1THjboL",
                            'amount': razorpayAmount,
                            'name': 'Jigro Pay',
                            'description': 'Recharge Payment',
                            if (orderId.isNotEmpty) 'order_id': orderId,
                            'retry': {
                              'enabled': true,
                            },
                            'send_sms_hash': true,
                            'prefill': {
                              'contact': number.isNotEmpty ? number : '9694870658',
                              'email': 'test@razorpay.com'
                            },
                            'external': {
                              'wallets': ['paytm']
                            }
                          };
                          razorpay.on(
                            Razorpay.EVENT_PAYMENT_ERROR,
                            handlePaymentErrorResponse,
                          );
                          razorpay.on(
                            Razorpay.EVENT_PAYMENT_SUCCESS,
                            handlePaymentSuccessResponse,
                          );
                          // Save amount so success screen can display it
                          setState(() { _lastSelectedAmount = amount; });
                          razorpay.open(options);
                        } else {
                          String errorMsg = cleanApiMessage(orderResponse);
                          if (errorMsg.isNotEmpty) {
                            Fluttertoast.showToast(
                              msg: errorMsg,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                            );
                          }
                          print("❌ [RECHARGE ORDER CREATION FAILED: $errorMsg]");
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
                        "Proceed with ₹$amount",
                        textColor: Colors.white,
                        fontSize: 16,
                        fontFamily: FontFamily.plusJakartaSansBold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }

  void _onTabSelected(int index, List<String> currentTabs) {
    setState(() {
      selectedTabIndex = index;
    });
    
    String selectedTab = currentTabs[index];
    if (selectedTab == "Special Offers") {
      var operatorData = rechargeController.operatorData;
      String opcode = operatorData['mapped_opcode']?.toString() ?? operatorData['company_code']?.toString() ?? operatorData['opcode']?.toString() ?? "A";
      
      if (widget.mobileRechargeNumber != null) {
        rechargeController.fetchRoffer(
          context: context,
          mobileNumber: widget.mobileRechargeNumber!,
          opcode: opcode,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9), // Very light grey background
      appBar: AppBar(
        backgroundColor: Color(0xFFF9F9F9),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300)
                ),
                child: Icon(Icons.arrow_back, color: Colors.black87, size: 20),
              ),
            ),
            text(
              "Select Plan",
              textColor: Colors.black,
              fontSize: 18,
              fontFamily: FontFamily.plusJakartaSansBold,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(width: 36),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Operator Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Obx(() {
                var opData = rechargeController.operatorData;
                String company = opData['company']?.toString() ?? "Operator";
                String circle = opData['circle']?.toString() ?? "Circle";
                
                String displayName = (widget.contactName != null && widget.contactName!.trim().isNotEmpty)
                    ? widget.contactName!.trim()
                    : "My Number";
                
                return Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300)
                      ),
                      child: Icon(Icons.person, color: Color(0xFF0D47A1)), // Blue icon for Jio roughly
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text(
                            "$displayName . ${widget.mobileRechargeNumber ?? ''}",
                            textColor: Colors.black,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                          ),
                          Row(
                            children: [
                              text(
                                "$company Prepaid . $circle ",
                                textColor: Colors.grey[700],
                                fontSize: 12,
                                fontFamily: FontFamily.plusJakartaSansRegular,
                              ),
                              // InkWell(
                              //   onTap: () {},
                              //   child: Container(
                              //     padding: EdgeInsets.only(bottom: 1),
                              //     decoration: BoxDecoration(
                              //       border: Border(bottom: BorderSide(color: Color(0xFFD500F9), width: 1))
                              //     ),
                              //     child: text(
                              //       "Change",
                              //       textColor: Color(0xFFD500F9),
                              //       fontSize: 12,
                              //       fontFamily: FontFamily.plusJakartaSansMedium,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade200)
                ),
                child: TextFormField(
                  controller: searchController,
                  onChanged: (val) {
                    setState(() {
                      searchQuery = val.trim();
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    //suffixIcon: Icon(Icons.tune, color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    hintText: "Search recharge plans",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontFamily: FontFamily.plusJakartaSansRegular,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 15),

            // Tab Bar and Plans List
            Obx(() {
              if (rechargeController.isLoading.value) {
                return Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              
              var categorizedPlans = rechargeController.categorizedPlans;
              List<String> currentTabs = categorizedPlans.keys.map((k) => k.toString()).toList();
              
              // Dynamically add Roffer tab if Airtel/Vodafone
              var opData = rechargeController.operatorData;
              String company = opData['company']?.toString() ?? "";
              String opcode = opData['mapped_opcode']?.toString() ?? opData['company_code']?.toString() ?? opData['opcode']?.toString() ?? "";
              String compLower = company.toLowerCase();
              bool isRofferAvailable = opcode == "A" || opcode == "V" || opcode == "VI" || compLower.contains("airtel") || compLower.contains("vodafone") || compLower.contains("vi");
              
              if (isRofferAvailable && !currentTabs.contains("Special Offers")) {
                currentTabs.add("Special Offers");
              }
              
              if (currentTabs.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text(
                      "No plans found.", 
                      style: TextStyle(color: Colors.grey, fontFamily: FontFamily.plusJakartaSansRegular)
                    ),
                  ),
                );
              }
              
              if (selectedTabIndex >= currentTabs.length) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    selectedTabIndex = 0;
                  });
                });
                return SizedBox.shrink();
              }
              
              String selectedTab = currentTabs[selectedTabIndex];
              bool isRofferSelected = selectedTab == "Special Offers";
              var rawList = isRofferSelected 
                  ? rechargeController.rofferList 
                  : (categorizedPlans[selectedTab] ?? []);

              // Filter based on search query
              var activeList = [];
              if (searchQuery.isEmpty) {
                activeList = rawList;
              } else {
                activeList = rawList.where((plan) {
                  String amount = plan['rs']?.toString() ?? plan['amount']?.toString() ?? plan['price']?.toString() ?? "0";
                  String desc = plan['desc']?.toString() ?? plan['description']?.toString() ?? "";
                  return amount.toLowerCase().contains(searchQuery.toLowerCase()) || 
                         desc.toLowerCase().contains(searchQuery.toLowerCase());
                }).toList();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: List.generate(currentTabs.length, (index) {
                        bool isSelected = selectedTabIndex == index;
                        return GestureDetector(
                          onTap: () => _onTabSelected(index, currentTabs),
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? const LinearGradient(
                                      colors: [primaryColor, secondaryColor],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    )
                                  : null,
                              color: isSelected ? null : Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: isSelected ? Colors.transparent : Colors.grey.shade300,
                              ),
                            ),
                            child: text(
                              currentTabs[index],
                              textColor: isSelected ? Colors.white : Colors.black87,
                              fontSize: 14,
                              fontFamily: isSelected ? FontFamily.plusJakartaSansMedium : FontFamily.plusJakartaSansRegular,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 15),
                  
                  if (activeList.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Text(
                          "No plans found for this category.", 
                          style: TextStyle(color: Colors.grey, fontFamily: FontFamily.plusJakartaSansRegular)
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: activeList.length,
                      itemBuilder: (context, index) {
                        var plan = activeList[index];
                        String amount = plan['rs']?.toString() ?? plan['amount']?.toString() ?? plan['price']?.toString() ?? "0";
                        String validity = _extractValidity(plan);
                        String data = _extractData(plan); 
                        String desc = plan['desc']?.toString() ?? plan['description']?.toString() ?? "";
                        
                        bool has5G = desc.toLowerCase().contains("5g");
                        bool isUnlimited = desc.toLowerCase().contains("unlimited") || data.toLowerCase().contains("unlimited");
                        
                        String topTag = "";
                        Color tagBgColor = Colors.transparent;
                        Color tagTextColor = Colors.transparent;
                        
                        if (isRofferSelected) {
                          topTag = "SPECIAL OFFER";
                          tagBgColor = Color(0xFFFFF3E0);
                          tagTextColor = Color(0xFFFFB300);
                        } else if (isUnlimited) {
                          topTag = "UNLIMITED";
                          tagBgColor = Color(0xFFE8F5E9);
                          tagTextColor = Color(0xFF43A047);
                        } else if (has5G) {
                          topTag = "5G PLAN";
                          tagBgColor = Color(0xFFFFEBEE);
                          tagTextColor = Color(0xFFE53935);
                        }
                        
                        return InkWell(
                          onTap: (){
                            _showPlanDetailsBottomSheet(context, plan);
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey.shade200),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // if (topTag.isNotEmpty)
                                //   Container(
                                //     width: double.infinity,
                                //     padding: EdgeInsets.symmetric(vertical: 5),
                                //     decoration: BoxDecoration(
                                //       color: tagBgColor,
                                //       borderRadius: BorderRadius.only(
                                //         topLeft: Radius.circular(15),
                                //         topRight: Radius.circular(15),
                                //       ),
                                //     ),
                                //     child: Center(
                                //       child: text(
                                //         topTag,
                                //         textColor: tagTextColor,
                                //         fontSize: 12,
                                //         fontFamily: FontFamily.plusJakartaSansBold,
                                //         latterSpacing: 1.2
                                //       ),
                                //     ),
                                //   ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          text(
                                            "₹$amount",
                                            textColor: blackColor,
                                            fontSize: 32,
                                            fontFamily: FontFamily.plusJakartaSansBold,
                                          ),
                                          SizedBox(width: 20),
                                          Container(
                                            height: 35,
                                            width: 1,
                                            color: Colors.grey.shade300,
                                          ),
                                          SizedBox(width: 15),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                text("Validity", textColor: Colors.grey, fontSize: 14),
                                                text(
                                                  validity,
                                                  textColor: Colors.black,
                                                  fontSize: 16,
                                                  fontFamily: FontFamily.plusJakartaSansBold,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 35,
                                            width: 1,
                                            color: Colors.grey.shade300,
                                          ),
                                          SizedBox(width: 15),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                text("Data", textColor: Colors.grey, fontSize: 14),
                                                text(
                                                  data,
                                                  textColor: Colors.black,
                                                  fontSize: 16,
                                                  fontFamily: FontFamily.plusJakartaSansBold,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Divider(color: Colors.grey.shade200, thickness: 1),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              if (has5G)
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius: BorderRadius.circular(4)
                                                  ),
                                                  child: text("5G", textColor: Colors.white, fontSize: 10, fontFamily: FontFamily.plusJakartaSansBold),
                                                ),
                                              if (has5G) SizedBox(width: 8),
                                              text(
                                                isUnlimited ? "" : "Data benefits included",
                                                textColor: Colors.grey[700],
                                                fontSize: 14,
                                                fontFamily: FontFamily.plusJakartaSansMedium,
                                              ),
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () => _showPlanDetailsBottomSheet(context, plan),
                                            child: text(
                                              "Details",
                                              textColor: secondaryColor, // Deep purple details link
                                              fontSize: 14,
                                              fontFamily: FontFamily.plusJakartaSansBold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              );
            }),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */

    showAlertDialog(context, "Payment Failed",
        "Description: Something went wrong");
    // showAlertDialog(context, "Payment Failed",
    //     "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    print("💳 Razorpay Payment Successful!");
    print("Payment ID: ${response.paymentId}");
    print("Order ID: ${response.orderId}");
    print("Signature: ${response.signature}");

    String paymentId = response.paymentId ?? "";
    String orderId   = response.orderId ?? "";
    String signature = response.signature ?? "";

    // 1. Verify payment with backend
    await rechargeController.verifyRechargePayment(
      context: context,
      razorpayPaymentId: paymentId,
      razorpayOrderId: orderId,
      razorpaySignature: signature,
    );

    // 2. Get operator/number info for the success screen
    var opData       = rechargeController.operatorData;
    String operator  = opData['company']?.toString() ?? "Mobile Recharge";
    String number    = widget.mobileRechargeNumber ?? widget.number ?? "";

    // 3. Navigate to PaymentSuccessScreen
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentSuccessScreen(
          serviceName:    "Mobile Recharge",
          providerName:   operator,
          consumerNumber: number,
          amount:         _lastSelectedAmount,
          transactionId:  paymentId,
          orderId:        orderId,
          paidVia:        'Razorpay',
        ),
      ),
    );
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
