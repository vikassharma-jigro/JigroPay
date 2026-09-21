import 'package:flutter/material.dart';
import '../View/auth_view/signup_screen.dart';
import 'app_colors.dart';
import 'app_strings.dart';
import 'custom_dialog_widget.dart';

class ShowAlertDialog {
  showErrorAlert(BuildContext context, String message) {
    showCustomErrorDialog(
      context,
      title: AppStrings.appTitle,
      message: message,
      primaryButtonText: "Close",
    );
  }

  showErrorAlertLogin(BuildContext context, String message) {
    showCustomErrorDialog(
      context,
      title: AppStrings.appTitle,
      message: message,
      primaryButtonText: "OK",
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignUpScreen()),
        );
      },
    );
  }
}
