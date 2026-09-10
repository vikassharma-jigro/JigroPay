import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/app_utils/app_images.dart';

import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';
import 'package:get/get.dart';
import '../../../getx_controller/recharge_controller.dart';
import '../../View/dashdoard_view/generic_service_form_screen.dart';

class LoanRepaymentScreen extends StatefulWidget {
  const LoanRepaymentScreen({super.key});

  @override
  State<LoanRepaymentScreen> createState() => _LoanRepaymentScreenState();
}

class _LoanRepaymentScreenState extends State<LoanRepaymentScreen> {
  final RechargeController rechargeController = Get.put(RechargeController());
  TextEditingController searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      rechargeController.fetchOperatorsByType(context: context, type: "emi_payment");
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
                "Loan Repayment",
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
              TextField(
                controller: searchController,
                onChanged: (i) {
                  setState(() {});
                },
                onSubmitted: (v) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(15),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(15),
                  ),

                  // Other decoration properties...
                  filled: true,

                  // search Icon ------------------
                  prefixIcon: GestureDetector(
                    onTap: () {
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 8.0,
                        left: 0,
                        bottom: 5,
                        top: 5,
                      ),
                      child: const Icon(Icons.search, color: greyColor),
                    ),
                  ),
                  fillColor: white,
                  hintText: "Search by bank/NBFC",
                  hintStyle: const TextStyle(
                    fontSize: 16.0,
                    color: blackColor,
                    fontFamily: FontFamily.plusJakartaSansRegular,
                  ),
                  contentPadding: const EdgeInsets.only(
                    top: 5,
                    left: 10,
                    bottom: 5,
                    right: 0,
                  ),
                ),
              ),
              SizedBox(height: 15),
              text(
                "All Providers",
                textColor: blackColor,
                fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 5),
              text(
                "Select your bank or NBFC",
                textColor: greyColor,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansMedium,
                fontWeight: FontWeight.w600,
              ),

              SizedBox(height: 15),
              Obx(() {
                if (rechargeController.isLoading.value) {
                  return Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
                }
                
                var allOperators = rechargeController.dynamicOperatorsList;
                List<dynamic> filtered = allOperators.toList();
                String query = searchController.text.trim().toLowerCase();
                
                if (query.isNotEmpty) {
                  filtered = allOperators.where((op) {
                    String n = op['name']?.toString() ?? op['operator_name']?.toString() ?? op['biller_name']?.toString() ?? op['company']?.toString() ?? "";
                    return n.toLowerCase().contains(query);
                  }).toList();
                }

                if (filtered.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("No loan providers found.", style: TextStyle(color: greyColor, fontFamily: FontFamily.plusJakartaSansRegular)),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: filtered.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var operator = filtered[index];
                    String name = operator['name']?.toString() ?? operator['operator_name']?.toString() ?? operator['biller_name']?.toString() ?? operator['company']?.toString() ?? "";
                    String? iconUrl = operator['image']?.toString() ?? operator['icon']?.toString() ?? operator['logo']?.toString();
                    
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GenericServiceFormScreen(
                                title: "Loan Repayment",
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            // border: Border.all(color:greyColor)
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (iconUrl != null && iconUrl.isNotEmpty)
                                    Image.network(
                                      iconUrl,
                                      height: 30,
                                      width: 30,
                                      errorBuilder: (context, error, stackTrace) => Image.asset(AppImages.loanReImage, height: 30, width: 30),
                                    )
                                  else
                                    Image.asset(AppImages.loanReImage, height: 30, width: 30),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: text(
                                      name,
                                      textColor: blackColor,
                                      fontSize: 13,
                                      fontFamily:
                                          FontFamily.plusJakartaSansMedium,
                                      fontWeight: FontWeight.w500,
                                      maxLine: 2,
                                    ),
                                  ),
                              ],
                                                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
            ],
          ),
        ),
      ),
    );
  }
}
