import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../app_utils/app_colors.dart';
import '../app_utils/connectivity.dart';
import '../app_utils/show_dialog.dart';
import 'api_config.dart';
import 'app_exception.dart';

class ApiBaseHelper {
  // SharedPreferences? prefs;
  Future<dynamic> postApiCall(
    bool isShow,
    String url,
    BuildContext context,
    Map<String, dynamic>? jsonData, {
    bool? isPopup = true,
  }) async {
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if (!isNetActive) {
      internetConnectionDialog(context);
      return null;
    }

    if (isShow) {
      // Show loader dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
    }

    dynamic responseJson;
    var apiHeader = {
      //"Authorization": "Bearer ${sp?.getString(SpUtil.ACCESS_TOKEN) ?? ""}",
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(BASE_URL + url),
        headers: apiHeader,
        body: jsonEncode(jsonData),
      );

      // Hide loader
      if (isShow && Get.isDialogOpen!) {
        Get.back();
      }

      if (kDebugMode) {
        print("🔹 API URL: ${BASE_URL + url}");
        print("🔹 Header: $apiHeader");
        print("🔹 Request Body: ${jsonEncode(jsonData)}");
        print("🔹 Status Code: ${response.statusCode}");
        log('🔹 Response Body: ${response.body}');
      }

      final parsedResponse = jsonDecode(response.body);

      // Error handling
      if ([401, 422, 403, 404, 409, 500].contains(response.statusCode)) {
        Fluttertoast.showToast(
          msg: parsedResponse['message'] ?? "Something went wrong",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: blueColor,
          timeInSecForIosWeb: 1,
        );
        return parsedResponse;
      }

      // Parse success
      responseJson = _returnResponse(response);

      // Handle popup messages if required
      if (isPopup == true) {
        final status = responseJson['status'];
        if (status is bool && !status) {
          Fluttertoast.showToast(
            msg: responseJson['message'] ?? "Operation failed",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: blueColor,
            timeInSecForIosWeb: 1,
          );
        }
      }

      return responseJson;
    } on SocketException {
      if (isShow && Get.isDialogOpen!) Get.back();
      showToastMessage("No Internet connection");
      throw FetchDataException('No Internet connection');
    } catch (e) {
      if (isShow && Get.isDialogOpen!) Get.back();
      print("⚠️ API Exception: $e");
      return {"status": false, "message": "Something went wrong"};
    }
  }

  Future<dynamic> getApiCall(
    BuildContext context, {
    bool? isPopup = true,
  }) async {
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if (!isNetActive) {
      internetConnectionDialog(context);
      return null;
    }

    // Show loading dialog
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    dynamic responseJson;
    var apiHeader = {
      //"Authorization": "Bearer ${sp?.getString(SpUtil.ACCESS_TOKEN) ?? ""}",
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    try {
      final http.Response response = await http.get(
        Uri.parse(
          "https://discoveryprovider.audius.co/v1/tracks/k90zmzB/stream",
        ),
        headers: apiHeader,
      );

      if (Get.isDialogOpen!) Get.back();

      if (kDebugMode) {
        print(
          "🔹 API URL: ${"https://discoveryprovider.audius.co/v1/tracks/k90zmzB/stream"}",
        );
        print("🔹 Header: $apiHeader");
        print("🔹 Status Code: ${response.statusCode}");
        log('🔹 Response Body: ${response.body}');
      }

      final parsedResponse = jsonDecode(response.body);

      // Handle error status codes
      if ([401, 422, 403, 404, 409, 500].contains(response.statusCode)) {
        Fluttertoast.showToast(
          msg: parsedResponse['message'] ?? "Something went wrong",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: blueColor,
          timeInSecForIosWeb: 1,
        );
        return parsedResponse;
      }

      // Parse success response
      responseJson = _returnResponse(response);

      // Optional popup message on failed status
      if (isPopup == true) {
        final status = responseJson['status'];
        if (status is bool && !status) {
          Fluttertoast.showToast(
            msg: responseJson['message'] ?? "Operation failed",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: blueColor,
            timeInSecForIosWeb: 1,
          );
        }
      }

      return responseJson;
    } on SocketException {
      if (Get.isDialogOpen!) Get.back();
      showToastMessage("No Internet connection");
      throw FetchDataException('No Internet connection');
    } catch (e) {
      if (Get.isDialogOpen!) Get.back();
      print("⚠️ API Exception: $e");
      return {"status": false, "message": "Something went wrong"};
    }
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 201:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        throw UnauthorisedException(response.body.toString());
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 404:
      //throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}',
        );
    }
  }

  void internetConnectionDialog(BuildContext context) {
    // Agar already dialog open hai to close kar do
    if (Get.isDialogOpen ?? false) Get.back();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'No Internet Connection',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Please check your internet connection and try again.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('OK')),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
