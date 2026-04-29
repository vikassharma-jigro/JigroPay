import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../api_services/api_base_helper.dart';
import '../api_services/api_config.dart';
import '../app_utils/app_colors.dart';
import '../model/auth_model.dart';


class AuthController extends GetxController {
  var isLoading = false.obs;
  var authModel = AuthModel().obs;

  Future<void> getUserSignupApi({
    required BuildContext context,
    required String mobileNumber,
    required String name,
    required String email,
    required String deviceId,
    required String deviceToken,
  }) async {
    try {
      isLoading(true);
      Map<String, dynamic> body = {
        "name": name,
        "email": email,
        "phone": mobileNumber,
        "device_id": deviceId,
        "device_token": deviceToken,
      };
      var response = await ApiBaseHelper().postApiCall(
        false,
        partnerSignupUrl,
        context,
        body,
      );

      AuthModel modal = AuthModel.fromJson(response);
      modal.user?.otp = null;
      authModel.value = modal;

      Fluttertoast.showToast(
        msg: modal.message ?? "",
        gravity: ToastGravity.CENTER,
        backgroundColor: blueColor,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Something went wrong: $e",
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void>getProfileApi({BuildContext? context}) async {
    var response = await ApiBaseHelper().getApiCall(context!);
    print("response>>>>${response}");
   // ProfileModel modal = ProfileModel.fromJson(response);

    //return modal;
  }
}
