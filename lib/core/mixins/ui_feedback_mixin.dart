import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jigrotech/core/constants/app_colors.dart';

mixin UiFeedbackMixin {
  //. Show Success Toast
  void showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.TOP,
      backgroundColor: AppColors.primary,
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  //. Show Error Toast
  void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  //. Show Loading Toast
  void showLoadingToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  //. Hide Keyboard
  void hideKeyboard([BuildContext? context]) {
    if (context != null) {
      FocusScope.of(context).unfocus();
    } else {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
