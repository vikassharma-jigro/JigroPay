import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

class ServiceItem {
  const ServiceItem({
    required this.title,
    required this.iconPath,
    required this.onTap,
    this.iconHeight = 32,
    this.iconWidth,
    this.tintColor,
  });

  final String title;
  final String iconPath;
  final VoidCallback onTap;
  final double iconHeight;
  final double? iconWidth;
  final Color? tintColor;
}

class ServiceCategoriesWidget extends StatelessWidget {
  const ServiceCategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ServiceItem> row1 = [
      ServiceItem(
        title: 'Mobile\nRecharge',
        iconPath: AppAssets.mobileRecharge,
        iconHeight: 32,
        onTap: () => context.push('/mobile-recharge'),
      ),
      ServiceItem(
        title: 'Postpaid\nBill',
        iconPath: AppAssets.mobileRecharge,
        iconHeight: 32,
        onTap: () => context.push(
          '/bill-payment',
          extra: {
            'serviceType': 'postpaid',
            'title': 'Postpaid Mobile Bill',
            'accountNumberLabel': 'Mobile Number',
            'accountNumberHint': 'Enter 10-digit mobile number',
          },
        ),
      ),
      ServiceItem(
        title: 'Electricity\nBill',
        iconPath: AppAssets.electricity,
        iconHeight: 32,
        onTap: () => context.push(
          '/bill-payment',
          extra: {
            'serviceType': 'electricity',
            'title': 'Electricity Bill',
            'accountNumberLabel': 'Consumer Number (CA Number)',
            'accountNumberHint': 'Enter consumer / account number',
          },
        ),
      ),
      ServiceItem(
        title: 'DTH\nRecharge',
        iconPath: AppAssets.dthRecharge,
        iconHeight: 32,
        iconWidth: 32,
        onTap: () => context.push(
          '/bill-payment',
          extra: {
            'serviceType': 'dth',
            'title': 'DTH Recharge',
            'accountNumberLabel': 'Subscriber / Smart Card ID',
            'accountNumberHint': 'Enter subscriber or smart card ID',
          },
        ),
      ),
    ];

    final List<ServiceItem> row2 = [
      ServiceItem(
        title: 'Water\nBill',
        iconPath: AppAssets.water,
        iconHeight: 32,
        iconWidth: 32,
        onTap: () => context.push(
          '/bill-payment',
          extra: {
            'serviceType': 'water_bill',
            'title': 'Water Bill',
            'accountNumberLabel': 'Consumer / Connection ID',
            'accountNumberHint': 'Enter connection or account number',
          },
        ),
      ),
      ServiceItem(
        title: 'Broadband\nBill',
        iconPath: AppAssets.broadband,
        iconHeight: 32,
        iconWidth: 32,
        onTap: () => context.push(
          '/bill-payment',
          extra: {
            'serviceType': 'broadband',
            'title': 'Broadband Bill',
            'accountNumberLabel': 'Account Number / User ID',
            'accountNumberHint': 'Enter account or user ID',
          },
        ),
      ),
      ServiceItem(
        title: 'LPG Gas\nBooking',
        iconPath: AppAssets.lpgGas,
        iconHeight: 32,
        onTap: () => context.push(
          '/bill-payment',
          extra: {
            'serviceType': 'gas',
            'title': 'LPG Gas Booking',
            'accountNumberLabel': 'Customer / BP Number',
            'accountNumberHint': 'Enter customer ID / BP number',
          },
        ),
      ),
      ServiceItem(
        title: 'FASTag\nRecharge',
        iconPath: AppAssets.fastTag,
        iconHeight: 32,
        iconWidth: 32,
        onTap: () => context.push(
          '/bill-payment',
          extra: {
            'serviceType': 'fastag',
            'title': 'FASTag Recharge',
            'accountNumberLabel': 'Vehicle Registration Number',
            'accountNumberHint': 'e.g. MH01AB1234',
          },
        ),
      ),
    ];

    final List<ServiceItem> financialServices = [
      ServiceItem(
        title: 'Loan\nRepayment',
        iconPath: AppAssets.loanRepayment,
        iconHeight: 32,
        iconWidth: 32,
        onTap: () => context.push(
          '/bill-payment',
          extra: {
            'serviceType': 'loan',
            'title': 'Loan Repayment',
            'accountNumberLabel': 'Loan Account Number',
            'accountNumberHint': 'Enter loan account number',
          },
        ),
      ),
      ServiceItem(
        title: 'Insurance\nPremium',
        iconPath: AppAssets.insurance,
        iconHeight: 32,
        iconWidth: 32,
        onTap: () => context.push(
          '/bill-payment',
          extra: {
            'serviceType': 'insurance',
            'title': 'Insurance Premium',
            'accountNumberLabel': 'Policy Number',
            'accountNumberHint': 'Enter insurance policy number',
          },
        ),
      ),
      ServiceItem(
        title: 'Credit Card\nBill',
        iconPath: AppAssets.creditCard,
        iconHeight: 32,
        iconWidth: 32,
        tintColor: const Color(0xFFEC4899),
        onTap: () => context.push(
          '/bill-payment',
          extra: {
            'serviceType': 'credit_card',
            'title': 'Credit Card Bill',
            'accountNumberLabel': 'Last 4 Digits of Card',
            'accountNumberHint': 'Enter last 4 digits of credit card',
          },
        ),
      ),
    ];

    final List<ServiceItem> moreServices = [
      ServiceItem(
        title: 'Postpaid\nBill',
        iconPath: AppAssets.mobileRecharge,
        iconHeight: 32,
        onTap: () => context.push(
          '/bill-payment',
          extra: {
            'serviceType': 'postpaid',
            'title': 'Postpaid Mobile Bill',
            'accountNumberLabel': 'Mobile Number',
            'accountNumberHint': 'Enter 10-digit mobile number',
          },
        ),
      ),
      ServiceItem(
        title: 'Cable\nTV',
        iconPath: AppAssets.cableTv,
        iconHeight: 32,
        iconWidth: 32,
        onTap: () => context.push(
          '/bill-payment',
          extra: {
            'serviceType': 'cable',
            'title': 'Cable TV Bill',
            'accountNumberLabel': 'Account / MAC Number',
            'accountNumberHint': 'Enter subscriber account number',
          },
        ),
      ),
      ServiceItem(
        title: 'Municipal\nTaxes',
        iconPath: AppAssets.muncipal,
        iconHeight: 32,
        iconWidth: 32,
        onTap: () => context.push(
          '/bill-payment',
          extra: {
            'serviceType': 'municipal_taxes',
            'title': 'Municipal Taxes',
            'accountNumberLabel': 'Tenement No / Property ID',
            'accountNumberHint': 'Enter tenement no or property ID',
          },
        ),
      ),
      ServiceItem(
        title: 'PAN\nServices',
        iconPath: AppAssets.pan,
        iconHeight: 32,
        iconWidth: 32,
        onTap: () => context.push('/pan-services'),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Primary "Recharge & Bills" Card (as per exact design)
        _buildContainerCard(
          title: 'Recharge & Bills',
          actionText: 'View All',
          onActionTap: () => _showAllServicesBottomSheet(context),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildGridItem(row1[0])),
                    Expanded(child: _buildGridItem(row1[1])),
                    Expanded(child: _buildGridItem(row1[2])),
                    Expanded(child: _buildGridItem(row1[3])),
                  ],
                ),
              ),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildGridItem(row2[0])),
                    Expanded(child: _buildGridItem(row2[1])),
                    Expanded(child: _buildGridItem(row2[2])),
                    Expanded(child: _buildGridItem(row2[3])),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 2. Financial Services Card
        _buildContainerCard(
          title: 'Financial Services',
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildGridItem(financialServices[0])),
                Expanded(child: _buildGridItem(financialServices[1])),
                Expanded(child: _buildGridItem(financialServices[2])),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 3. More Services & Utilities Card
        _buildContainerCard(
          title: 'Other Services',
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildGridItem(moreServices[2])),
                Expanded(child: _buildGridItem(moreServices[3])),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContainerCard({
    required String title,
    String? actionText,
    VoidCallback? onActionTap,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: AppTypography.outfitBold,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111111),
                  ),
                ),
                if (actionText != null && onActionTap != null)
                  InkWell(
                    onTap: onActionTap,
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      child: Text(
                        actionText,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: AppTypography.outfitMedium,
                          fontWeight: FontWeight.w600,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  // Widget _buildUniformVerticalDivider() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 6),
  //     child: Container(width: 1, color: const Color(0xFFE6E6E6)),
  //   );
  // }

  // Widget _buildVerticalDivider({required bool isRow1}) {
  //   return Padding(
  //     padding: EdgeInsets.only(top: isRow1 ? 40 : 4, bottom: 4),
  //     child: Container(width: 1, color: const Color(0xFFE6E6E6)),
  //   );
  // }

  Widget _buildGridItem(ServiceItem item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 68,
              width: 68,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.lightGrey, width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: SvgPicture.asset(
                    item.iconPath,
                    height: item.iconHeight,
                    width: item.iconWidth,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: AppTypography.outfitMedium,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A1A),
                height: 1.22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAllServicesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Top drag bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Sheet Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'All Services',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: AppTypography.outfitBold,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.grey),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.lightGrey),
              // Service List
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  children: [
                    _buildSheetCategory(
                      ctx,
                      title: 'Recharge & Bill Pay',
                      items: [
                        ServiceItem(
                          title: 'Mobile\nRecharge',
                          iconPath: AppAssets.mobileRecharge,
                          iconHeight: 38,
                          onTap: () {
                            Navigator.pop(ctx);
                            context.push('/mobile-recharge');
                          },
                        ),
                        ServiceItem(
                          title: 'DTH\nRecharge',
                          iconPath: AppAssets.dthRecharge,
                          iconHeight: 38,
                          onTap: () {
                            Navigator.pop(ctx);
                            context.push(
                              '/bill-payment',
                              extra: {
                                'serviceType': 'dth',
                                'title': 'DTH Recharge',
                                'accountNumberLabel':
                                    'Subscriber / Smart Card ID',
                                'accountNumberHint':
                                    'Enter subscriber or smart card ID',
                              },
                            );
                          },
                        ),
                        ServiceItem(
                          title: 'FASTag\nRecharge',
                          iconPath: AppAssets.fastTag,
                          iconHeight: 32,
                          onTap: () {
                            Navigator.pop(ctx);
                            context.push(
                              '/bill-payment',
                              extra: {
                                'serviceType': 'fastag',
                                'title': 'FASTag Recharge',
                                'accountNumberLabel':
                                    'Vehicle Registration Number',
                                'accountNumberHint': 'e.g. MH01AB1234',
                              },
                            );
                          },
                        ),
                        ServiceItem(
                          title: 'Postpaid\nBill',
                          iconPath: AppAssets.mobileRecharge,
                          iconHeight: 38,
                          onTap: () {
                            Navigator.pop(ctx);
                            context.push(
                              '/bill-payment',
                              extra: {
                                'serviceType': 'postpaid',
                                'title': 'Postpaid Mobile Bill',
                                'accountNumberLabel': 'Mobile Number',
                                'accountNumberHint':
                                    'Enter 10-digit mobile number',
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSheetCategory(
                      ctx,
                      title: 'Utilities & Home Bills',
                      items: [
                        ServiceItem(
                          title: 'Electricity\nBill',
                          iconPath: AppAssets.electricity,
                          iconHeight: 38,
                          onTap: () {
                            Navigator.pop(ctx);
                            context.push(
                              '/bill-payment',
                              extra: {
                                'serviceType': 'electricity',
                                'title': 'Electricity Bill',
                                'accountNumberLabel':
                                    'Consumer Number (CA Number)',
                                'accountNumberHint':
                                    'Enter consumer / account number',
                              },
                            );
                          },
                        ),
                        ServiceItem(
                          title: 'Water\nBill',
                          iconPath: AppAssets.water,
                          iconHeight: 36,
                          onTap: () {
                            Navigator.pop(ctx);
                            context.push(
                              '/bill-payment',
                              extra: {
                                'serviceType': 'water_bill',
                                'title': 'Water Bill',
                                'accountNumberLabel':
                                    'Consumer / Connection ID',
                                'accountNumberHint':
                                    'Enter connection or account number',
                              },
                            );
                          },
                        ),
                        ServiceItem(
                          title: 'LPG Gas\nBooking',
                          iconPath: AppAssets.lpgGas,
                          iconHeight: 38,
                          onTap: () {
                            Navigator.pop(ctx);
                            context.push(
                              '/bill-payment',
                              extra: {
                                'serviceType': 'gas',
                                'title': 'LPG Gas Booking',
                                'accountNumberLabel': 'Customer / BP Number',
                                'accountNumberHint':
                                    'Enter customer ID / BP number',
                              },
                            );
                          },
                        ),
                        ServiceItem(
                          title: 'Broadband\nInternet',
                          iconPath: AppAssets.broadband,
                          iconHeight: 36,
                          onTap: () {
                            Navigator.pop(ctx);
                            context.push(
                              '/bill-payment',
                              extra: {
                                'serviceType': 'broadband',
                                'title': 'Broadband Bill',
                                'accountNumberLabel':
                                    'Account Number / User ID',
                                'accountNumberHint': 'Enter account or user ID',
                              },
                            );
                          },
                        ),
                        ServiceItem(
                          title: 'Cable\nTV',
                          iconPath: AppAssets.cableTv,
                          iconHeight: 36,
                          onTap: () {
                            Navigator.pop(ctx);
                            context.push(
                              '/bill-payment',
                              extra: {
                                'serviceType': 'cable',
                                'title': 'Cable TV Bill',
                                'accountNumberLabel': 'Account / MAC Number',
                                'accountNumberHint':
                                    'Enter subscriber account number',
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSheetCategory(
                      ctx,
                      title: 'Financial & Banking',
                      items: [
                        ServiceItem(
                          title: 'Credit\nCard',
                          iconPath: AppAssets.creditCard,
                          iconHeight: 32,
                          tintColor: const Color(0xFFEC4899),
                          onTap: () {
                            Navigator.pop(ctx);
                            context.push(
                              '/bill-payment',
                              extra: {
                                'serviceType': 'credit_card',
                                'title': 'Credit Card Bill',
                                'accountNumberLabel': 'Last 4 Digits of Card',
                                'accountNumberHint':
                                    'Enter last 4 digits of credit card',
                              },
                            );
                          },
                        ),
                        ServiceItem(
                          title: 'Loan\nRepayment',
                          iconPath: AppAssets.loanRepayment,
                          iconHeight: 38,
                          onTap: () {
                            Navigator.pop(ctx);
                            context.push(
                              '/bill-payment',
                              extra: {
                                'serviceType': 'loan',
                                'title': 'Loan Repayment',
                                'accountNumberLabel': 'Loan Account Number',
                                'accountNumberHint':
                                    'Enter loan account number',
                              },
                            );
                          },
                        ),
                        ServiceItem(
                          title: 'Insurance\nPremium',
                          iconPath: AppAssets.insurance,
                          iconHeight: 38,
                          onTap: () {
                            Navigator.pop(ctx);
                            context.push(
                              '/bill-payment',
                              extra: {
                                'serviceType': 'insurance',
                                'title': 'Insurance Premium',
                                'accountNumberLabel': 'Policy Number',
                                'accountNumberHint':
                                    'Enter insurance policy number',
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSheetCategory(
                      ctx,
                      title: 'Government & Other Services',
                      items: [
                        ServiceItem(
                          title: 'Municipal\nTaxes',
                          iconPath: AppAssets.muncipal,
                          iconHeight: 38,
                          onTap: () {
                            Navigator.pop(ctx);
                            context.push(
                              '/bill-payment',
                              extra: {
                                'serviceType': 'municipal_taxes',
                                'title': 'Municipal Taxes',
                                'accountNumberLabel':
                                    'Tenement No / Property ID',
                                'accountNumberHint':
                                    'Enter tenement no or property ID',
                              },
                            );
                          },
                        ),
                        ServiceItem(
                          title: 'PAN\nServices',
                          iconPath: AppAssets.pan,
                          iconHeight: 38,
                          onTap: () {
                            Navigator.pop(ctx);
                            context.push('/pan-services');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSheetCategory(
    BuildContext context, {
    required String title,
    required List<ServiceItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontFamily: AppTypography.outfitBold,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: items.map((item) {
            return SizedBox(
              width: 78,
              child: InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 4,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 40,
                        child: Center(
                          child: SvgPicture.asset(
                            item.iconPath,
                            height: item.iconHeight,
                            width: item.iconWidth,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 11,
                          fontFamily: AppTypography.outfitMedium,
                          color: AppColors.text,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
