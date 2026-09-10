import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/app_utils/app_images.dart';

import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';
import 'package:get/get.dart';
import '../../../getx_controller/recharge_controller.dart';
import 'cable_pay_screen.dart';

class CableServiceScreen extends StatefulWidget {
  const CableServiceScreen({super.key});

  @override
  State<CableServiceScreen> createState() => _CableServiceScreenState();
}

class _CableServiceScreenState extends State<CableServiceScreen> {
  List<String> options = [
    "ACT Cable TV",
    "Alka Vishwadarshan",
    "Amrita Cable Network",
    "Angel Cable And Broadband Service",
    "Ansari Cable Tv",
    "Arihant Network",
    "Aryan Cable Network",
    "BCN Digital",
  ];
  final RechargeController rechargeController = Get.put(RechargeController());
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      rechargeController.fetchOperatorsByType(context: context, type: "cable");
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
                "Cable",
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
                "Add New Connections",
                textColor: blackColor,
                fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 5),
              text(
                "Select your cable TV provider",
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
                
                var operators = rechargeController.dynamicOperatorsList;
                if (operators.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("No cable providers found.", style: TextStyle(color: greyColor, fontFamily: FontFamily.plusJakartaSansRegular)),
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
                    String name = operator['name']?.toString() ?? operator['operator_name']?.toString() ?? operator['biller_name']?.toString() ?? operator['company']?.toString() ?? options[index % options.length];
                    String? iconUrl = operator['image']?.toString() ?? operator['icon']?.toString() ?? operator['logo']?.toString();
                    
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CablePayScreen(
                                cableServiceName: name,
                                opcode: operator['operator_code']?.toString() ?? operator['opcode']?.toString(),
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
                                      errorBuilder: (context, error, stackTrace) => SvgPicture.asset(AppImages.tvDishImage, height: 30, width: 30),
                                    )
                                  else
                                    SvgPicture.asset(AppImages.tvDishImage, height: 30, width: 30),
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
