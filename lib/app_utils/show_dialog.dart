import 'dart:io';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'app_colors.dart';
import 'app_strings.dart';
import 'font_family.dart';

void showToastMessage(String message) {
  Fluttertoast.showToast(
    msg: message,
    //message to show toast
    toastLength: Toast.LENGTH_LONG,
    //duration for message to show
    gravity: ToastGravity.CENTER,
    //where you want to show, top, bottom
    timeInSecForIosWeb: 1,
    //for iOS only
    //backgroundColor: AppColors.black,
    //background Color for message
    //textColor: AppColors.white100,
    //message text color
    fontSize: 16.0, //message font size
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
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text(AppStrings.appTitle),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

internetConnectionDialog(context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        actions: [
          TextButton(
            onPressed: () {
              exit(0);
            },
            child: Text('OK'),
          ),
        ],
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5.0),
            const Text(
              'You need to have mobile data or wifi to access this. Press ok to Exit',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      );
    },
  );
  // Widget okButton = InkWell(
  //   onTap: () {
  //     Navigator.pop(context);
  //   },
  //   child: Container(
  //     height: 50,
  //     width: double.infinity,
  //     margin: const EdgeInsets.only(top: 25),
  //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
  //     decoration: BoxDecoration(
  //       //color: AppColors.greenbg,
  //       borderRadius: BorderRadius.circular(4),
  //     ),
  //     child: const Center(
  //       child: Text("OK",
  //           style: TextStyle(
  //             fontSize: 20,
  //             //color: AppColors.white100,
  //           )),
  //     ),
  //   ),
  // );
  // Dialog alert = Dialog(
  //   //backgroundColor: AppColors.transparent,
  //   insetPadding: EdgeInsets.zero,
  //   child: Container(
  //       margin: const EdgeInsets.symmetric(horizontal: 50),
  //       width: double.infinity,
  //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
  //       decoration: BoxDecoration(
  //         color: Theme.of(context).cardColor,
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           // Center(
  //           //   child: Lottie.asset(
  //           //     'assets/no_internet.json',
  //           //     repeat: true,
  //           //     fit: BoxFit.fill,
  //           //   ),
  //           // ),
  //           // const SizedBox(height: 20),
  //           okButton
  //         ],
  //       )),
  // );
  // // show the dialog
  // showDialog(
  //   context: context,
  //   builder: (BuildContext context) {
  //     return alert;
  //   },
  // );
}

errorDialog(BuildContext? context, {required String title, Function()? onTap}) {
  showDialog(
    context: context!,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          decoration: BoxDecoration(
            //  color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(AppStrings.appTitle, style: TextStyle(fontSize: 20)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 25),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    //color: AppColors.greenbg,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

errorDialogPayment(
  BuildContext? context, {
  required String title,
  Function()? onTap,
}) {
  showDialog(
    context: context!,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          decoration: BoxDecoration(
            //  color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppStrings.appTitle, style: TextStyle(fontSize: 20)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 25),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

errorDialogEdit(
  BuildContext? context, {
  required String title,
  Function()? onTap,
}) {
  showDialog(
    context: context!,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          decoration: BoxDecoration(
            //  color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppStrings.appTitle, style: TextStyle(fontSize: 20)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 25),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

confirmDialog(
  BuildContext context, {
  required String title,
  Function()? onTap,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          decoration: BoxDecoration(
            //  color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppStrings.appTitle, style: TextStyle(fontSize: 20)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 25),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "No",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap:
                        onTap ??
                        () {
                          Navigator.pop(context);
                        },
                    child: Container(
                      margin: const EdgeInsets.only(top: 25),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "Yes",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

appDialog(BuildContext context, String message) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text(AppStrings.appTitle, style: TextStyle(fontSize: 20)),
        content: Text(
          message,
          style: const TextStyle(
            // color: AppColors.textGray,
            fontSize: 14,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              // foreground
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    ),
  );
}

redirectDialog(
  BuildContext context,
  String message,
  dynamic type, {
  VoidCallback? onPressed,
}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text(AppStrings.appTitle, style: TextStyle(fontSize: 20)),
        content: Text(
          message,
          style: const TextStyle(
            // color: Colors.black,
            fontSize: 14,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              // foreground
            ),
            onPressed:
                onPressed ??
                () async {
                  Navigator.of(context).pop();

                  if (type == "login") {
                    // Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => LoginScreen(),
                    //     ),
                    //     (route) => false);
                  } else if (type == "logout") {
                    dataRemove(context);
                  } else if (type == "dashboardScreen") {
                    // Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => HomeScreen(),
                    //     ),
                    //     (route) => false);
                  } else if (type == "back") {
                    Navigator.of(context).pop("Back");
                  } /*else if (type == "session") {
                      dataRemove(context);
                    }*/
                },
            child: const Text('OK'),
          ),
        ],
      ),
    ),
  );
}

redirectDialogChange(
  BuildContext context,
  String message,
  dynamic type, {
  VoidCallback? onPressed,
}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text(AppStrings.appTitle, style: TextStyle(fontSize: 20)),
        content: Text(
          message,
          style: const TextStyle(
            // color: Colors.black,
            fontSize: 14,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              // foreground
            ),
            onPressed:
                onPressed ??
                () async {
                  Navigator.of(context).pop();
                },
            child: const Text('OK'),
          ),
        ],
      ),
    ),
  );
}

dataRemove(BuildContext context) {
  //sp!.clearImportantKeys();
  // Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => LoginScreen(),
  //     ),
  //     (route) => false);
}

Future<void> showDialogSuccess(BuildContext context, String? type) async {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      content: Builder(
        builder: (context) {
          return SizedBox(
            height: 230,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.green,
                  ),
                  child: const Icon(Icons.check, color: white, size: 30),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Success!",
                  style: TextStyle(
                    color: blueColor,
                    fontSize: 18,
                    fontFamily: FontFamily.plusJakartaSansMedium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  "Your changes have been successfully saved!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: greyColor,
                    fontSize: 13,
                    fontFamily: FontFamily.plusJakartaSansMedium,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () {
                    /*print("hello");
                     type=="Bank"? Navigator.push(context, MaterialPageRoute(builder: (context) => const NomineeDetailsScreen(),)).then((value){
                       Navigator.pop(context);
                     }):type=="Nominee"?Navigator.push(context, MaterialPageRoute(builder: (context) => const KycDetailsScreen(),)).then((value){
                       Navigator.pop(context);
                     }):
                    type=="PersonDetails"?
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  DashboardScreen(),)).then((value){
                      Navigator.pop(context);
                    }):*/
                    Navigator.pop(context);
                    Navigator.pop(context);
                    //Navigator.pop(context);
                    //Navigator.pop(context);
                    //Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: 40,
                      width: MediaQuery.sizeOf(context).width * 0.60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: blueColor,
                      ),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "OK",
                          style: TextStyle(
                            color: white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

Future<void> showDialogKycSuccess(BuildContext context) async {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      content: Builder(
        builder: (context) {
          return SizedBox(
            height: 230,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.green,
                  ),
                  child: const Icon(Icons.check, color: white, size: 30),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Success!",
                  style: TextStyle(
                    color: blueColor,
                    fontSize: 15,
                    fontFamily: FontFamily.plusJakartaSansRegular,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  "Your changes have been successfully saved!",
                  style: TextStyle(
                    color: greyColor,
                    fontSize: 12,
                    fontFamily: FontFamily.plusJakartaSansMedium,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: 40,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: blueColor,
                      ),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "OK",
                          style: TextStyle(
                            color: white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

Future<void> showDialogInsurance(BuildContext context, String requestID) async {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      content: Builder(
        builder: (context) {
          return SizedBox(
            height: 250,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.green,
                  ),
                  child: const Icon(Icons.check, color: white, size: 30),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Thank You!",
                  style: TextStyle(
                    color: blueColor,
                    fontSize: 18,
                    fontFamily: FontFamily.plusJakartaSansMedium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 7),
                /*Your Request ID is: 0284567*/
                const Text(
                  "The form has been submitted.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: greyColor,
                    fontSize: 12,
                    fontFamily: FontFamily.plusJakartaSansRegular,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    text: 'Your Request ID is : ',
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: requestID,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () {
                    // Navigator.pop(context);
                    Navigator.pop(context);
                    //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const OfflineInsuranceScreen()), (route) => false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: 40,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: blueColor,
                      ),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "OK",
                          style: TextStyle(
                            color: white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

Future<void> showDialogMutual(BuildContext context, String requestID) async {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      content: Builder(
        builder: (context) {
          return SizedBox(
            height: 260,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.green,
                  ),
                  child: const Icon(Icons.check, color: white, size: 30),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Thank You!",
                  style: TextStyle(
                    color: blueColor,
                    fontSize: 18,
                    fontFamily: FontFamily.plusJakartaSansMedium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 7),
                /*Your Request ID is: 0284567*/
                const Text(
                  "Your request for SIP is submitted successfully.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: greyColor,
                    fontSize: 12,
                    fontFamily: FontFamily.plusJakartaSansRegular,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    text: 'Your Request ID is : ',
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: requestID,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  "Our team will get back to you shortly on this.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: greyColor,
                    fontSize: 12,
                    fontFamily: FontFamily.plusJakartaSansMedium,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () {
                    //Navigator.pop(context);
                    Navigator.pop(context);
                    //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const OfflineInsuranceScreen()), (route) => false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: 40,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: blueColor,
                      ),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "OK",
                          style: TextStyle(
                            color: white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}
