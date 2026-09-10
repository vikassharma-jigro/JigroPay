import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/View/municipal_view/municipal_tax_no_screen.dart';
import 'package:jigrotech/app_utils/app_images.dart';

import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';
import 'package:get/get.dart';
import '../../../getx_controller/recharge_controller.dart';

class MunicipalServiceScreen extends StatefulWidget {
  const MunicipalServiceScreen({super.key});

  @override
  State<MunicipalServiceScreen> createState() => _MunicipalServiceScreenState();
}

class _MunicipalServiceScreenState extends State<MunicipalServiceScreen> {
  TextEditingController searchController = TextEditingController();
  List<String> options = [
    "Agartala Municipal Corporation",
    "Ahmedabad Municipal Corporation",
    "Ajmer Nagar Nigam",
    "Bhubaneswar Municipal Corporation",
    "Bicholim Municipal council",
    "CDMA Hyderabad",
    "Canacona Municipal council",
    "Corporation of City Panaji",
  ];
  final RechargeController rechargeController = Get.put(RechargeController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      rechargeController.fetchOperatorsByType(context: context, type: "municipal_taxes");
    });
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
                "Municipal Tax",
                textAlign: TextAlign.center,
                isCentered: true,
                textColor: blackColor,
                fontSize: 18,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),
            ),
           // Icon(Icons.help),

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
                "All Providers",
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
                      child: Text("No municipal providers found.", style: TextStyle(color: greyColor, fontFamily: FontFamily.plusJakartaSansRegular)),
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
                    String? iconUrl = operator['image']?.toString() ?? operator['icon']?.toString() ?? operator['logo']?.toString();
                    
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MunicipalTaxNoScreen(
                                    serviceNo: name,
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
                                      errorBuilder: (context, error, stackTrace) => SvgPicture.asset(AppImages.municipalImage, height: 30, width: 30),
                                    )
                                  else
                                    SvgPicture.asset(AppImages.municipalImage, height: 30, width: 30),
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
