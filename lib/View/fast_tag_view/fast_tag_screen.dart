import 'package:flutter/material.dart';
import 'package:jigrotech/View/fast_tag_view/fast_tag_vehicle_screen.dart';
import 'package:jigrotech/app_utils/app_images.dart';

import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import 'package:get/get.dart';
import '../../../getx_controller/recharge_controller.dart';

class FastTagScreen extends StatefulWidget {
  const FastTagScreen({super.key});

  @override
  State<FastTagScreen> createState() => _FastTagScreenState();
}

class _FastTagScreenState extends State<FastTagScreen> {
  List<String> options = [
    "IDFC First Bank",
    "ICICI Bank",
    "State Bank of India (SBI)",
    "Airtel Payments Bank",
    "Axis Bank",
  ];

  final RechargeController rechargeController = Get.put(RechargeController());
  TextEditingController searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      rechargeController.fetchOperatorsByType(context: context, type: "fastag");
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
                "Select your FASTAG Pro",
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
                      child: Text("No FASTag providers found.", style: TextStyle(color: greyColor, fontFamily: FontFamily.plusJakartaSansRegular)),
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
                    
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FastTagVehicleScreen(
                              fastTagBankName: name,
                              fastTagBankOpcode: operator['operator_code']?.toString() ?? operator['opcode']?.toString(),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          //horizontal: 15,
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
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: primaryColor.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: _buildBankIcon(name, iconUrl),
                                ),
                                const SizedBox(width: 15),
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
                          ],
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

  Widget _buildBankIcon(String name, String? iconUrl) {
    String lowerName = name.toLowerCase();

    // 1. If valid HTTP URL exists from API, try loading network image first
    if (iconUrl != null && iconUrl.isNotEmpty && (iconUrl.startsWith("http://") || iconUrl.startsWith("https://"))) {
      return Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            iconUrl,
            height: 32,
            width: 32,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => _getFallbackBankLogo(name, lowerName),
          ),
        ),
      );
    }

    return _getFallbackBankLogo(name, lowerName);
  }

  Widget _getFallbackBankLogo(String name, String lowerName) {
    // 2. Check local bank image assets
    if (lowerName.contains("icici")) {
      return Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        child: Image.asset(AppImages.iciBnkImage, height: 32, width: 32, fit: BoxFit.contain),
      );
    } else if (lowerName.contains("hdfc")) {
      return Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        child: Image.asset(AppImages.hdfcImage, height: 32, width: 32, fit: BoxFit.contain),
      );
    }

    // 3. Try standard online logo URL for known banks
    String? logoUrl = _getOriginalBankLogoUrl(lowerName);
    if (logoUrl != null) {
      return Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            logoUrl,
            height: 32,
            width: 32,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => _buildBadgeWidget(name, lowerName),
          ),
        ),
      );
    }

    return _buildBadgeWidget(name, lowerName);
  }

  String? _getOriginalBankLogoUrl(String lowerName) {
    if (lowerName.contains("idfc")) {
      return "https://logo.clearbit.com/idfcfirstbank.com";
    } else if (lowerName.contains("sbi") || lowerName.contains("state bank")) {
      return "https://logo.clearbit.com/sbi.co.in";
    } else if (lowerName.contains("axis")) {
      return "https://logo.clearbit.com/axisbank.com";
    } else if (lowerName.contains("airtel")) {
      return "https://logo.clearbit.com/airtel.in";
    } else if (lowerName.contains("paytm")) {
      return "https://logo.clearbit.com/paytm.com";
    } else if (lowerName.contains("kotak")) {
      return "https://logo.clearbit.com/kotak.com";
    } else if (lowerName.contains("baroda") || lowerName.contains("bob")) {
      return "https://logo.clearbit.com/bankofbaroda.in";
    } else if (lowerName.contains("indusind")) {
      return "https://logo.clearbit.com/indusind.com";
    } else if (lowerName.contains("federal")) {
      return "https://logo.clearbit.com/federalbank.co.in";
    } else if (lowerName.contains("canara")) {
      return "https://logo.clearbit.com/canarabank.com";
    } else if (lowerName.contains("union")) {
      return "https://logo.clearbit.com/unionbankofindia.co.in";
    } else if (lowerName.contains("pnb") || lowerName.contains("punjab national")) {
      return "https://logo.clearbit.com/pnbindia.in";
    } else if (lowerName.contains("yes bank") || lowerName.contains("yesbank")) {
      return "https://logo.clearbit.com/yesbank.in";
    } else if (lowerName.contains("equitas")) {
      return "https://logo.clearbit.com/equitasbank.com";
    } else if (lowerName.contains("au bank") || lowerName.contains("au small")) {
      return "https://logo.clearbit.com/aubank.in";
    } else if (lowerName.contains("bandhan")) {
      return "https://logo.clearbit.com/bandhanbank.com";
    } else if (lowerName.contains("south indian")) {
      return "https://logo.clearbit.com/southindianbank.com";
    } else if (lowerName.contains("indian bank")) {
      return "https://logo.clearbit.com/indianbank.in";
    } else if (lowerName.contains("uco")) {
      return "https://logo.clearbit.com/ucobank.com";
    } else if (lowerName.contains("bank of india") || lowerName.contains("boi")) {
      return "https://logo.clearbit.com/bankofindia.co.in";
    }
    return null;
  }

  Widget _buildBadgeWidget(String name, String lowerName) {
    Color bgColor;
    Color textColor = Colors.white;
    String badgeText;

    if (lowerName.contains("sbi") || lowerName.contains("state bank")) {
      bgColor = const Color(0xFF002E6D);
      badgeText = "SBI";
    } else if (lowerName.contains("axis")) {
      bgColor = const Color(0xFF97144D);
      badgeText = "AXIS";
    } else if (lowerName.contains("idfc")) {
      bgColor = const Color(0xFF9E1B32);
      badgeText = "IDFC";
    } else if (lowerName.contains("airtel")) {
      bgColor = const Color(0xFFE40000);
      badgeText = "Airtel";
    } else if (lowerName.contains("paytm")) {
      bgColor = const Color(0xFF00BAF2);
      badgeText = "Paytm";
    } else if (lowerName.contains("kotak")) {
      bgColor = const Color(0xFFD61B23);
      badgeText = "KOTAK";
    } else if (lowerName.contains("baroda") || lowerName.contains("bob")) {
      bgColor = const Color(0xFFF26522);
      badgeText = "BOB";
    } else if (lowerName.contains("indusind")) {
      bgColor = const Color(0xFF8B0000);
      badgeText = "INDUS";
    } else if (lowerName.contains("federal")) {
      bgColor = const Color(0xFF003366);
      badgeText = "FED";
    } else if (lowerName.contains("canara")) {
      bgColor = const Color(0xFF0054A6);
      badgeText = "CAN";
    } else if (lowerName.contains("union")) {
      bgColor = const Color(0xFFE31E24);
      badgeText = "UNION";
    } else {
      bgColor = primaryColor;
      List<String> parts = name.trim().split(" ");
      if (parts.length >= 2) {
        badgeText = "${parts[0][0]}${parts[1][0]}".toUpperCase();
      } else if (name.length >= 3) {
        badgeText = name.substring(0, 3).toUpperCase();
      } else {
        badgeText = name.toUpperCase();
      }
    }

    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        badgeText,
        style: TextStyle(
          color: textColor,
          fontSize: badgeText.length > 3 ? 9 : 11,
          fontFamily: FontFamily.plusJakartaSansBold,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
