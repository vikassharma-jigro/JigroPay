import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

// ── Dialog type ───────────────────────────────────────────────────────────────

enum AppDialogType { info, success, warning, error, logout, paymentFailed, custom }

// ── Core dialog widget ────────────────────────────────────────────────────────

/// Branded dialog widget — no GetX dependency.
///
/// Use the helper functions ([showAppDialog], [showAppLogoutDialog], etc.)
/// instead of instantiating this directly.
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    this.type = AppDialogType.info,
    this.title,
    this.message,
    this.customContent,
    this.primaryButtonText,
    this.onPrimaryPressed,
    this.secondaryButtonText,
    this.onSecondaryPressed,
    this.customIcon,
    this.customIconColor,
    this.customBadgeBgColor,
  });

  final AppDialogType type;
  final String? title;
  final String? message;
  final Widget? customContent;
  final String? primaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;
  final IconData? customIcon;
  final Color? customIconColor;
  final Color? customBadgeBgColor;

  @override
  Widget build(BuildContext context) {
    final config = _resolveConfig(type);
    final iconData = customIcon ?? config.icon;
    final iconColor = customIconColor ?? config.iconColor;
    final badgeBg = customBadgeBgColor ?? config.badgeBg;
    final dialogTitle = title ?? config.defaultTitle;
    final isDestructive =
        type == AppDialogType.logout || type == AppDialogType.paymentFailed;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        constraints: const BoxConstraints(maxWidth: 340),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon badge
            _BadgeIcon(icon: iconData, iconColor: iconColor, badgeBg: badgeBg),
            const SizedBox(height: 18),

            // Title
            if (dialogTitle.isNotEmpty) ...[
              Text(
                dialogTitle,
                textAlign: TextAlign.center,
                style: AppTypography.h3,
              ),
              const SizedBox(height: 10),
            ],

            // Message
            if (message != null && message!.isNotEmpty) ...[
              Text(
                message!,
                textAlign: TextAlign.center,
                style: AppTypography.body1.copyWith(color: AppColors.grey),
              ),
              const SizedBox(height: 16),
            ],

            // Custom content slot
            if (customContent != null) ...[
              customContent!,
              const SizedBox(height: 16),
            ],

            const SizedBox(height: 6),

            // Action row
            Row(
              children: [
                if (secondaryButtonText != null) ...[
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: const BorderSide(
                            color: AppColors.lightGrey, width: 1.2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: onSecondaryPressed ??
                          () => Navigator.of(context).pop(false),
                      child: Text(
                        secondaryButtonText!,
                        style: AppTypography.buttonMedium
                            .copyWith(color: AppColors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(child: _PrimaryButton(
                  label: primaryButtonText ?? 'OK',
                  isDestructive: isDestructive,
                  onPressed: onPrimaryPressed ??
                      () => Navigator.of(context).pop(true),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Global helper functions ───────────────────────────────────────────────────

/// Generic dialog — use specific variants below for common cases.
Future<T?> showAppDialog<T>(
  BuildContext context, {
  AppDialogType type = AppDialogType.info,
  String? title,
  String? message,
  Widget? customContent,
  String? primaryButtonText,
  VoidCallback? onPrimaryPressed,
  String? secondaryButtonText,
  VoidCallback? onSecondaryPressed,
  IconData? customIcon,
  Color? customIconColor,
  Color? customBadgeBgColor,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black54,
    builder: (_) => AppDialog(
      type: type,
      title: title,
      message: message,
      customContent: customContent,
      primaryButtonText: primaryButtonText,
      onPrimaryPressed: onPrimaryPressed,
      secondaryButtonText: secondaryButtonText,
      onSecondaryPressed: onSecondaryPressed,
      customIcon: customIcon,
      customIconColor: customIconColor,
      customBadgeBgColor: customBadgeBgColor,
    ),
  );
}

/// Logout confirmation dialog. Returns `true` if user confirmed.
Future<bool?> showLogoutDialog(
  BuildContext context, {
  required VoidCallback onLogout,
}) {
  return showAppDialog<bool>(
    context,
    type: AppDialogType.logout,
    title: 'Logout',
    message: 'Are you sure you want to log out of your JigroPay account?',
    primaryButtonText: 'Logout',
    secondaryButtonText: 'Cancel',
    barrierDismissible: false,
    onPrimaryPressed: () {
      Navigator.of(context).pop(true);
      onLogout();
    },
    onSecondaryPressed: () => Navigator.of(context).pop(false),
  );
}

/// Payment failure dialog.
Future<void> showPaymentFailedDialog(
  BuildContext context, {
  required String message,
  String? title,
  VoidCallback? onRetry,
}) {
  return showAppDialog<void>(
    context,
    type: AppDialogType.paymentFailed,
    title: title ?? 'Payment Failed',
    message: message,
    primaryButtonText: onRetry != null ? 'Retry' : 'Close',
    onPrimaryPressed: () {
      Navigator.of(context).pop();
      onRetry?.call();
    },
  );
}

/// Success dialog.
Future<void> showSuccessDialog(
  BuildContext context, {
  required String message,
  String? title,
  VoidCallback? onDismiss,
}) {
  return showAppDialog<void>(
    context,
    type: AppDialogType.success,
    title: title ?? 'Success',
    message: message,
    onPrimaryPressed: () {
      Navigator.of(context).pop();
      onDismiss?.call();
    },
  );
}

/// Error dialog.
Future<void> showErrorDialog(
  BuildContext context, {
  required String message,
  String? title,
}) {
  return showAppDialog<void>(
    context,
    type: AppDialogType.error,
    title: title ?? 'Error',
    message: message,
  );
}

/// Confirmation dialog. Returns `true` if user pressed the confirm button.
Future<bool?> showConfirmDialog(
  BuildContext context, {
  required String message,
  String? title,
  String confirmText = 'Yes',
  String cancelText = 'No',
  VoidCallback? onConfirm,
}) {
  return showAppDialog<bool>(
    context,
    type: AppDialogType.warning,
    title: title ?? 'Confirm',
    message: message,
    primaryButtonText: confirmText,
    secondaryButtonText: cancelText,
    onPrimaryPressed: () {
      Navigator.of(context).pop(true);
      onConfirm?.call();
    },
    onSecondaryPressed: () => Navigator.of(context).pop(false),
  );
}

/// No-internet dialog shown when connectivity check fails.
Future<void> showNoInternetDialog(BuildContext context) {
  return showAppDialog<void>(
    context,
    type: AppDialogType.warning,
    title: 'No Internet Connection',
    message: 'Please check your internet connection and try again.',
    customIcon: Icons.wifi_off_rounded,
    barrierDismissible: false,
    primaryButtonText: 'OK',
  );
}

/// App update dialog.
/// If [isForceUpdate] is true, dismissal and back button navigation are disabled.
Future<void> showUpdateDialog(
  BuildContext context, {
  required String storeUrl,
  required bool isForceUpdate,
  String? title,
  String? message,
  VoidCallback? onLater,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: !isForceUpdate,
    barrierColor: Colors.black54,
    builder: (dialogCtx) => PopScope(
      canPop: !isForceUpdate,
      child: AppDialog(
        type: AppDialogType.info,
        customIcon: Icons.system_update_rounded,
        title: title ?? (isForceUpdate ? 'Update Required' : 'New Update Available'),
        message: message ??
            (isForceUpdate
                ? 'A new version of JigroPay is required to continue. Please update to the latest version.'
                : 'A new version of JigroPay is available with improvements and fixes.'),
        primaryButtonText: 'Update Now',
        onPrimaryPressed: () async {
          if (storeUrl.isNotEmpty) {
            final uri = Uri.parse(storeUrl);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          }
        },
        secondaryButtonText: isForceUpdate ? null : 'Later',
        onSecondaryPressed: isForceUpdate
            ? null
            : () {
                Navigator.of(dialogCtx).pop();
                onLater?.call();
              },
      ),
    ),
  );
}

// ── Private sub-widgets ───────────────────────────────────────────────────────

class _BadgeIcon extends StatelessWidget {
  const _BadgeIcon({
    required this.icon,
    required this.iconColor,
    required this.badgeBg,
  });

  final IconData icon;
  final Color iconColor;
  final Color badgeBg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 66,
      height: 66,
      decoration: BoxDecoration(
        color: badgeBg,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: 0.18),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, size: 32, color: iconColor),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    required this.isDestructive,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final gradient = isDestructive
        ? const LinearGradient(
            colors: [AppColors.errorBright, Color(0xffb91c1c)],
          )
        : AppColors.brandGradient;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: (isDestructive ? AppColors.errorBright : AppColors.primary)
                .withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(label, style: AppTypography.buttonMedium),
      ),
    );
  }
}

// ── Config helper ─────────────────────────────────────────────────────────────

class _DialogConfig {
  const _DialogConfig({
    required this.icon,
    required this.iconColor,
    required this.badgeBg,
    required this.defaultTitle,
  });
  final IconData icon;
  final Color iconColor;
  final Color badgeBg;
  final String defaultTitle;
}

_DialogConfig _resolveConfig(AppDialogType type) {
  switch (type) {
    case AppDialogType.logout:
      return const _DialogConfig(
        icon: Icons.logout_rounded,
        iconColor: AppColors.errorBright,
        badgeBg: AppColors.lightError,
        defaultTitle: 'Logout',
      );
    case AppDialogType.paymentFailed:
      return const _DialogConfig(
        icon: Icons.payment_rounded,
        iconColor: AppColors.errorBright,
        badgeBg: AppColors.lightError,
        defaultTitle: 'Payment Failed',
      );
    case AppDialogType.success:
      return const _DialogConfig(
        icon: Icons.check_circle_rounded,
        iconColor: AppColors.success,
        badgeBg: AppColors.lightSuccess,
        defaultTitle: 'Success',
      );
    case AppDialogType.error:
      return const _DialogConfig(
        icon: Icons.gpp_bad_rounded,
        iconColor: AppColors.errorBright,
        badgeBg: AppColors.lightError,
        defaultTitle: 'Error',
      );
    case AppDialogType.warning:
      return const _DialogConfig(
        icon: Icons.warning_amber_rounded,
        iconColor: AppColors.orange,
        badgeBg: AppColors.lightWarning,
        defaultTitle: 'Warning',
      );
    case AppDialogType.info:
    case AppDialogType.custom:
      return const _DialogConfig(
        icon: Icons.info_outline_rounded,
        iconColor: AppColors.primary,
        badgeBg: AppColors.lightPink,
        defaultTitle: 'JigroPay',
      );
  }
}
