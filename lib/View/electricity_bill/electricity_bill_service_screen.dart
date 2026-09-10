import 'package:flutter/material.dart';
import 'package:jigrotech/app_utils/app_images.dart';

import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';
import 'package:get/get.dart';
import '../../../getx_controller/recharge_controller.dart';
import 'bill_number_screen.dart';

class ElectricityBillServiceScreen extends StatefulWidget {
  const ElectricityBillServiceScreen({super.key});

  @override
  State<ElectricityBillServiceScreen> createState() =>
      _ElectricityBillServiceScreenState();
}

class _ElectricityBillServiceScreenState
    extends State<ElectricityBillServiceScreen> {

  final RechargeController rechargeController = Get.put(RechargeController());
  TextEditingController searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      rechargeController.fetchOperatorsByType(context: context, type: "electricity");
    });
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
              TextField(
                controller: searchController,
                onChanged: (i) {
                  setState(() {});
                },

                // filterSearch,
                // });
                onSubmitted: (v) {},
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
                      // filterSearch(searchController.text);
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
                  hintText: "Search by name",
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
              // SizedBox(height: 10),
              // text(
              //   "Enter Biller Name or Biller Number",
              //   textAlign: TextAlign.center,
              //   isCentered: true,
              //   textColor: greyColor,
              //   fontSize: 12,
              //   fontFamily: FontFamily.plusJakartaSansRegular,
              //   fontWeight: FontWeight.w600,
              // ),
              SizedBox(height: 20),
              text(
                "All Billers",
                textAlign: TextAlign.center,
                isCentered: true,
                textColor: blackColor,
                fontSize: 20,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),

              SizedBox(height: 15),
              Obx(() {
                if (rechargeController.isLoading.value) {
                  return Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
                }
                
                List<dynamic> operators = rechargeController.dynamicOperatorsList;
                if (searchController.text.isNotEmpty) {
                  operators = operators.where((element) {
                    String name = element['name']?.toString() ?? element['operator_name']?.toString() ?? element['biller_name']?.toString() ?? element['company'] ?? "";
                    return name.toLowerCase().contains(searchController.text.toLowerCase());
                  }).toList();
                }

                if (operators.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("No electricity providers found.", style: TextStyle(color: greyColor, fontFamily: FontFamily.plusJakartaSansRegular)),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: operators.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var operator = operators[index];
                    String name = operator['name']?.toString() ?? operator['operator_name']?.toString() ?? operator['biller_name']?.toString() ?? operator['company'];
                    String? iconUrl = operator['image']?.toString() ?? operator['icon']?.toString() ?? operator['logo']?.toString();
                    
                    return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BillNumberScreen(
                              billServiceName: name,
                              opcode: operator['operator_code']?.toString() ?? operator['opcode']?.toString(),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
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
                                      errorBuilder: (context, error, stackTrace) => Image.asset(AppImages.jvvnlImage, height: 30, width: 30),
                                    )
                                  else
                                    Image.asset(AppImages.jvvnlImage, height: 30, width: 30),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: text(
                                      name,
                                      textColor: blackColor,
                                      fontSize: 14,
                                      fontFamily:
                                          FontFamily.plusJakartaSansMedium,
                                      fontWeight: FontWeight.w500,
                                      maxLine: 2,
                                    ),
                                  ),
                              ],
                            ),
                            Divider(thickness: .5),
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
