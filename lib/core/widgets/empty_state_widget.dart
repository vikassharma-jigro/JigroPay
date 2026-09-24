import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import 'app_button.dart';

/// Full-page empty state widget — shown when a list has no items.
///
/// Usage:
/// ```dart
/// EmptyStateWidget(
///   icon: Icons.receipt_long_outlined,
///   title: 'No Transactions',
///   subtitle: 'Your payment history will appear here.',
/// )
/// ```
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    this.icon,
    this.svgAsset,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.iconSize = 72,
    this.iconColor,
    this.padding,
  }) : assert(
          icon != null || svgAsset != null,
          'Provide either icon or svgAsset.',
        );

  final IconData? icon;

  /// Optional SVG asset path for a richer illustration.
  final String? svgAsset;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final double iconSize;
  final Color? iconColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon / Illustration
            Container(
              width: iconSize + 32,
              height: iconSize + 32,
              decoration: BoxDecoration(
                color: AppColors.lightWhite1,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                icon ?? Icons.inbox_outlined,
                size: iconSize,
                color: iconColor ?? AppColors.primary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.h3.copyWith(color: AppColors.black),
            ),

            // Subtitle
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: AppTypography.body1,
              ),
            ],

            // Action button
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 28),
              AppButton(
                label: actionLabel!,
                onPressed: onAction,
                width: 160,
                height: 44,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
