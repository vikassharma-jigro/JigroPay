import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../app_utils/connectivity.dart';
import '../app_utils/custom_dialog_widget.dart';
import '../app_utils/shared_preferences.dart';
import '../app_utils/show_dialog.dart';
import '../main.dart';
import 'api_config.dart';
import 'app_exception.dart';

/// Helper to clean raw API responses or errors into user-friendly plain text messages.
String cleanApiMessage(dynamic rawInput) {
  if (rawInput == null) return "";

  const String fallbackServerError = "Server error occurred. Please try again.";

  // 1. If rawInput is a Map
  if (rawInput is Map) {
    const messageKeys = [
      'message',
      'msg',
      'error',
      'errors',
      'description',
      'error_description',
      'detail',
      'details',
      'reason',
      'reasons',
      'error_message',
      'errorMessage',
      'error_msg',
      'errorMsg',
      'statusMessage',
      'status_message',
      'responseMessage',
      'response_message',
      'res_msg',
      'resMsg',
      'info',
      'response',
    ];

    for (var key in messageKeys) {
      if (rawInput.containsKey(key)) {
        var val = rawInput[key];
        if (val != null && val != rawInput) {
          String extracted = cleanApiMessage(val);
          if (extracted.isNotEmpty && extracted != fallbackServerError) {
            return extracted;
          }
        }
      }
    }

    const nestedKeys = ['data', 'result', 'payload', 'body', 'error'];
    for (var key in nestedKeys) {
      if (rawInput.containsKey(key)) {
        var val = rawInput[key];
        if (val is Map || val is List) {
          String extracted = cleanApiMessage(val);
          if (extracted.isNotEmpty && extracted != fallbackServerError) {
            return extracted;
          }
        }
      }
    }

    for (var value in rawInput.values) {
      if (value is String && value.isNotEmpty) {
        String trimmed = value.trim();
        if (!_isTechnicalOrRawString(trimmed)) {
          String res = cleanApiMessage(trimmed);
          if (res.isNotEmpty && res != fallbackServerError) {
            return res;
          }
        }
      }
    }

    return fallbackServerError;
  }

  // 2. If rawInput is a List
  if (rawInput is List) {
    for (var item in rawInput) {
      String extracted = cleanApiMessage(item);
      if (extracted.isNotEmpty && extracted != fallbackServerError) {
        return extracted;
      }
    }
    return fallbackServerError;
  }

  String text = rawInput.toString().trim();
  if (text.isEmpty) return "";

  // 3. Handle HTML responses (e.g. 500 Nginx/Apache error page)
  if (text.contains('<html') || text.contains('<!DOCTYPE') || text.contains('<head') || text.contains('<body')) {
    return fallbackServerError;
  }

  // 4. Handle Dio / Network / System exceptions
  if (text.contains('DioException') || text.contains('SocketException') || text.contains('HttpException')) {
    if (text.contains('SocketException') || text.contains('Failed host lookup') || text.contains('Network is unreachable')) {
      return "No Internet connection. Please check your network.";
    }
    if (text.contains('connectTimeout') || text.contains('receiveTimeout') || text.contains('sendTimeout')) {
      return "Request timed out. Please try again.";
    }
    return fallbackServerError;
  }

  // 5. Handle raw JSON string e.g. {"status": false, "message": "Failed"}
  if ((text.startsWith('{') && text.endsWith('}')) || (text.startsWith('[') && text.endsWith(']'))) {
    try {
      var decoded = jsonDecode(text);
      if (decoded != null && decoded != rawInput) {
        String decodedClean = cleanApiMessage(decoded);
        if (decodedClean.isNotEmpty) return decodedClean;
      }
    } catch (_) {}
  }

  // 6. Handle embedded JSON in exception strings e.g. Exception: {"message":"..."}
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

  // 7. Regex extract key-value message from Dart Map toString() e.g. {status: false, message: Payment failed}
  RegExp messageRegExp = RegExp(r'(?:message|msg|error|description|detail|reason)\s*:\s*([^,\}\]]+)', caseSensitive: false);
  Match? match = messageRegExp.firstMatch(text);
  if (match != null && match.groupCount >= 1) {
    String matchedMsg = match.group(1)?.trim() ?? "";
    if (matchedMsg.isNotEmpty && !_isTechnicalOrRawString(matchedMsg)) {
      String cleaned = matchedMsg.replaceAll('"', '').replaceAll("'", '').trim();
      if (cleaned.isNotEmpty) return cleaned;
    }
  }

  // 8. If text is technical / raw object representation
  if (_isTechnicalOrRawString(text)) {
    return fallbackServerError;
  }

  // Cleanup outer symbols, quotes, brackets
  text = text.replaceAll('{', '').replaceAll('}', '').replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').trim();

  if (text.toLowerCase() == "invalid" || text.toLowerCase() == "invalid otp") {
    return "Invalid OTP. Please try again.";
  }

  if (text.toLowerCase() == "internal server error" || text == "500" || text == "400" || text == "502" || text == "504") {
    return fallbackServerError;
  }

  return text;
}

bool _isTechnicalOrRawString(String str) {
  if (str.startsWith('{') || str.startsWith('[') || str.endsWith('}') || str.endsWith(']')) return true;
  if (str.contains('status:') || str.contains('statusCode:') || str.contains('status_code:')) return true;
  if (str.contains('<!DOCTYPE') || str.contains('<html')) return true;
  if (str.contains('DioException') || str.contains('Stack trace:') || str.contains('Exception:')) return true;
  return false;
}

class ApiBaseHelper {
  static final Dio _dio = _createDio();

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: BASE_URL,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

    return dio;
  }

  Options _getOptions() {
    return Options(
      headers: {
        "Authorization": "Bearer ${sp?.getString(SpUtil.ACCESS_TOKEN) ?? ""}",
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      validateStatus: (status) => status != null && status < 600,
    );
  }

  dynamic _parseResponseData(dynamic data) {
    if (data is String) {
      try {
        return jsonDecode(data);
      } catch (_) {
        return data;
      }
    }
    return data;
  }

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

    try {
      final response = await _dio.post(
        url,
        data: jsonData ?? {},
        options: _getOptions(),
      );

      if (isShow) {
        try {
          if (Get.isDialogOpen ?? false) Get.back();
        } catch (_) {}
      }

      final parsedResponse = _parseResponseData(response.data);

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

      dynamic responseJson = parsedResponse;

      if (isPopup == true) {
        final status = responseJson is Map ? responseJson['status'] : null;
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
      Map<String, dynamic> formMap = Map<String, dynamic>.from(fields);
      if (fileKey != null &&
          filePath != null &&
          filePath.isNotEmpty &&
          !filePath.startsWith('http')) {
        formMap[fileKey] = await MultipartFile.fromFile(filePath);
      }
      FormData formData = FormData.fromMap(formMap);

      final response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer ${sp?.getString(SpUtil.ACCESS_TOKEN) ?? ""}",
            'accept': 'application/json',
          },
          validateStatus: (status) => status != null && status < 600,
        ),
      );

      if (isShow) {
        try {
          if (Get.isDialogOpen ?? false) Get.back();
        } catch (_) {}
      }

      final parsedResponse = _parseResponseData(response.data);

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

      return parsedResponse;
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

    try {
      final response = await _dio.get(
        url,
        options: _getOptions(),
      );

      if (isShow) {
        try {
          if (Get.isDialogOpen ?? false) Get.back();
        } catch (_) {}
      }

      final parsedResponse = _parseResponseData(response.data);

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

      dynamic responseJson = parsedResponse;

      if (isPopup == true) {
        final status = responseJson is Map ? responseJson['status'] : null;
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

    try {
      final response = await _dio.put(
        url,
        data: jsonData ?? {},
        options: _getOptions(),
      );

      if (isShow) {
        try {
          if (Get.isDialogOpen ?? false) Get.back();
        } catch (_) {}
      }

      final parsedResponse = _parseResponseData(response.data);

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

    try {
      final response = await _dio.delete(
        url,
        options: _getOptions(),
      );

      if (isShow) {
        try {
          if (Get.isDialogOpen ?? false) Get.back();
        } catch (_) {}
      }

      final parsedResponse = _parseResponseData(response.data);

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
      return {"status": false, "message": cleanApiMessage(e)};
    }
  }

  void internetConnectionDialog(BuildContext context) {
    if (Get.isDialogOpen ?? false) Get.back();

    Get.dialog(
      CustomAppDialog(
        type: CustomDialogType.warning,
        title: 'No Internet Connection',
        message: 'Please check your internet connection and try again.',
        primaryButtonText: 'OK',
        onPrimaryPressed: () => Get.back(),
        customIcon: Icons.wifi_off_rounded,
      ),
      barrierDismissible: false,
    );
  }
}

