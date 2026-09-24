import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../data/models/operator_model.dart';

class OperatorHeaderWidget extends StatelessWidget {
  const OperatorHeaderWidget({
    super.key,
    required this.mobileNumber,
    required this.operator,
    this.contactName,
    this.onChangeOperator,
  });

  final String mobileNumber;
  final OperatorModel operator;
  final String? contactName;
  final VoidCallback? onChangeOperator;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Operator Logo or Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.light,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipOval(
              child: operator.imageUrl != null && operator.imageUrl!.isNotEmpty
                  ? Image.network(
                      operator.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.signal_cellular_alt,
                        color: AppColors.primary,
                      ),
                    )
                  : const Icon(
                      Icons.signal_cellular_alt,
                      color: AppColors.primary,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (contactName != null && contactName!.trim().isNotEmpty)
                  Text(
                    contactName!,
                    style: const TextStyle(
                      fontFamily: AppTypography.outfitBold,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppColors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                Text(
                  '+91 $mobileNumber',
                  style: TextStyle(
                    fontFamily: AppTypography.outfitMedium,
                    fontSize: contactName != null ? 13 : 15,
                    color: contactName != null ? AppColors.grey : AppColors.black,
                    fontWeight: contactName != null ? FontWeight.normal : FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${operator.name}${operator.circle != null ? ' • ${operator.circle}' : ''}',
                  style: const TextStyle(
                    fontFamily: AppTypography.outfitRegular,
                    fontSize: 12,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (onChangeOperator != null)
            TextButton(
              onPressed: onChangeOperator,
              child: const Text(
                'Change',
                style: TextStyle(
                  color: AppColors.primary,
                  fontFamily: AppTypography.outfitMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
