import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/models/recharge_plan_model.dart';

class PlanDetailsBottomSheet extends StatelessWidget {
  const PlanDetailsBottomSheet({
    super.key,
    required this.plan,
    required this.onProceedToPay,
  });

  final RechargePlanModel plan;
  final VoidCallback onProceedToPay;

  static Future<void> show({
    required BuildContext context,
    required RechargePlanModel plan,
    required VoidCallback onProceedToPay,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => PlanDetailsBottomSheet(
        plan: plan,
        onProceedToPay: onProceedToPay,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle & Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${CurrencyFormatter.toINR(plan.amount)} Plan Details',
                    style: const TextStyle(
                      fontFamily: AppTypography.outfitBold,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Highlights
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMetric(
                      title: 'Validity',
                      value: plan.validity ?? 'N/A',
                      icon: Icons.calendar_today_outlined,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMetric(
                      title: 'Data',
                      value: plan.data ?? 'N/A',
                      icon: Icons.data_usage_outlined,
                    ),
                  ),
                ],
              ),
            ),

            // Benefits Description
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Plan Benefits & Description',
                      style: TextStyle(
                        fontFamily: AppTypography.outfitBold,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      plan.description,
                      style: const TextStyle(
                        fontFamily: AppTypography.outfitRegular,
                        fontSize: 14,
                        color: AppColors.text,
                        height: 1.4,
                      ),
                    ),
                    if (plan.talktime != null && plan.talktime!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.phone_outlined,
                              size: 16, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            'Talktime: ${plan.talktime}',
                            style: const TextStyle(
                              fontFamily: AppTypography.outfitMedium,
                              fontSize: 13,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Proceed Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: AppButton(
                label: 'Proceed to Pay ${CurrencyFormatter.toINR(plan.amount)}',
                onPressed: () {
                  Navigator.pop(context);
                  onProceedToPay();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.grey,
                  fontFamily: AppTypography.outfitRegular,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: AppTypography.outfitBold,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
