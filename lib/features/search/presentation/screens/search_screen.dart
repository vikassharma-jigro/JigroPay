import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:jigrotech/core/mixins/debounce_mixin.dart';
import 'package:jigrotech/core/mixins/safe_set_state_mixin.dart';
import 'package:jigrotech/core/mixins/ui_feedback_mixin.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

class SearchServiceItem {
  final String title;
  final String category;
  final IconData icon;
  final String routePath;
  final Map<String, String>? routeExtra;

  SearchServiceItem({
    required this.title,
    required this.category,
    required this.icon,
    required this.routePath,
    this.routeExtra,
  });
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with DebounceMixin, UiFeedbackMixin, SafeSetStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _selectedCategory = "All";
  String _searchQuery = "";

  //. Search Debouncer
  void _onSearchChanged(String query) {
    debounce(() {
      safeSetState(() => _searchQuery = query);
    });
  }

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
      routePath: '/mobile-recharge',
    ),
    SearchServiceItem(
      title: "DTH Recharge",
      category: "Recharge & Bills",
      icon: IconsaxPlusLinear.monitor,
      routePath: '/bill-payment',
      routeExtra: {
        'serviceType': 'dth',
        'title': 'DTH Recharge',
        'accountNumberLabel': 'Subscriber ID / VC Number',
        'accountNumberHint': 'Enter Subscriber ID',
      },
    ),
    SearchServiceItem(
      title: "FASTag Recharge",
      category: "Recharge & Bills",
      icon: IconsaxPlusLinear.car,
      routePath: '/bill-payment',
      routeExtra: {
        'serviceType': 'fastag',
        'title': 'FASTag Recharge',
        'accountNumberLabel': 'Vehicle Number',
        'accountNumberHint': 'Enter Vehicle Number (e.g. DL01AB1234)',
      },
    ),
    SearchServiceItem(
      title: "Electricity Bill",
      category: "Recharge & Bills",
      icon: IconsaxPlusLinear.bill,
      routePath: '/bill-payment',
      routeExtra: {
        'serviceType': 'electricity',
        'title': 'Electricity Bill',
        'accountNumberLabel': 'Consumer Number / K-No',
        'accountNumberHint': 'Enter Consumer Number',
      },
    ),
    SearchServiceItem(
      title: "Water Bill",
      category: "Recharge & Bills",
      icon: IconsaxPlusLinear.drop,
      routePath: '/bill-payment',
      routeExtra: {
        'serviceType': 'water',
        'title': 'Water Bill',
        'accountNumberLabel': 'RR Number / Consumer ID',
        'accountNumberHint': 'Enter RR Number or Consumer ID',
      },
    ),
    SearchServiceItem(
      title: "Cable TV",
      category: "Recharge & Bills",
      icon: Icons.cable,
      routePath: '/bill-payment',
      routeExtra: {
        'serviceType': 'cable',
        'title': 'Cable TV',
        'accountNumberLabel': 'Account / VC Number',
        'accountNumberHint': 'Enter Account / VC Number',
      },
    ),

    // Utility Bills
    SearchServiceItem(
      title: "Broadband Bill",
      category: "Utility Bills",
      icon: IconsaxPlusLinear.wifi,
      routePath: '/bill-payment',
      routeExtra: {
        'serviceType': 'broadband',
        'title': 'Broadband Bill',
        'accountNumberLabel': 'Telephone / Account Number',
        'accountNumberHint': 'Enter Telephone / Account Number',
      },
    ),
    SearchServiceItem(
      title: "Gas Bill",
      category: "Utility Bills",
      icon: IconsaxPlusLinear.gas_station,
      routePath: '/bill-payment',
      routeExtra: {
        'serviceType': 'gas',
        'title': 'Piped Gas Bill',
        'accountNumberLabel': 'Customer Number',
        'accountNumberHint': 'Enter Customer Number',
      },
    ),
    SearchServiceItem(
      title: "LPG Gas",
      category: "Utility Bills",
      icon: Icons.fire_hydrant_alt,
      routePath: '/bill-payment',
      routeExtra: {
        'serviceType': 'lpg',
        'title': 'LPG Cylinder Booking',
        'accountNumberLabel': 'LPG ID / Registered Mobile Number',
        'accountNumberHint': 'Enter LPG ID or Registered Mobile Number',
      },
    ),

    // Financial Services
    SearchServiceItem(
      title: "Credit Card",
      category: "Financial Services",
      icon: IconsaxPlusLinear.card,
      routePath: '/bill-payment',
      routeExtra: {
        'serviceType': 'credit_card',
        'title': 'Credit Card Bill',
        'accountNumberLabel': 'Credit Card Number',
        'accountNumberHint': 'Enter 16-digit Credit Card Number',
      },
    ),
    SearchServiceItem(
      title: "Loan Repayment",
      category: "Financial Services",
      icon: IconsaxPlusLinear.money,
      routePath: '/bill-payment',
      routeExtra: {
        'serviceType': 'loan',
        'title': 'Loan Repayment',
        'accountNumberLabel': 'Loan Account Number',
        'accountNumberHint': 'Enter Loan Account Number',
      },
    ),
    SearchServiceItem(
      title: "Insurance",
      category: "Financial Services",
      icon: IconsaxPlusLinear.document,
      routePath: '/bill-payment',
      routeExtra: {
        'serviceType': 'insurance',
        'title': 'Insurance Premium',
        'accountNumberLabel': 'Policy Number',
        'accountNumberHint': 'Enter Policy Number',
      },
    ),

    // Other Services
    SearchServiceItem(
      title: "Municipal Taxes",
      category: "Other Services",
      icon: IconsaxPlusLinear.building,
      routePath: '/bill-payment',
      routeExtra: {
        'serviceType': 'municipal_taxes',
        'title': 'Municipal Tax',
        'accountNumberLabel': 'Property Tax / Index Number',
        'accountNumberHint': 'Enter Property Tax Number',
      },
    ),
    SearchServiceItem(
      title: "PAN Services",
      category: "Other Services",
      icon: IconsaxPlusLinear.card,
      routePath: '/pan-services',
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

  void _navigateToService(SearchServiceItem item) {
    if (item.routeExtra != null) {
      context.push(item.routePath, extra: item.routeExtra);
    } else {
      context.push(item.routePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredServices;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.black,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "Search Services",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontFamily: AppTypography.outfitBold,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Input Bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.lightWhite1,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                autofocus: true,
                onChanged: _onSearchChanged,
                onSubmitted: (_) => hideKeyboard(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: const Icon(
                    IconsaxPlusLinear.search_normal,
                    color: AppColors.grey,
                    size: 20,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: AppColors.grey,
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
                  hintText: "Search mobile, DTH, electricity, fastag...",
                  hintStyle: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 14,
                    fontFamily: AppTypography.outfitRegular,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // Filter Category Chips
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? AppColors.white : AppColors.black,
                        fontSize: 13,
                        fontFamily: isSelected
                            ? AppTypography.outfitBold
                            : AppTypography.outfitMedium,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      hideKeyboard();
                      safeSetState(() => _selectedCategory = category);
                    },
                    backgroundColor: AppColors.lightWhite1,
                    selectedColor: AppColors.primary,
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                        width: 1,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Header summary count
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _searchQuery.isEmpty ? "All Services" : "Search Results",
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 15,
                    fontFamily: AppTypography.outfitBold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "${filteredList.length} items",
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                    fontFamily: AppTypography.outfitRegular,
                  ),
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
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "No services found",
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontFamily: AppTypography.outfitBold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Try searching with different keywords",
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 13,
                            fontFamily: AppTypography.outfitRegular,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredList.length,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return GestureDetector(
                        onTap: () => _navigateToService(item),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.border,
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
                                  color: AppColors.lightPink,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  item.icon,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        color: AppColors.black,
                                        fontSize: 14,
                                        fontFamily: AppTypography.outfitBold,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.08,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        item.category,
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 10,
                                          fontFamily:
                                              AppTypography.outfitMedium,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: AppColors.grey,
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
