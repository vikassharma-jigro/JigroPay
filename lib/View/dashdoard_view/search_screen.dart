import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/font_family.dart';
import '../../app_utils/text_widget.dart';
import '../bank_view/mobile_recharge_screen/mobile_recharge_number_screen.dart';
import '../broadband_view/broadband_service_screen.dart';
import '../cable_view/cable_service_screen.dart';
import '../credit_card_view/credit_card_services_screen.dart';
import '../dth_view/dth_service_screen.dart';
import '../electricity_bill/electricity_bill_service_screen.dart';
import '../fast_tag_view/fast_tag_screen.dart';
import '../gas_view/gas_services_screen.dart';
import '../gas_view/piped_gas_services_screen.dart';
import '../insurance_view/insurance_provider_screen.dart';
import '../loan_repayment_view/loan_repayment_screen.dart';
import '../municipal_view/municipal_screen.dart';
import '../water_view/water_service_screen.dart';
import 'generic_service_form_screen.dart';

class SearchServiceItem {
  final String title;
  final String category;
  final IconData icon;

  SearchServiceItem({
    required this.title,
    required this.category,
    required this.icon,
  });
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _selectedCategory = "All";
  String _searchQuery = "";

  final List<String> _categories = [
    "All",
    "Recharge & Bills",
    "Utility Bills",
    "Financial Services",
    "Other Services",
  ];

  final List<SearchServiceItem> _allServices = [
    // Recharge & Bills
    SearchServiceItem(
      title: "Mobile Recharge",
      category: "Recharge & Bills",
      icon: IconsaxPlusLinear.mobile,
    ),
    SearchServiceItem(
      title: "DTH Recharge",
      category: "Recharge & Bills",
      icon: IconsaxPlusLinear.monitor,
    ),
    SearchServiceItem(
      title: "FASTag Recharge",
      category: "Recharge & Bills",
      icon: IconsaxPlusLinear.car,
    ),
    SearchServiceItem(
      title: "Electricity Bill",
      category: "Recharge & Bills",
      icon: IconsaxPlusLinear.bill,
    ),
    SearchServiceItem(
      title: "Water Bill",
      category: "Recharge & Bills",
      icon: IconsaxPlusLinear.drop,
    ),
    SearchServiceItem(
      title: "Cable TV",
      category: "Recharge & Bills",
      icon: Icons.cable,
    ),

    // Utility Bills
    SearchServiceItem(
      title: "Broadband Bill",
      category: "Utility Bills",
      icon: IconsaxPlusLinear.wifi,
    ),
    SearchServiceItem(
      title: "Gas Bill",
      category: "Utility Bills",
      icon: IconsaxPlusLinear.gas_station,
    ),
    SearchServiceItem(
      title: "LPG Gas",
      category: "Utility Bills",
      icon: Icons.fire_hydrant_alt,
    ),

    // Financial Services
    SearchServiceItem(
      title: "Credit Card",
      category: "Financial Services",
      icon: IconsaxPlusLinear.card,
    ),
    SearchServiceItem(
      title: "Loan Repayment",
      category: "Financial Services",
      icon: IconsaxPlusLinear.money,
    ),
    SearchServiceItem(
      title: "Insurance",
      category: "Financial Services",
      icon: IconsaxPlusLinear.document,
    ),

    // Other Services
    SearchServiceItem(
      title: "Municipal Taxes",
      category: "Other Services",
      icon: IconsaxPlusLinear.building,
    ),
    SearchServiceItem(
      title: "PAN Services",
      category: "Other Services",
      icon: IconsaxPlusLinear.card,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<SearchServiceItem> get _filteredServices {
    return _allServices.where((item) {
      final matchesCategory =
          _selectedCategory == "All" || item.category == _selectedCategory;
      final matchesQuery =
          _searchQuery.isEmpty ||
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.category.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void _navigateToService(BuildContext context, String title) {
    String cleanTitle = title.replaceAll('\n', ' ').trim();
    switch (cleanTitle) {
      case "Mobile Recharge":
      case "Postpaid Bill":
        Get.to(() => const MobileRechargeNumberScreen());
        break;
      case "DTH Recharge":
      case "DTH":
        Get.to(() => const DthServiceScreen());
        break;
      case "FASTag Recharge":
      case "FASTag":
        Get.to(() => const FastTagScreen());
        break;
      case "Electricity Bill":
        Get.to(() => const ElectricityBillServiceScreen());
        break;
      case "Water Bill":
        Get.to(() => const WaterServiceScreen());
        break;
      case "Gas Bill":
        Get.to(() => GasServicesScreen());
        break;
      case "LPG Gas":
        Get.to(() => const PipedGasServicesScreen());
        break;
      case "Broadband Bill":
        Get.to(() => const BroadbandServiceScreen());
        break;
      case "Cable TV":
        Get.to(() => const CableServiceScreen());
        break;
      case "Credit Card":
        Get.to(() => const CreditCardServicesScreen());
        break;
      case "Loan Repayment":
        Get.to(() => const LoanRepaymentScreen());
        break;
      case "Insurance":
        Get.to(() => const InsuranceProviderScreen());
        break;
      case "Municipal Taxes":
        Get.to(() => const MunicipalServiceScreen());
        break;
      default:
        Get.to(() => GenericServiceFormScreen(title: cleanTitle));
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredServices;

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: blackColor,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 0),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: lightWhite1Color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: lightGreyColor, width: 1),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              autofocus: true,
              style: const TextStyle(
                color: blackColor,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansMedium,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search services (e.g. Mobile, Gas)...",
                hintStyle: TextStyle(
                  color: greyColor,
                  fontSize: 13,
                  fontFamily: FontFamily.plusJakartaSansRegular,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: primaryColor,
                  size: 22,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: greyColor,
                          size: 18,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = "";
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          // Category Chips Horizontal Scroll
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? white : blackColor,
                        fontSize: 12,
                        fontFamily: isSelected
                            ? FontFamily.plusJakartaSansBold
                            : FontFamily.plusJakartaSansMedium,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: lightWhite1Color,
                    selectedColor: primaryColor,
                    checkmarkColor: white,
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? primaryColor : lightGreyColor,
                        width: 1,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text(
                  _searchQuery.isEmpty ? "All Services" : "Search Results",
                  textColor: blackColor,
                  fontSize: 15,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w600,
                ),
                text(
                  "${filteredList.length} items",
                  textColor: greyColor,
                  fontSize: 12,
                  fontFamily: FontFamily.plusJakartaSansRegular,
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Services List
          Expanded(
            child: filteredList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        text(
                          "No services found",
                          textColor: blackColor,
                          fontSize: 16,
                          fontFamily: FontFamily.plusJakartaSansBold,
                        ),
                        const SizedBox(height: 6),
                        text(
                          "Try searching with different keywords",
                          textColor: greyColor,
                          fontSize: 13,
                          fontFamily: FontFamily.plusJakartaSansRegular,
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredList.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return GestureDetector(
                        onTap: () => _navigateToService(context, item.title),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: lightGreyColor,
                              width: 0.8,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 4,
                                spreadRadius: 0.5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: lightPink1Color,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(item.icon, color: blackColor),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    text(
                                      item.title,
                                      textColor: blackColor,
                                      fontSize: 14,
                                      fontFamily:
                                          FontFamily.plusJakartaSansBold,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    const SizedBox(height: 2),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: primaryColor.withValues(
                                          alpha: 0.08,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        item.category,
                                        style: const TextStyle(
                                          color: primaryColor,
                                          fontSize: 10,
                                          fontFamily:
                                              FontFamily.plusJakartaSansMedium,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: greyColor,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
