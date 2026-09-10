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
import '../app_utils/shared_preferences.dart';
import '../app_utils/show_dialog.dart';
import '../main.dart';
import 'api_config.dart';
import 'app_exception.dart';

/// Helper to clean raw API responses or errors into user-friendly plain text messages.
String cleanApiMessage(dynamic rawInput) {
  if (rawInput == null) return "";

  // 1. If rawInput is a Map
  if (rawInput is Map) {
    var val = rawInput['message'] ??
        rawInput['msg'] ??
        rawInput['error'] ??
        rawInput['errors'] ??
        rawInput['description'];

    if (val != null && val != rawInput) {
      String extracted = cleanApiMessage(val);
      if (extracted.isNotEmpty) return extracted;
    }
  }

  // 2. If rawInput is a List (e.g. ["The consumer id is invalid"])
  if (rawInput is List) {
    if (rawInput.isNotEmpty) {
      return cleanApiMessage(rawInput.first);
    }
    return "";
  }

  String text = rawInput.toString().trim();
  if (text.isEmpty) return "";

  // 3. Handle raw JSON string e.g. {"status": false, "message": "Failed"}
  if ((text.startsWith('{') && text.endsWith('}')) || (text.startsWith('[') && text.endsWith(']'))) {
    try {
      var decoded = jsonDecode(text);
      if (decoded != null && decoded != rawInput) {
        String decodedClean = cleanApiMessage(decoded);
        if (decodedClean.isNotEmpty) return decodedClean;
      }
    } catch (_) {}
  }

  // 4. Handle embedded JSON in exception strings e.g. Exception: {"message":"..."}
  int firstBrace = text.indexOf('{');
  int lastBrace = text.lastIndexOf('}');
  if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
    try {
      String jsonSub = text.substring(firstBrace, lastBrace + 1);
      var decoded = jsonDecode(jsonSub);
      if (decoded != null) {
        String decodedClean = cleanApiMessage(decoded);
        if (decodedClean.isNotEmpty) return decodedClean;
      }
    } catch (_) {}
  }

  // Cleanup outer symbols, quotes, brackets
  text = text.replaceAll(RegExp(r'^[\{\[\"\s]+|[\}\]\"\s]+$'), '').trim();

  if (text.toLowerCase() == "invalid" || text.toLowerCase() == "invalid otp") {
    return "Invalid OTP. Please try again.";
  }

  return text;
}

class ApiBaseHelper {
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
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
    }

    dynamic responseJson;
    var apiHeader = {
      "Authorization": "Bearer ${sp?.getString(SpUtil.ACCESS_TOKEN) ?? ""}",
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    try {
      String encodedBody = jsonEncode(jsonData ?? {});
      print("🔹 API URL: ${BASE_URL + url}");
      print("🔹 Header: $apiHeader");
      print("🔹 Request Body: $encodedBody");

      final http.Response response = await http.post(
        Uri.parse(BASE_URL + url),
        headers: apiHeader,
        body: encodedBody,
      );

      if (isShow) {
        try {
          if (Get.isDialogOpen ?? false) Get.back();
        } catch (_) {}
      }

      print("🔹 Status Code: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      final parsedResponse = jsonDecode(response.body);

      // Error handling
      if ([400, 401, 422, 403, 404, 409, 500].contains(response.statusCode)) {
        String msg = cleanApiMessage(parsedResponse);
        if (msg.isNotEmpty) {
          Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            timeInSecForIosWeb: 1,
          );
        }
        return parsedResponse;
      }

      // Parse success
      responseJson = _returnResponse(response);

      // Handle popup messages if required
      if (isPopup == true) {
        final status = responseJson['status'];
        if ((status is bool && !status) || status == "Failure" || status == "false" || status == 0) {
          String msg = cleanApiMessage(responseJson);
          if (msg.isNotEmpty) {
            Fluttertoast.showToast(
              msg: msg,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              timeInSecForIosWeb: 1,
            );
          }
        }
      }

      return responseJson;
    } on SocketException {
      if (isShow) {
        try {
          if (Get.isDialogOpen ?? false) Get.back();
        } catch (_) {}
      }
      showToastMessage("No Internet connection");
      throw FetchDataException('No Internet connection');
    } catch (e) {
      if (isShow) {
        try {
          if (Get.isDialogOpen ?? false) Get.back();
        } catch (_) {}
      }
      print("⚠️ API Exception: $e");
      String cleanErr = cleanApiMessage(e);
      return {"status": false, "message": cleanErr.isNotEmpty ? cleanErr : "Something went wrong"};
    }
  }

  Future<dynamic> postMultipartApiCall(
    bool isShow,
    String url,
    BuildContext context,
    Map<String, String> fields, {
    String? fileKey,
    String? filePath,
  }) async {
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if (!isNetActive) {
      internetConnectionDialog(context);
      return null;
    }

    if (isShow) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
    }

    try {
      var uri = Uri.parse(BASE_URL + url);
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll({
        "Authorization": "Bearer ${sp?.getString(SpUtil.ACCESS_TOKEN) ?? ""}",
        'accept': 'application/json',
      });

      request.fields.addAll(fields);

      if (fileKey != null && filePath != null && filePath.isNotEmpty) {
        var file = await http.MultipartFile.fromPath(fileKey, filePath);
        request.files.add(file);
      }

      print("🔹 MULTIPART API URL: $uri");
      print("🔹 Fields: $fields");
      if (filePath != null) print("🔹 File: $fileKey -> $filePath");

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (isShow) {
        try {
          if (Get.isDialogOpen ?? false) Get.back();
        } catch (_) {}
      }

      print("🔹 Status Code: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      final parsedResponse = jsonDecode(response.body);

      if ([401, 422, 403, 404, 409, 500].contains(response.statusCode)) {
        String msg = cleanApiMessage(parsedResponse);
        if (msg.isNotEmpty) {
          Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            timeInSecForIosWeb: 1,
          );
        }
        return parsedResponse;
      }

      return _returnResponse(response);
    } on SocketException {
      if (isShow) {
        try {
          if (Get.isDialogOpen ?? false) Get.back();
        } catch (_) {}
      }
      showToastMessage("No Internet connection");
      throw FetchDataException('No Internet connection');
    } catch (e) {
      if (isShow) {
        try {
          if (Get.isDialogOpen ?? false) Get.back();
        } catch (_) {}
      }
      print("⚠️ Multipart API Exception: $e");
      String cleanErr = cleanApiMessage(e);
      return {"status": false, "message": cleanErr.isNotEmpty ? cleanErr : "Something went wrong"};
    }
  }

  Future<dynamic> getApiCall(
    bool isShow,
    String url,
    BuildContext context, {
    bool? isPopup = true,
  }) async {
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if (!isNetActive) {
      internetConnectionDialog(context);
      return null;
    }

    if (isShow) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
    }

    dynamic responseJson;
    var apiHeader = {
      "Authorization": "Bearer ${sp?.getString(SpUtil.ACCESS_TOKEN) ?? ""}",
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    try {
      final http.Response response = await http.get(
        Uri.parse(BASE_URL + url),
        headers: apiHeader,
      );

      if (isShow) {
        try {
          if (Get.isDialogOpen ?? false) Get.back();
        } catch (_) {}
      }

      if (kDebugMode) {
        print("🔹 API URL: ${BASE_URL + url}");
        print("🔹 Header: $apiHeader");
        print("🔹 Status Code: ${response.statusCode}");
        log('🔹 Response Body: ${response.body}');
      }

      final parsedResponse = jsonDecode(response.body);

      // Handle error status codes
      if ([401, 422, 403, 404, 409, 500].contains(response.statusCode)) {
        String msg = cleanApiMessage(parsedResponse);
        if (msg.isNotEmpty) {
          Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            timeInSecForIosWeb: 1,
          );
        }
        return parsedResponse;
      }

      // Parse success response
      responseJson = _returnResponse(response);

      // Optional popup message on failed status
      if (isPopup == true) {
        final status = responseJson['status'];
        if (status is bool && !status) {
          String msg = cleanApiMessage(responseJson);
          if (msg.isNotEmpty) {
            Fluttertoast.showToast(
              msg: msg,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              timeInSecForIosWeb: 1,
            );
          }
        }
      }

      return responseJson;
    } on SocketException {
      if (Get.isDialogOpen ?? false) Get.back();
      showToastMessage("No Internet connection");
      throw FetchDataException('No Internet connection');
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      print("⚠️ API Exception: $e");
      return {"status": false, "message": cleanApiMessage(e)};
    }
  }

  Future<dynamic> putApiCall(
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
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
    }

    var apiHeader = {
      "Authorization": "Bearer ${sp?.getString(SpUtil.ACCESS_TOKEN) ?? ""}",
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    try {
      String encodedBody = jsonEncode(jsonData ?? {});
      print("🔹 PUT API URL: ${BASE_URL + url}");
      print("🔹 Request Body: $encodedBody");

      final http.Response response = await http.put(
        Uri.parse(BASE_URL + url),
        headers: apiHeader,
        body: encodedBody,
      );

      if (isShow) {
        try {
          if (Get.isDialogOpen ?? false) Get.back();
        } catch (_) {}
      }

      print("🔹 Status Code: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      final parsedResponse = jsonDecode(response.body);

      if ([400, 401, 422, 403, 404, 409, 500].contains(response.statusCode)) {
        String msg = cleanApiMessage(parsedResponse);
        if (msg.isNotEmpty && isPopup == true) {
          Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            timeInSecForIosWeb: 1,
          );
        }
      }

      return parsedResponse;
    } catch (e) {
      if (isShow) {
        try {
          if (Get.isDialogOpen ?? false) Get.back();
        } catch (_) {}
      }
      print("⚠️ PUT API Exception: $e");
      return {"status": false, "message": cleanApiMessage(e)};
    }
  }

  Future<dynamic> deleteApiCall(
    bool isShow,
    String url,
    BuildContext context, {
    bool? isPopup = true,
  }) async {
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if (!isNetActive) {
      internetConnectionDialog(context);
      return null;
    }

    if (isShow) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
    }

    var apiHeader = {
      "Authorization": "Bearer ${sp?.getString(SpUtil.ACCESS_TOKEN) ?? ""}",
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    try {
      print("🔹 DELETE API URL: ${BASE_URL + url}");

      final http.Response response = await http.delete(
        Uri.parse(BASE_URL + url),
        headers: apiHeader,
      );

      if (isShow) {
        try {
          if (Get.isDialogOpen ?? false) Get.back();
        } catch (_) {}
      }

      print("🔹 Status Code: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      final parsedResponse = jsonDecode(response.body);

      if ([400, 401, 422, 403, 404, 409, 500].contains(response.statusCode)) {
        String msg = cleanApiMessage(parsedResponse);
        if (msg.isNotEmpty && isPopup == true) {
          Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            timeInSecForIosWeb: 1,
          );
        }
      }

      return parsedResponse;
    } catch (e) {
      if (isShow) {
        try {
          if (Get.isDialogOpen ?? false) Get.back();
        } catch (_) {}
      }
      print("⚠️ DELETE API Exception: $e");
      return {"status": false, "message": cleanApiMessage(e)};
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
