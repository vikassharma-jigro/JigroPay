import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import 'app_button.dart';

/// Semi-transparent full-screen loading overlay.
///
/// Wrap your screen's body with this widget during async operations:
/// ```dart
/// LoadingOverlay(
///   isLoading: state is BillFetching,
///   child: YourScreenBody(),
/// )
/// ```
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.barrierColor,
  });

  final bool isLoading;
  final Widget child;

  /// Optional status message shown below the spinner.
  final String? message;
  final Color? barrierColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: _Barrier(
              color: barrierColor ?? Colors.black.withValues(alpha: 0.45),
              message: message,
            ),
          ),
      ],
    );
  }
}

/// Inline circular progress indicator with optional label.
/// Use inside a list tile or card to show item-level loading.
class InlineLoader extends StatelessWidget {
  const InlineLoader({
    super.key,
    this.size = 24,
    this.strokeWidth = 2.5,
    this.color,
    this.label,
  });

  final double size;
  final double strokeWidth;
  final Color? color;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator.adaptive(
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? AppColors.primary,
            ),
          ),
        ),
        if (label != null) ...[
          const SizedBox(width: 10),
          Text(label!, style: AppTypography.body2),
        ],
      ],
    );
  }
}

/// Full-page centered loader — shown on first-load of a screen.
class PageLoader extends StatelessWidget {
  const PageLoader({super.key, this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator.adaptive(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: AppTypography.body2,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

// ── Private ────────────────────────────────────────────────────────────────────

class _Barrier extends StatelessWidget {
  const _Barrier({required this.color, this.message});
  final Color color;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 44,
                    height: 44,
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                  if (message != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      message!,
                      style: AppTypography.body2,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full-page error state — used by Cubit error states.
class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.title,
    this.icon,
    this.padding,
  });

  final String message;
  final VoidCallback? onRetry;
  final String? title;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.lightError,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.errorBright.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                icon ?? Icons.error_outline_rounded,
                size: 40,
                color: AppColors.errorBright,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: AppTypography.h3,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.body1,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 28),
              AppButton(
                label: 'Try Again',
                onPressed: onRetry,
                width: 140,
                height: 44,
                icon: Icons.refresh_rounded,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
