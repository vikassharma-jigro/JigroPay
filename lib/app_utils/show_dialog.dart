import 'dart:io';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import '../api_services/api_base_helper.dart';
import 'app_colors.dart';
import 'app_strings.dart';
import 'custom_dialog_widget.dart';
import 'font_family.dart';

void showToastMessage(String message) {
  String cleanMsg = cleanApiMessage(message);
  if (cleanMsg.isEmpty) return;
  Fluttertoast.showToast(
    msg: cleanMsg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    fontSize: 16.0,
  );
}

showProgressDialog(BuildContext context) {
  // SizeConfig().init(context);
  Widget drawerWidget = Container(
    color: Colors.transparent,
    child: SafeArea(
      child: SizedBox.expand(
        child: Center(
          child: Container(
            height: 120.0,
            width: 150.0,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //SpinKitHourGlass(color: Colors.redAccent,size: 30,duration: Duration(milliseconds: 3000),),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: Text(
                    'Please wait!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.3),
    transitionDuration: Duration(milliseconds: 50),
    context: context,
    pageBuilder: (_, __, ___) {
      return drawerWidget;
    },
  );
}

showLoader(BuildContext? context) {
  showDialog(
    barrierDismissible: false,
    context: context!,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: const SizedBox(
          height: 50,
          width: 50,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    },
  );
}

/*showLoader(context) {
  showDialog(
    barrierDismissible: false,
    //barrierColor: AppColors.loderColor,
    context: context,
    builder: (context) {
      return const WillPopScope(
        onWillPop: null,
        child: SizedBox(
          height: 60,
            width: 60,
            child: CircularProgressIndicator()),
      );
    },
  );
}*/

Future<void> dialog(BuildContext context, String message) async {
  return showCustomAppDialog<void>(
    context,
    type: CustomDialogType.info,
    title: AppStrings.appTitle,
    message: message,
    barrierDismissible: false,
    primaryButtonText: 'OK',
  );
}

internetConnectionDialog(context) {
  showCustomAppDialog(
    context,
    type: CustomDialogType.warning,
    title: 'No Internet Connection',
    message: 'You need to have mobile data or wifi to access this. Press ok to Exit',
    primaryButtonText: 'OK',
    onPrimaryPressed: () {
      exit(0);
    },
    customIcon: Icons.wifi_off_rounded,
    customIconColor: orangeColor,
    customBadgeBgColor: lightYellowColor,
    barrierDismissible: false,
  );
}

errorDialog(BuildContext? context, {required String title, Function()? onTap}) {
  String cleanTitle = cleanApiMessage(title);
  if (cleanTitle.isEmpty) cleanTitle = "Something went wrong. Please try again.";

  showCustomErrorDialog(
    context!,
    title: AppStrings.appTitle,
    message: cleanTitle,
    onTap: onTap,
  );
}

errorDialogPayment(
  BuildContext? context, {
  required String title,
  Function()? onTap,
}) {
  String cleanTitle = cleanApiMessage(title);
  if (cleanTitle.isEmpty) cleanTitle = "Payment failed. Please try again.";

  showCustomPaymentFailedDialog(
    context!,
    title: "Payment Failed",
    message: cleanTitle,
    onRetry: onTap,
  );
}

errorDialogEdit(
  BuildContext? context, {
  required String title,
  Function()? onTap,
}) {
  showCustomAppDialog(
    context!,
    type: CustomDialogType.info,
    title: AppStrings.appTitle,
    message: title,
    primaryButtonText: "OK",
    onPrimaryPressed: () {
      Navigator.pop(context!);
      Navigator.pop(context!, true);
    },
  );
}

confirmDialog(
  BuildContext context, {
  required String title,
  Function()? onTap,
}) {
  showCustomConfirmDialog(
    context,
    title: AppStrings.appTitle,
    message: title,
    onConfirm: onTap,
  );
}

appDialog(BuildContext context, String message) {
  showCustomAppDialog(
    context,
    type: CustomDialogType.info,
    title: AppStrings.appTitle,
    message: message,
    barrierDismissible: false,
    primaryButtonText: 'OK',
  );
}

redirectDialog(
  BuildContext context,
  String message,
  dynamic type, {
  VoidCallback? onPressed,
}) {
  showCustomAppDialog(
    context,
    type: CustomDialogType.info,
    title: AppStrings.appTitle,
    message: message,
    barrierDismissible: false,
    primaryButtonText: 'OK',
    onPrimaryPressed: onPressed ??
        () async {
          Navigator.of(context).pop();
          if (type == "logout") {
            dataRemove(context);
          } else if (type == "back") {
            Navigator.of(context).pop("Back");
          }
        },
  );
}

redirectDialogChange(
  BuildContext context,
  String message,
  dynamic type, {
  VoidCallback? onPressed,
}) {
  showCustomAppDialog(
    context,
    type: CustomDialogType.info,
    title: AppStrings.appTitle,
    message: message,
    barrierDismissible: false,
    primaryButtonText: 'OK',
    onPrimaryPressed: onPressed ?? () async {
      Navigator.of(context).pop();
    },
  );
}

dataRemove(BuildContext context) {
  //sp!.clearImportantKeys();
}

Future<void> showDialogSuccess(BuildContext context, String? type) async {
  showCustomSuccessDialog(
    context,
    title: "Success!",
    message: "Your changes have been successfully saved!",
    primaryButtonText: "OK",
    onSuccess: () {
      Navigator.pop(context);
    },
  );
}

Future<void> showDialogKycSuccess(BuildContext context) async {
  showCustomSuccessDialog(
    context,
    title: "Success!",
    message: "Your changes have been successfully saved!",
    primaryButtonText: "OK",
    onSuccess: () {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    },
  );
}

Future<void> showDialogInsurance(BuildContext context, String requestID) async {
  showCustomAppDialog(
    context,
    type: CustomDialogType.success,
    title: "Thank You!",
    message: "The form has been submitted.",
    customContent: Column(
      children: [
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            text: 'Your Request ID is : ',
            style: TextStyle(
              color: greyColor,
              fontSize: 13,
              fontFamily: FontFamily.plusJakartaSansMedium,
            ),
            children: <TextSpan>[
              TextSpan(
                text: requestID,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: red1Color,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    primaryButtonText: "OK",
    barrierDismissible: false,
  );
}

Future<void> showDialogMutual(BuildContext context, String requestID) async {
  showCustomAppDialog(
    context,
    type: CustomDialogType.success,
    title: "Thank You!",
    message: "Your request for SIP is submitted successfully.",
    customContent: Column(
      children: [
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            text: 'Your Request ID is : ',
            style: TextStyle(
              color: greyColor,
              fontSize: 13,
              fontFamily: FontFamily.plusJakartaSansMedium,
            ),
            children: <TextSpan>[
              TextSpan(
                text: requestID,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: red1Color,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Our team will get back to you shortly on this.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: greyColor,
            fontSize: 12,
            fontFamily: FontFamily.plusJakartaSansMedium,
          ),
        ),
      ],
    ),
    primaryButtonText: "OK",
    barrierDismissible: false,
  );
}
