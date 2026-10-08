import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.width,
    this.height = 52,
    this.borderRadius = 14,
    // this.gradient,
    this.textStyle,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final IconData? icon;
  final double? width;
  final double height;
  final double borderRadius;
  // final Gradient? gradient;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    // final effectiveGradient = (!isEnabled || isLoading)
    //     ? const LinearGradient(colors: [Color(0xffb0b0b0), Color(0xff909090)])
    //     : (gradient ?? AppColors.brandGradient);

    return AnimatedOpacity(
      opacity: (!isEnabled) ? 0.6 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            // gradient: effectiveGradient,
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: (!isEnabled || isLoading)
                ? []
                : [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(borderRadius),
            child: InkWell(
              borderRadius: BorderRadius.circular(borderRadius),
              onTap: (isEnabled && !isLoading) ? onPressed : null,
              splashColor: Colors.white.withValues(alpha: 0.15),
              highlightColor: Colors.white.withValues(alpha: 0.08),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.white,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (icon != null) ...[
                            Icon(icon, color: AppColors.white, size: 18),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            label,
                            style: textStyle ?? AppTypography.buttonLarge,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Outlined secondary button (no gradient fill).
class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.width,
    this.height = 52,
    this.borderRadius = 14,
    this.color,
    this.textStyle,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final IconData? icon;
  final double? width;
  final double height;
  final double borderRadius;
  final Color? color;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: effectiveColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: (isEnabled && !isLoading) ? onPressed : null,
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator.adaptive(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: effectiveColor, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: (textStyle ?? AppTypography.buttonLarge).copyWith(
                      color: effectiveColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Small compact chip-style button (e.g. plan quick-select, filter chips).
class AppChipButton extends StatelessWidget {
  const AppChipButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isSelected = false,
    this.icon,
    this.padding,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isSelected;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.brandGradient : null,
          color: isSelected ? null : AppColors.lightGrey,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(color: AppColors.lightGrey, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: isSelected ? AppColors.white : AppColors.grey,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: AppTypography.label.copyWith(
                color: isSelected ? AppColors.white : AppColors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
