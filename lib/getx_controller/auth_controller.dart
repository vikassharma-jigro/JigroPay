import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jigrotech/main.dart';

import '../api_services/api_base_helper.dart';
import '../api_services/api_config.dart';
import '../app_utils/app_colors.dart';
import '../app_utils/shared_preferences.dart';
import '../model/auth_model.dart';
import '../View/auth_view/onboarding_screen.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var authModel = AuthModel().obs;
  var profileData = <String, dynamic>{}.obs;
  var bannerList = <dynamic>[].obs;
  var isProfileLoading = false.obs;
  var isBannerLoading = false.obs;
  var transactionHistoryList = <dynamic>[].obs;
  var isTransactionLoading = false.obs;
  // Stores local file path of profile image immediately after update
  var localProfileImagePath = RxnString();

  Future<void> getTransactionHistoryApi({
    required BuildContext context,
    String type = "",
    String search = "",
  }) async {
    try {
      isTransactionLoading(true);
      List<String> queryParams = [];
      if (type.isNotEmpty) {
        queryParams.add("type=$type");
      }
      if (search.trim().isNotEmpty) {
        queryParams.add("search=${Uri.encodeComponent(search.trim())}");
      }

      String url = transactionHistoryUrl;
      if (queryParams.isNotEmpty) {
        url = "$transactionHistoryUrl?${queryParams.join('&')}";
      }

      print("🚀 Calling Transaction History API: $url (type: '$type', search: '$search')");
      var response = await ApiBaseHelper().getApiCall(
        false,
        url,
        context,
      );
      print("📩 Transaction History Response: $response");
      if (response != null) {
        if (response['data'] != null && response['data'] is List) {
          transactionHistoryList.value = response['data'];
        } else if (response['transactions'] != null && response['transactions'] is List) {
          transactionHistoryList.value = response['transactions'];
        } else if (response['history'] != null && response['history'] is List) {
          transactionHistoryList.value = response['history'];
        } else if (response is List) {
          transactionHistoryList.value = response;
        } else {
          transactionHistoryList.clear();
        }
      } else {
        transactionHistoryList.clear();
      }
    } catch (e) {
      print("❌ Error in getTransactionHistoryApi: $e");
    } finally {
      isTransactionLoading(false);
    }
  }

  Future<void> getProfileApi({required BuildContext context}) async {
    try {
      isProfileLoading(true);
      print("🚀 Calling Profile API: $profileUrl");
      var response = await ApiBaseHelper().getApiCall(
        false,
        profileUrl,
        context,
      );
      print("📩 Profile API Response: $response");
      if (response != null) {
        if (response['data'] != null && response['data'] is Map<String, dynamic>) {
          profileData.value = response['data'];
        } else if (response['user'] != null && response['user'] is Map<String, dynamic>) {
          profileData.value = response['user'];
        } else if (response is Map<String, dynamic>) {
          profileData.value = response;
        }
        // Clear local path — network image from API takes over
        localProfileImagePath.value = null;
      }
    } catch (e) {
      print("❌ Error in getProfileApi: $e");
    } finally {
      isProfileLoading(false);
    }
  }

  Future<void> getBannersApi({required BuildContext context}) async {
    try {
      isBannerLoading(true);
      print("🚀 Calling Banners API: $bannersUrl");
      var response = await ApiBaseHelper().getApiCall(
        false,
        bannersUrl,
        context,
      );
      print("📩 Banners API Response: $response");
      if (response != null) {
        if (response['data'] != null && response['data'] is List) {
          bannerList.value = response['data'];
        } else if (response['banners'] != null && response['banners'] is List) {
          bannerList.value = response['banners'];
        } else if (response is List) {
          bannerList.value = response;
        }
      }
    } catch (e) {
      print("❌ Error in getBannersApi: $e");
    } finally {
      isBannerLoading(false);
    }
  }

  Future<void> sendOtpApi({
    required BuildContext context,
    required String mobileNumber,
    required VoidCallback onSuccess,
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) isLoading(true);
      Map<String, dynamic> body = {"phone": mobileNumber};
      var response = await ApiBaseHelper().postApiCall(
        false,
        loginUrl,
        context,
        body,
      );

      if (response != null &&
          (response['status'] == true ||
           response['success'] == true ||
           response['status'] == 1 ||
           response['statusCode'] == 200) &&
          response['status'] != false &&
          response['success'] != false) {
        Fluttertoast.showToast(
          msg: response['message']?.toString() ?? "OTP Sent Successfully",
          gravity: ToastGravity.CENTER,
          backgroundColor: primaryColor,
          textColor: Colors.white,
        );
        onSuccess();
      } else if (response != null) {
        String msg = response['message']?.toString() ??
            response['error']?.toString() ??
            "Failed to send OTP";
        if (msg.toLowerCase().contains("not found") ||
            msg.toLowerCase().contains("not exist") ||
            msg.toLowerCase().contains("not registered") ||
            msg.toLowerCase().contains("unregistered")) {
         // msg = "User not found. Please register.";
        }
        Fluttertoast.showToast(
          msg: msg,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print("Error in sendOtpApi: $e");
    } finally {
      if (showLoading) isLoading(false);
    }
  }

  Future<void> verifyOtpApi({
    required BuildContext context,
    required String mobileNumber,
    required String otp,
    required String fcmToken,
    required VoidCallback onSuccess,
  }) async {
    try {
      isLoading(true);
      Map<String, dynamic> body = {"phone": mobileNumber, "otp": otp,"fcm_token":fcmToken};
      var response = await ApiBaseHelper().postApiCall(
        false,
        verifyOtpUrl,
        context,
        body,
      );

      print("📩 Verify OTP Response: $response");

      String? token;
      if (response != null && response is Map) {
        if (response['token'] != null &&
            response['token'].toString().isNotEmpty &&
            response['token'].toString() != "null") {
          token = response['token'].toString();
        } else if (response['access_token'] != null &&
            response['access_token'].toString().isNotEmpty &&
            response['access_token'].toString() != "null") {
          token = response['access_token'].toString();
        } else if (response['data'] is Map &&
            response['data']['token'] != null &&
            response['data']['token'].toString().isNotEmpty &&
            response['data']['token'].toString() != "null") {
          token = response['data']['token'].toString();
        }
      }

      var status = response is Map ? response['status'] : null;
      var success = response is Map ? response['success'] : null;

      bool isStatusFailure = status == false ||
          status == "false" ||
          status == "False" ||
          status == 0 ||
          status == "0" ||
          status == "failed" ||
          status == "Failed" ||
          status == "error" ||
          status == "Error" ||
          success == false ||
          success == "false" ||
          success == "False" ||
          success == 0 ||
          success == "0";

      bool isSuccess = response != null &&
          !isStatusFailure &&
          token != null &&
          token.isNotEmpty;

      if (isSuccess) {
        await sp?.putString(SpUtil.ACCESS_TOKEN, token);
        await sp?.putBool(SpUtil.IS_LOGGED_IN, true);

        Fluttertoast.showToast(
          msg: "OTP verified successfully.",
          gravity: ToastGravity.CENTER,
          backgroundColor: primaryColor,
          textColor: Colors.white,
        );
        onSuccess();
      } else {
        await sp?.putBool(SpUtil.IS_LOGGED_IN, false);
        await sp?.putString(SpUtil.ACCESS_TOKEN, "");

        if (response != null && response is Map) {
          String rawMsg = response['message']?.toString() ??
              response['error']?.toString() ??
              "Invalid OTP. Please try again.";

          int firstBrace = rawMsg.indexOf('{');
          int lastBrace = rawMsg.lastIndexOf('}');
          if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
            try {
              String jsonSub = rawMsg.substring(firstBrace, lastBrace + 1);
              var decoded = jsonDecode(jsonSub);
              if (decoded is Map) {
                rawMsg = decoded['message']?.toString() ??
                    decoded['error']?.toString() ??
                    decoded['msg']?.toString() ??
                    rawMsg;
              }
            } catch (_) {}
          }
          rawMsg = rawMsg.trim();
          if (rawMsg.toLowerCase() == "invalid" || rawMsg.toLowerCase().contains("invalid otp")) {
            rawMsg = "Invalid OTP. Please try again.";
          }
          Fluttertoast.showToast(
            msg: rawMsg,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      }
    } catch (e) {
      print("Error in verifyOtpApi: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<dynamic> registerUserApi({
    required BuildContext context,
    required String name,
    required String email,
    required String phone,
    required VoidCallback onSuccess,
  }) async {
    try {
      isLoading(true);
      Map<String, dynamic> body = {
        "name": name,
        "email": email,
        "phone": phone,
      };

      var response = await ApiBaseHelper().postApiCall(
        false,
        registerUrl,
        context,
        body,
      );

      print("Register User Response: $response");

      String? token;
      if (response != null && response is Map) {
        if (response['token'] != null &&
            response['token'].toString().isNotEmpty &&
            response['token'].toString() != "null") {
          token = response['token'].toString();
        } else if (response['access_token'] != null &&
            response['access_token'].toString().isNotEmpty &&
            response['access_token'].toString() != "null") {
          token = response['access_token'].toString();
        } else if (response['data'] is Map &&
            response['data']['token'] != null &&
            response['data']['token'].toString().isNotEmpty &&
            response['data']['token'].toString() != "null") {
          token = response['data']['token'].toString();
        }
      }

      var status = response is Map ? response['status'] : null;
      var success = response is Map ? response['success'] : null;

      bool isStatusFailure = status == false ||
          status == "false" ||
          status == "False" ||
          status == 0 ||
          status == "0" ||
          status == "failed" ||
          status == "Failed" ||
          status == "error" ||
          status == "Error" ||
          success == false ||
          success == "false" ||
          success == "False" ||
          success == 0 ||
          success == "0";

      bool isSuccess = response != null &&
          !isStatusFailure &&
          (token != null && token.isNotEmpty ||
           status == true ||
           status == "true" ||
           success == true ||
           success == "true");

      if (isSuccess) {
        if (token != null && token.isNotEmpty) {
          await sp?.putString(SpUtil.ACCESS_TOKEN, token);
          await sp?.putBool(SpUtil.IS_LOGGED_IN, true);
        }

        Fluttertoast.showToast(
          msg: response['message']?.toString() ?? "Registration Successful",
          gravity: ToastGravity.CENTER,
          backgroundColor: blueColor,
          textColor: Colors.white,
        );
        onSuccess();
        return response;
      } else if (response != null) {
        String errorMsg = response['message']?.toString() ??
            response['error']?.toString() ??
            "Registration failed";
        if (errorMsg.startsWith('{') && errorMsg.endsWith('}')) {
          try {
            var decoded = jsonDecode(errorMsg);
            if (decoded is Map && decoded['message'] != null) {
              errorMsg = decoded['message'].toString();
            }
          } catch (_) {}
        }
        Fluttertoast.showToast(
          msg: errorMsg,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return null;
      }
      return null;
    } catch (e) {
      print("Error in registerUserApi: $e");
      return null;
    } finally {
      isLoading(false);
    }
  }

  Future<dynamic> updateProfileApi({
    required BuildContext context,
    required String name,
    required String email,
    String? profileImage,
    required VoidCallback onSuccess,
  }) async {
    try {
      isLoading(true);
      Map<String, String> fields = {
        "name": name,
        "email": email,
      };

      print("==========================================================");
      print("🚀 [UPDATE PROFILE MULTIPART REQUEST]");
      print("   URL: ${BASE_URL + updateProfileUrl}");
      print("   FIELDS: $fields");
      print("   PROFILE IMAGE PATH: $profileImage");
      print("==========================================================");

      var response = await ApiBaseHelper().postMultipartApiCall(
        false,
        updateProfileUrl,
        context,
        fields,
        fileKey: "profile_image",
        filePath: profileImage,
      );

      print("==========================================================");
      print("📩 [UPDATE PROFILE RESPONSE]: $response");
      print("==========================================================");

      if (response != null &&
          (response['status'] == true ||
           response['success'] == true ||
           response['status'] == 1 ||
           response['statusCode'] == 200 ||
           response['user'] != null ||
           response['message'] != null)) {

        // Immediately show the new local image in the header
        if (profileImage != null && profileImage.isNotEmpty) {
          localProfileImagePath.value = profileImage;
        }

        Fluttertoast.showToast(
          msg: response['message']?.toString() ?? "Profile Updated Successfully",
          gravity: ToastGravity.CENTER,
          backgroundColor: primaryColor,
          textColor: Colors.white,
        );
        getProfileApi(context: context);
        onSuccess();
        return response;
      } else {
        String errorMsg = response?['message']?.toString() ??
            response?['error']?.toString() ??
            "Failed to update profile";
        Fluttertoast.showToast(
          msg: errorMsg,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return null;
      }
    } catch (e) {
      print("Error in updateProfileApi: $e");
      Fluttertoast.showToast(
        msg: "Something went wrong: $e",
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return null;
    } finally {
      isLoading(false);
    }
  }

  Future<dynamic> getCmsContentApi({
    required BuildContext context,
    required String key,
  }) async {
    try {
      isLoading(true);
      print("🚀 [CMS API REQUEST]: ${BASE_URL + cmsUrl + key}");
      var response = await ApiBaseHelper().getApiCall(
        false,
        "$cmsUrl$key",
        context,
      );
      print("📩 [CMS API RESPONSE]: $response");
      return response;
    } catch (e) {
      print("Error in getCmsContentApi: $e");
      return null;
    } finally {
      isLoading(false);
    }
  }

  Future<void> logoutApi({required BuildContext context}) async {
    try {
      isLoading(true);
      print("🚀 Calling Logout API: $logoutUrl");
      var response = await ApiBaseHelper().postApiCall(
        true,
        logoutUrl,
        context,
        {},
      );
      print("📩 Logout API Response: $response");
      if (response != null && response['message'] != null) {
        Fluttertoast.showToast(
          msg: response['message'].toString(),
          gravity: ToastGravity.CENTER,
          backgroundColor: primaryColor,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print("❌ Error in logoutApi: $e");
    } finally {
      await sp?.clear();
      isLoading(false);
      Get.offAll(() => const OnboardingScreen());
    }
  }

  Future<dynamic> submitEnquiryApi({
    required BuildContext context,
    required String category,
    required String subject,
    required String description,
  }) async {
    try {
      isLoading(true);
      Map<String, dynamic> body = {
        "category": category,
        "subject": subject,
        "description": description,
      };

      print("==========================================================");
      print("🚀 [SUBMIT ENQUIRY REQUEST]");
      print("   URL: ${BASE_URL + helpEnquiriesUrl}");
      print("   BODY: $body");
      print("==========================================================");

      var response = await ApiBaseHelper().postApiCall(
        true,
        helpEnquiriesUrl,
        context,
        body,
      );

      print("==========================================================");
      print("📩 [SUBMIT ENQUIRY RESPONSE]: $response");
      print("==========================================================");

      return response;
    } catch (e) {
      print("❌ Error in submitEnquiryApi: $e");
      String cleanErr = e.toString().replaceAll(RegExp(r'^Exception:\s*'), '');
      if (cleanErr.isNotEmpty) {
        Fluttertoast.showToast(
          msg: cleanErr,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
      return null;
    } finally {
      isLoading(false);
    }
  }

  var isFaqLoading = false.obs;
  var faqList = <Map<String, String>>[].obs;
  var companyEmail = "".obs;
  var companyContact = "".obs;

  Future<List<Map<String, String>>> getFaqsApi({required BuildContext context}) async {
    try {
      isFaqLoading(true);
      print("==========================================================");
      print("🚀 [GET FAQS REQUEST]: ${BASE_URL + faqsUrl}");
      print("==========================================================");

      var response = await ApiBaseHelper().getApiCall(
        true,
        faqsUrl,
        context,
      );

      print("==========================================================");
      print("📩 [GET FAQS RESPONSE]: $response");
      print("==========================================================");

      faqList.clear();
      List rawList = [];

      if (response != null && response is Map) {
        if (response['company_email'] != null) {
          companyEmail.value = response['company_email'].toString();
        }
        if (response['company_contact'] != null) {
          companyContact.value = response['company_contact'].toString();
        }

        if (response['faqs'] != null && response['faqs'] is List) {
          rawList = response['faqs'];
        } else if (response['data'] != null && response['data'] is List) {
          rawList = response['data'];
        }
      } else if (response != null && response is List) {
        rawList = response;
      }

      for (var item in rawList) {
        if (item is Map) {
          if (item['is_active'] == 0 || item['is_active'] == '0' || item['is_active'] == false) {
            continue;
          }

          String question = item['question']?.toString() ??
              item['title']?.toString() ??
              item['faq_question']?.toString() ??
              "";
          String answer = item['answer']?.toString() ??
              item['description']?.toString() ??
              item['content']?.toString() ??
              item['faq_answer']?.toString() ??
              "";

          answer = answer
              .replaceAll(RegExp(r'<[^>]*>'), '')
              .replaceAll('&nbsp;', ' ')
              .replaceAll('&amp;', '&')
              .replaceAll('&lt;', '<')
              .replaceAll('&gt;', '>')
              .trim();

          if (question.isNotEmpty) {
            faqList.add({
              "question": question,
              "answer": answer.isNotEmpty ? answer : "No answer details available.",
            });
          }
        }
      }

      return faqList;
    } catch (e) {
      print("❌ Error in getFaqsApi: $e");
      return faqList;
    } finally {
      isFaqLoading(false);
    }
  }
}
