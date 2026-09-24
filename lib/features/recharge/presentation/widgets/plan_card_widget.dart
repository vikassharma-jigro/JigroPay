import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../data/models/recharge_plan_model.dart';

class PlanCardWidget extends StatelessWidget {
  const PlanCardWidget({
    super.key,
    required this.plan,
    required this.onTap,
  });

  final RechargePlanModel plan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Amount + Tag + Arrow
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  CurrencyFormatter.toINR(plan.amount),
                  style: const TextStyle(
                    fontFamily: AppTypography.outfitBold,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                if (plan.tag != null && plan.tag!.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      plan.tag!,
                      style: const TextStyle(
                        fontFamily: AppTypography.outfitMedium,
                        fontSize: 11,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppColors.grey,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Middle: Highlights (Validity, Data)
            Row(
              children: [
                if (plan.validity != null && plan.validity!.isNotEmpty) ...[
                  _buildPill(
                    icon: Icons.calendar_today_outlined,
                    label: 'Validity: ${plan.validity}',
                  ),
                  const SizedBox(width: 8),
                ],
                if (plan.data != null && plan.data!.isNotEmpty) ...[
                  _buildPill(
                    icon: Icons.data_usage_outlined,
                    label: 'Data: ${plan.data}',
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),

            // Bottom: Description
            Text(
              plan.description,
              style: const TextStyle(
                fontFamily: AppTypography.outfitRegular,
                fontSize: 13,
                color: AppColors.grey,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPill({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: AppTypography.outfitMedium,
              fontSize: 11,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
