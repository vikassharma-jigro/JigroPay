import 'package:flutter/material.dart';
import 'package:jigrotech/View/water_view/water_rrNumber_screen.dart';
import 'package:get/get.dart';
import '../../../getx_controller/recharge_controller.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';

class WaterServiceScreen extends StatefulWidget {
  const WaterServiceScreen({super.key});

  @override
  State<WaterServiceScreen> createState() => _WaterServiceScreenState();
}



class _WaterServiceScreenState extends State<WaterServiceScreen> {
  TextEditingController searchController = TextEditingController();
  final RechargeController rechargeController = Get.put(RechargeController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      rechargeController.fetchOperatorsByType(context: context, type: "water_bill");
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
                "Water",
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
                  setState(() {}); // Trigger rebuild to filter
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
                    onTap: () {},
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
                  return Center(child: CircularProgressIndicator());
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
                      child: Text("No water providers found.", style: TextStyle(color: greyColor, fontFamily: FontFamily.plusJakartaSansRegular)),
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
                    String name = operator['name']?.toString() ?? operator['operator_name']?.toString() ?? operator['biller_name']?.toString() ?? operator['company'] ?? "";
                    String? iconUrl = operator['image']?.toString() ?? operator['icon']?.toString() ?? operator['logo']?.toString();

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WaterRrnumberScreen(
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
                                        width: 30,
                                        height: 30,
                                        errorBuilder: (context, error, stackTrace) => Icon(Icons.water_drop, color: Colors.blue),
                                      )
                                    else
                                      Icon(Icons.water_drop, color: Colors.blue),
                                    SizedBox(width: 10),

                                    Expanded(
                                      child: text(
                                        name,
                                        maxLine: 2,
                                        textColor: blackColor,
                                        fontSize: 14,
                                        fontFamily: FontFamily.plusJakartaSansMedium,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Divider(color: greyColor.withOpacity(.3)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
})
            ],
          ),
        ),
      ),
    );
  }
}
