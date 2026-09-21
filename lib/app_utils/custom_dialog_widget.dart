import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_strings.dart';

enum CustomDialogType {
  logout,
  paymentFailed,
  success,
  error,
  warning,
  info,
  custom,
}

class CustomAppDialog extends StatelessWidget {
  final CustomDialogType type;
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
  final bool dismissible;

  const CustomAppDialog({
    super.key,
    this.type = CustomDialogType.info,
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
    this.dismissible = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Resolve Default Styling by Dialog Type
    IconData iconData;
    Color iconColor;
    Color badgeBgColor;
    String defaultTitle;

    switch (type) {
      case CustomDialogType.logout:
        iconData = customIcon ?? Icons.logout_rounded;
        iconColor = customIconColor ?? red1Color;
        badgeBgColor = customBadgeBgColor ?? lightRedColor;
        defaultTitle = "Logout";
        break;
      case CustomDialogType.paymentFailed:
        iconData = customIcon ?? Icons.payment_rounded;
        iconColor = customIconColor ?? red1Color;
        badgeBgColor = customBadgeBgColor ?? lightRedColor;
        defaultTitle = "Payment Failed";
        break;
      case CustomDialogType.success:
        iconData = customIcon ?? Icons.check_circle_rounded;
        iconColor = customIconColor ?? green1Color;
        badgeBgColor = customBadgeBgColor ?? greenColor;
        defaultTitle = "Success";
        break;
      case CustomDialogType.error:
        iconData = customIcon ?? Icons.gpp_bad_rounded;
        iconColor = customIconColor ?? red1Color;
        badgeBgColor = customBadgeBgColor ?? lightRedColor;
        defaultTitle = "Error";
        break;
      case CustomDialogType.warning:
        iconData = customIcon ?? Icons.warning_amber_rounded;
        iconColor = customIconColor ?? orangeColor;
        badgeBgColor = customBadgeBgColor ?? lightYellowColor;
        defaultTitle = "Warning";
        break;
      case CustomDialogType.info:
        iconData = customIcon ?? Icons.info_outline_rounded;
        iconColor = customIconColor ?? primaryColor;
        badgeBgColor = customBadgeBgColor ?? lightPinkColor;
        defaultTitle = AppStrings.appTitle;
        break;
      case CustomDialogType.custom:
        iconData = customIcon ?? Icons.notifications_none_rounded;
        iconColor = customIconColor ?? primaryColor;
        badgeBgColor = customBadgeBgColor ?? lightPinkColor;
        defaultTitle = AppStrings.appTitle;
        break;
    }

    final dialogTitle = title ?? defaultTitle;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      backgroundColor: isDark ? theme.cardColor : white,
      surfaceTintColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        constraints: const BoxConstraints(maxWidth: 340),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Decorative Icon Badge
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: badgeBgColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: iconColor.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                iconData,
                size: 32,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 18),

            // Title
            if (dialogTitle.isNotEmpty) ...[
              Text(
                dialogTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? white : blackColor,
                ),
              ),
              const SizedBox(height: 10),
            ],

            // Body Message
            if (message != null && message!.isNotEmpty) ...[
              Text(
                message!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: isDark ? lightWhiteColor : greyColor,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Custom Content Slot
            if (customContent != null) ...[
              customContent!,
              const SizedBox(height: 16),
            ],

            const SizedBox(height: 8),

            // Action Buttons
            Row(
              children: [
                // Secondary Button (Cancel / Dismiss)
                if (secondaryButtonText != null) ...[
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(
                          color: isDark ? lightGreyColor.withOpacity(0.3) : lightGreyColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: onSecondaryPressed ?? () => Navigator.of(context).pop(false),
                      child: Text(
                        secondaryButtonText!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? lightWhiteColor : greyColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],

                // Primary Button (Confirm / OK / Action)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: type == CustomDialogType.logout || type == CustomDialogType.paymentFailed
                          ? const LinearGradient(
                              colors: [red1Color, Color(0xffb91c1c)],
                            )
                          : const LinearGradient(
                              colors: [primaryColor, secondaryColor],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      boxShadow: [
                        BoxShadow(
                          color: (type == CustomDialogType.logout || type == CustomDialogType.paymentFailed
                                  ? red1Color
                                  : primaryColor)
                              .withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: onPrimaryPressed ?? () => Navigator.of(context).pop(true),
                      child: Text(
                        primaryButtonText ?? "OK",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: white,
                        ),
                      ),
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
}

// Global Helper Functions for Dialog Displays

Future<T?> showCustomAppDialog<T>(
  BuildContext context, {
  CustomDialogType type = CustomDialogType.info,
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
    barrierColor: Colors.black.withOpacity(0.54),
    builder: (ctx) => CustomAppDialog(
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
      dismissible: barrierDismissible,
    ),
  );
}

/// Show custom logout confirmation dialog
Future<bool?> showCustomLogoutDialog(
  BuildContext context, {
  required VoidCallback onLogout,
}) {
  return showCustomAppDialog<bool>(
    context,
    type: CustomDialogType.logout,
    title: "Logout",
    message: "Are you sure you want to log out of your JigroPay account?",
    primaryButtonText: "Logout",
    secondaryButtonText: "Cancel",
    onPrimaryPressed: () {
      Navigator.of(context).pop(true);
      onLogout();
    },
    onSecondaryPressed: () {
      Navigator.of(context).pop(false);
    },
  );
}

/// Show custom payment failed dialog
Future<void> showCustomPaymentFailedDialog(
  BuildContext context, {
  String? title,
  required String message,
  VoidCallback? onRetry,
  String primaryButtonText = "Close",
}) {
  return showCustomAppDialog<void>(
    context,
    type: CustomDialogType.paymentFailed,
    title: title ?? "Payment Failed",
    message: message,
    primaryButtonText: primaryButtonText,
    onPrimaryPressed: () {
      Navigator.of(context).pop();
      if (onRetry != null) onRetry();
    },
  );
}

/// Show custom success dialog
Future<void> showCustomSuccessDialog(
  BuildContext context, {
  String? title,
  required String message,
  VoidCallback? onSuccess,
  String primaryButtonText = "OK",
}) {
  return showCustomAppDialog<void>(
    context,
    type: CustomDialogType.success,
    title: title ?? "Success",
    message: message,
    primaryButtonText: primaryButtonText,
    onPrimaryPressed: () {
      Navigator.of(context).pop();
      if (onSuccess != null) onSuccess();
    },
  );
}

/// Show custom error dialog
Future<void> showCustomErrorDialog(
  BuildContext context, {
  String? title,
  required String message,
  VoidCallback? onTap,
  String primaryButtonText = "OK",
}) {
  return showCustomAppDialog<void>(
    context,
    type: CustomDialogType.error,
    title: title ?? "Error",
    message: message,
    primaryButtonText: primaryButtonText,
    onPrimaryPressed: () {
      Navigator.of(context).pop();
      if (onTap != null) onTap();
    },
  );
}

/// Show custom confirmation dialog (e.g. Yes/No)
Future<bool?> showCustomConfirmDialog(
  BuildContext context, {
  String? title,
  required String message,
  String primaryButtonText = "Yes",
  String secondaryButtonText = "No",
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
}) {
  return showCustomAppDialog<bool>(
    context,
    type: CustomDialogType.warning,
    title: title ?? "Confirmation",
    message: message,
    primaryButtonText: primaryButtonText,
    secondaryButtonText: secondaryButtonText,
    onPrimaryPressed: () {
      Navigator.of(context).pop(true);
      if (onConfirm != null) onConfirm();
    },
    onSecondaryPressed: () {
      Navigator.of(context).pop(false);
      if (onCancel != null) onCancel();
    },
  );
}
