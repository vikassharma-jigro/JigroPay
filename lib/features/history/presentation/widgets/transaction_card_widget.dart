import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../data/models/transaction_model.dart';

class TransactionCardWidget extends StatelessWidget {
  const TransactionCardWidget({
    super.key,
    required this.transaction,
    this.onTap,
  });

  final TransactionModel transaction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (statusColor, statusBg, statusIcon, statusLabel) = _statusStyle();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Category / Status Icon Avatar
            _buildCategoryIcon(statusBg, statusColor, statusIcon),
            const SizedBox(width: 12),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.operator?.isNotEmpty == true
                        ? transaction.operator!
                        : (transaction.type?.toUpperCase() ?? 'TRANSACTION'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: AppTypography.outfitBold,
                      fontSize: 14,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    transaction.number?.isNotEmpty == true
                        ? transaction.number!
                        : (transaction.orderId ?? ''),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: AppTypography.outfitRegular,
                      fontSize: 12,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    DateFormatter.toDisplayDateTime(transaction.createdAt),
                    style: const TextStyle(
                      fontFamily: AppTypography.outfitRegular,
                      fontSize: 11,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
            ),

            // Amount & Status Badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatter.format(transaction.amount),
                  style: const TextStyle(
                    fontFamily: AppTypography.outfitBold,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: AppTypography.outfitMedium,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(
    Color statusBg,
    Color statusColor,
    IconData statusIcon,
  ) {
    final iconUrl = transaction.displayIconUrl;
    final fallback = Icon(statusIcon, color: statusColor, size: 22);

    if (iconUrl.isEmpty) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(color: statusBg, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: fallback,
      );
    }

    final isSvg = iconUrl.toLowerCase().endsWith('.svg');
    final isNetwork =
        iconUrl.startsWith('http://') || iconUrl.startsWith('https://');
    final isAsset = iconUrl.startsWith('assets/');

    Widget imageWidget;

    if (isNetwork) {
      imageWidget = isSvg
          ? SvgPicture.network(
              iconUrl,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
              placeholderBuilder: (_) => fallback,
            )
          : Image.network(
              iconUrl,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => fallback,
            );
    } else if (isAsset) {
      imageWidget = isSvg
          ? SvgPicture.asset(
              iconUrl,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            )
          : Image.asset(
              iconUrl,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => fallback,
            );
    } else {
      imageWidget = fallback;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(shape: BoxShape.circle),
      alignment: Alignment.center,
      child: ClipOval(
        clipBehavior: Clip.none,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Center(child: imageWidget),
        ),
      ),
    );
  }

  (Color, Color, IconData, String) _statusStyle() {
    if (transaction.isSuccess) {
      return (
        AppColors.success,
        AppColors.lightSuccess,
        Icons.check_circle_rounded,
        'Success',
      );
    }
    if (transaction.isPending) {
      return (
        AppColors.warning,
        AppColors.lightWarning,
        Icons.access_time_filled_rounded,
        'Pending',
      );
    }
    return (
      AppColors.errorBright,
      AppColors.lightError,
      Icons.cancel_rounded,
      'Failed',
    );
  }
}
