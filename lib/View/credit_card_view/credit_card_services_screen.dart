import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/app_utils/app_images.dart';

import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import 'package:get/get.dart';
import '../../../getx_controller/recharge_controller.dart';
import 'credit_card_details_screen.dart';

class CreditCardServicesScreen extends StatefulWidget {
  const CreditCardServicesScreen({super.key});

  @override
  State<CreditCardServicesScreen> createState() =>
      _CreditCardServicesScreenState();
}

class _CreditCardServicesScreenState extends State<CreditCardServicesScreen> {
  TextEditingController searchController = TextEditingController();
  List<String> options = [
    "HDFC Bank Credit Card",
    "AU Bank Credit Card",
    "Axis Bank Credit Card",
    "Bank of Maharashtra Credit Card",
    "BoB Credit Card",
    "CUB Credit Card",
    "Canara Credit Card",
    "DBS Bank Credit Card",
    "DCB Bank Credit Card",
    "Dhanlaxmi Bank Limited",
  ];
  final RechargeController rechargeController = Get.put(RechargeController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      rechargeController.fetchOperatorsByType(context: context, type: "credit_card");
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
                "Credit Card Payment",
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
                  hintText: "Search by provider",
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
                "All Provider",
                textColor: blackColor,
                fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansBold,
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
                      child: Text("No credit card providers found.", style: TextStyle(color: greyColor, fontFamily: FontFamily.plusJakartaSansRegular)),
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
                    String name = operator['name']?.toString() ?? operator['operator_name']?.toString() ?? operator['biller_name']?.toString() ?? operator['company']?.toString() ?? options[index % options.length];
                    String? iconUrl = operator['image']?.toString() ?? operator['icon_url']?.toString() ?? operator['logo']?.toString();
                    
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreditCardDetailsScreen(
                                creditBankServiceName: name,
                                opcode: operator['inspay_code']?.toString() ?? operator['opcode']?.toString(),
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
                                      errorBuilder: (context, error, stackTrace) => SvgPicture.asset(AppImages.creditCardImage, height: 30, width: 30),
                                    )
                                  else
                                    SvgPicture.asset(AppImages.creditCardImage, height: 30, width: 30),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: text(
                                      name,
                                      maxLine: 2,
                                      textColor: blackColor,
                                      fontSize: 13,
                                      fontFamily:
                                          FontFamily.plusJakartaSansMedium,
                                      fontWeight: FontWeight.w500,
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
