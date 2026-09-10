import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../api_services/api_base_helper.dart';
import '../api_services/api_config.dart';

class RechargeController extends GetxController {
  var isLoading = false.obs;
  
  // Variables to hold operator data and plans
  var operatorData = {}.obs;
  var plansList = [].obs;
  var categorizedPlans = {}.obs;
  var rofferList = [].obs;
  
  // DTH specific
  var dthOperatorsList = [].obs;
  
  // Dynamic Operators
  var dynamicOperatorsList = [].obs;

  Future<void> fetchOperatorAndPlans({
    required BuildContext context,
    required String mobileNumber,
  }) async {
    try {
      isLoading(true);
      
      // 1. Fetch Operator
      Map<String, dynamic> operatorBody = {
        "mobile": mobileNumber
      };
      
      var operatorResponse = await ApiBaseHelper().postApiCall(
        false,
        operatorFetchUrl,
        context,
        operatorBody,
      );
      
      print("Operator Response: $operatorResponse");

      if (operatorResponse != null) {
        // Handle cases where data might be nested or direct
        var data = operatorResponse['data'] ?? operatorResponse;
        operatorData.value = data;
        
        // Ensure opcode and circle are available before fetching plans
        String opcode = data['mapped_opcode']?.toString() ?? data['company_code']?.toString() ?? "A"; 
        String circle = data['circle_code']?.toString() ?? data['circle']?.toString() ?? "DL";
        
        // 2. Fetch Plans
        await fetchRechargePlans(
          context: context, 
          mobileNumber: mobileNumber, 
          opcode: opcode, 
          circle: circle
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to fetch operator details",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print("Error in fetchOperatorAndPlans: $e");
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

  Future<void> fetchRechargePlans({
    required BuildContext context,
    required String mobileNumber,
    required String opcode,
    required String circle,
  }) async {
    try {
      Map<String, dynamic> planBody = {
        "mobile": mobileNumber,
        "opcode": opcode,
        "circle": circle,
        "is_dth": false,
        "is_roffer": false
      };
      
      var planResponse = await ApiBaseHelper().postApiCall(
        false,
        rechargePlansUrl,
        context,
        planBody,
      );
      
      print("Plan Response: $planResponse");

      if (planResponse != null) {
        // Assuming response structure has a 'data' array or is an array itself
        var data = planResponse['data'] ?? planResponse['plans'] ?? planResponse;
        if (data is Map) {
          Map<String, List> formattedMap = {};
          data.forEach((key, value) {
            if (value is List) {
              formattedMap[key.toString()] = value;
            }
          });
          categorizedPlans.value = formattedMap;
          if (formattedMap.isNotEmpty) {
            plansList.value = formattedMap.values.first;
          } else {
            plansList.value = [];
          }
        } else if (data is List) {
          categorizedPlans.value = {"All Plans": data};
          plansList.value = data;
        } else {
          categorizedPlans.value = {};
          plansList.value = [];
        }
      } else {
        Fluttertoast.showToast(
          msg: "Failed to fetch plans",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print("Error in fetchRechargePlans: $e");
      Fluttertoast.showToast(
        msg: "Something went wrong fetching plans: $e",
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> fetchRoffer({
    required BuildContext context,
    required String mobileNumber,
    required String opcode,
  }) async {
    try {
      isLoading(true);
      String orderId = DateTime.now().millisecondsSinceEpoch.toString();
      Map<String, dynamic> body = {
        "mobile": mobileNumber,
        "opcode": opcode,
        "orderid": orderId
      };
      
      var response = await ApiBaseHelper().postApiCall(
        false,
        rofferUrl,
        context,
        body,
      );
      
      print("Roffer Response: $response");

      if (response != null) {
        var data = response['data'] ?? response['plans'] ?? response['roffer'] ?? response;
        if (data is List) {
          rofferList.value = data;
        } else if (data is Map && data.values.isNotEmpty && data.values.first is List) {
          List allPlans = [];
          data.forEach((key, value) {
            if (value is List) {
              allPlans.addAll(value);
            }
          });
          rofferList.value = allPlans;
        } else {
          rofferList.value = [];
        }
      } else {
        Fluttertoast.showToast(
          msg: "Failed to fetch roffer plans",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print("Error in fetchRoffer: $e");
      Fluttertoast.showToast(
        msg: "Something went wrong fetching roffers: $e",
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchOperatorsByType({
    required BuildContext context,
    required String type,
  }) async {
    try {
      isLoading(true);
      dynamicOperatorsList.value = []; // clear previous
      
      String url = "$operatorsByTypeUrl$type";
      
      // Use getApiCall since it's a GET method
      var response = await ApiBaseHelper().getApiCall(
        false,
        url,
        context,
      );

      print("Operators List Response for $type: $response");

      if (response != null) {
        var data = response['data'] ?? response['operators'] ?? response;
        if (data is List) {
          dynamicOperatorsList.value = data;
        } else if (data is Map && data.values.isNotEmpty && data.values.first is List) {
          dynamicOperatorsList.value = data.values.first;
        } else {
          dynamicOperatorsList.value = [];
        }
      } else {
        Fluttertoast.showToast(
          msg: "Failed to fetch $type operators",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print("Error in fetchOperatorsByType ($type): $e");
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



  Future<void> fetchDthOperatorAndPlans({
    required BuildContext context,
    required String dthNumber,
  }) async {
    try {
      isLoading(true);
      
      // 1. Fetch DTH Operator
      Map<String, dynamic> operatorBody = {
        "dth_number": dthNumber
      };
      
      var operatorResponse = await ApiBaseHelper().postApiCall(
        false,
        dthOperatorFetchUrl,
        context,
        operatorBody,
      );
      
      print("DTH Operator Response: $operatorResponse");

      if (operatorResponse != null) {
        var data = operatorResponse['data'] ?? operatorResponse;
        
        // Ensure opcode is available before fetching plans
        String opcode = data['mapped_opcode']?.toString() ?? data['company_code']?.toString() ?? data['opcode']?.toString() ?? "ATV"; 
        String orderId = data['orderid']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
        
        // 2. Fetch Plans
        await fetchDthPlans(
          context: context, 
          dthNumber: dthNumber, 
          opcode: opcode,
          orderId: orderId,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to fetch DTH operator details",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print("Error in fetchDthOperatorAndPlans: $e");
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

  Future<void> fetchDthPlans({
    required BuildContext context,
    required String dthNumber,
    required String opcode,
    required String orderId,
  }) async {
    try {
      isLoading(true);
      Map<String, dynamic> planBody = {
        "dth_number": dthNumber,
        "opcode": opcode,
        "orderid": orderId
      };
      
      var planResponse = await ApiBaseHelper().postApiCall(
        false,
        dthRechargePlansUrl,
        context,
        planBody,
      );
      
      print("DTH Plan Response: $planResponse");

      if (planResponse != null) {
        var data = planResponse['data'] ?? planResponse['plans'] ?? planResponse;
        if (data is List) {
          plansList.value = data;
        } else if (data is Map && data.values.isNotEmpty && data.values.first is List) {
          List allPlans = [];
          data.forEach((key, value) {
            if (value is List) {
              allPlans.addAll(value);
            }
          });
          plansList.value = allPlans;
        } else {
          plansList.value = [];
        }
      } else {
        Fluttertoast.showToast(
          msg: "Failed to fetch DTH plans",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print("Error in fetchDthPlans: $e");
      Fluttertoast.showToast(
        msg: "Something went wrong fetching DTH plans: $e",
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<dynamic> fetchFastagBill({
    required BuildContext context,
    required String consumerId,
    required String opcode,
  }) async {
    try {
      isLoading(true);
      Map<String, dynamic> body = {
        "consumer_id": consumerId,
        "opcode": opcode,
      };
      
      var response = await ApiBaseHelper().postApiCall(
        false,
        fastagBillFetchUrl,
        context,
        body,
      );
      
      print("Fastag Bill Response: $response");
      return response;
    } catch (e) {
      print("Error in fetchFastagBill: $e");
      Fluttertoast.showToast(
        msg: "Something went wrong fetching Fastag Bill: $e",
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return null;
    } finally {
      isLoading(false);
    }
  }

  Future<dynamic> fetchUtilityBill({
    required BuildContext context,
    required String consumerId,
    required String opcode,
  }) async {
    try {
      isLoading(true);
      Map<String, dynamic> body = {
        "consumer_id": consumerId,
        "opcode": opcode,
      };
      
      var response = await ApiBaseHelper().postApiCall(
        false,
        utilityBillFetchUrl,
        context,
        body,
      );
      
      print("Utility Bill Response: $response");
      return response;
    } catch (e) {
      print("Error in fetchUtilityBill: $e");
      Fluttertoast.showToast(
        msg: "Something went wrong fetching Utility Bill: $e",
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return null;
    } finally {
      isLoading(false);
    }
  }

  Future<dynamic> createNsdlPan({
    required BuildContext context,
    required String mobileNumber,
  }) async {
    try {
      isLoading(true);
      Map<String, dynamic> body = {
        "mobile_number": mobileNumber,
      };

      var response = await ApiBaseHelper().postApiCall(
        false,
        nsdlNewPanUrl,
        context,
        body,
      );

      print("NSDL PAN Response: $response");
      return response;
    } catch (e) {
      print("Error in createNsdlPan: $e");
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

  Future<dynamic> fetchCreditCardBill({
    required BuildContext context,
    required String card,
    required String opcode,
    required String mobile,
  }) async {
    try {
      isLoading(true);
      Map<String, dynamic> body = {
        "card": card,
        "opcode": opcode,
        "mobile": mobile,
      };

      var response = await ApiBaseHelper().postApiCall(
        false,
        creditCardBillFetchUrl,
        context,
        body,
      );

      print("Credit Card Bill Response: $response");
      return response;
    } catch (e) {
      print("Error in fetchCreditCardBill: $e");
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

  Future<dynamic> createRechargeOrder({
    required BuildContext context,
    required String opcode,
    required String number,
    required String amount,
    String? type,
    String? fetchId,
    String? pan,
    String? card,
  }) async {
    try {
      isLoading(true);
      Map<String, dynamic> body = {
        "opcode": opcode,
        "number": number,
        "amount": amount,
        if (type != null && type.isNotEmpty) "type": type,
        if (fetchId != null && fetchId.isNotEmpty) "fetch_id": fetchId,
        if (pan != null && pan.isNotEmpty) "pan": pan,
        if (card != null && card.isNotEmpty) "card": card,
      };

      print("==========================================================");
      print("🚀 [CREATE RECHARGE ORDER REQUEST]");
      print("   URL: ${BASE_URL + createOrderUrl}");
      print("   PARAMS: opcode='$opcode', number='$number', amount='$amount'");
      print("==========================================================");

      var response = await ApiBaseHelper().postApiCall(
        true,
        createOrderUrl,
        context,
        body,
      );

      print("==========================================================");
      print("📩 [CREATE RECHARGE ORDER RESPONSE]: $response");
      print("==========================================================");
      return response;
    } catch (e) {
      print("❌ Error in createRechargeOrder: $e");
      String cleanErr = cleanApiMessage(e);
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

  Future<dynamic> verifyRechargePayment({
    required BuildContext context,
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
    String? type,
  }) async {
    try {
      isLoading(true);
      Map<String, dynamic> body = {
        "razorpay_payment_id": razorpayPaymentId,
        "razorpay_order_id": razorpayOrderId,
        "razorpay_signature": razorpaySignature,
        if (type != null && type.isNotEmpty) "type": type,
      };

      print("==========================================================");
      print("🚀 [VERIFY RECHARGE PAYMENT REQUEST]");
      print("   URL: ${BASE_URL + verifyPaymentUrl}");
      print("   PAYLOAD: $body");
      print("==========================================================");

      var response = await ApiBaseHelper().postApiCall(
        true,
        verifyPaymentUrl,
        context,
        body,
      );

      print("==========================================================");
      print("📩 [VERIFY RECHARGE PAYMENT RESPONSE]: $response");
      print("==========================================================");
      return response;
    } catch (e) {
      print("❌ Error in verifyRechargePayment: $e");
      String cleanErr = cleanApiMessage(e);
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
}
