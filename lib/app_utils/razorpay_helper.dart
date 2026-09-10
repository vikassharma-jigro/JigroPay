import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../api_services/api_base_helper.dart';
import '../api_services/api_config.dart';
import '../getx_controller/recharge_controller.dart';
import '../View/common/payment_success_screen.dart';

class RazorpayHelper {
  late Razorpay _razorpay;
  final BuildContext context;
  final String? type;
  final Function(PaymentSuccessResponse)? onSuccess;
  final Function(PaymentFailureResponse)? onFailure;

  // Extra metadata to show on success screen
  String _serviceName = 'Bill';
  String _providerName = 'Service Provider';
  String _consumerNumber = '';
  double _paidAmount = 0.0;
  String? _billMonth;
  String? _type;

  RazorpayHelper({
    required this.context,
    this.onSuccess,
    this.onFailure,
    this.type,
  }) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void startPaymentWithOrderFlow({
    required BuildContext context,
    required String opcode,
    required String number,
    required double amount,
    String description = 'Service Payment',
    String serviceName = 'Bill',
    String providerName = 'Service Provider',
    String? billMonth,
    String? type,
    String? fetchId,
    String? pan,
    String? card,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();
    // Store metadata for success screen
    _serviceName = serviceName;
    _providerName = providerName;
    _consumerNumber = number;
    _paidAmount = amount;
    _billMonth = billMonth;
    _type = type ?? this.type;

    final RechargeController rechargeController = Get.put(RechargeController());

    String reqAmount = amount > 0 
        ? (amount.toInt() == amount ? amount.toInt().toString() : amount.toString())
        : "10";

    print("🚀 [1. CREATE ORDER API] amount=$reqAmount, type=$type, fetch_id=$fetchId, pan=$pan, card=$card");
    var orderResponse = await rechargeController.createRechargeOrder(
      context: context,
      opcode: opcode,
      number: number,
      amount: reqAmount,
      type: type,
      fetchId: fetchId,
      pan: pan,
      card: card,
    );

    bool isSuccess = orderResponse != null &&
        (orderResponse['status'] == true ||
         orderResponse['status'] == 'Success' ||
         orderResponse['status'] == 'success' ||
         orderResponse['success'] == true ||
         orderResponse['status'] == 1 ||
         orderResponse['status'] == '1' ||
         orderResponse['statusCode'] == 200 ||
         orderResponse['statusCode'] == '200' ||
         orderResponse['order_id'] != null ||
         (orderResponse['data'] != null && (orderResponse['data']['order_id'] != null || orderResponse['data']['id'] != null))) &&
        (orderResponse['status'] != 'Failure' && orderResponse['status'] != false && orderResponse['status'] != 'false');

    if (isSuccess && orderResponse != null) {
      String orderId = orderResponse['order_id']?.toString() ??
          orderResponse['data']?['order_id']?.toString() ??
          orderResponse['data']?['id']?.toString() ??
          '';
      String? apiKey = orderResponse['key']?.toString() ??
          orderResponse['razorpay_key']?.toString() ??
          orderResponse['key_id']?.toString() ??
          orderResponse['data']?['key']?.toString() ??
          orderResponse['data']?['razorpay_key']?.toString() ??
          orderResponse['data']?['key_id']?.toString();

      print("🚀 [2. LAUNCHING RAZORPAY PAYMENT GATEWAY with order_id='$orderId', key='${apiKey ?? razorpayKeyConstant}']");

      openPayment(
        amount: amount,
        description: description,
        contact: number,
        orderId: orderId.isNotEmpty ? orderId : null,
        apiKey: apiKey,
      );
    } else {
      String apiMessage = cleanApiMessage(orderResponse);
      if (apiMessage.isNotEmpty) {
        Fluttertoast.showToast(
          msg: apiMessage,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
      print("❌ [CREATE ORDER API FAILED: $apiMessage]");
    }
  }

  void openPayment({
    required double amount,
    String name = 'JigroPay',
    String description = 'Service Payment',
    String? contact,
    String? email,
    String? orderId,
    String? apiKey,
  }) {
    int amountInPaise = (amount * 100).toInt();
    String activeKey = (apiKey != null && apiKey.isNotEmpty) ? apiKey : razorpayKeyConstant;

    var options = {
      'key': activeKey,
      'amount': amountInPaise > 0 ? amountInPaise : 100,
      'name': name.isNotEmpty ? name : 'JigroPay',
      'description': description.isNotEmpty ? description : 'Service Payment',
      if (orderId != null && orderId.isNotEmpty) 'order_id': orderId,
      'retry': {'enabled': true},
      'send_sms_hash': true,
      'prefill': {
        'contact': (contact != null && contact.isNotEmpty) ? contact : '9694870658',
        'email': (email != null && email.isNotEmpty) ? email : 'user@jigropay.com',
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error launching payment: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _handleSuccess(PaymentSuccessResponse response) async {
    print("🚀 [3. VERIFY PAYMENT API]");
    final RechargeController rechargeController = Get.put(RechargeController());
    String paymentId = response.paymentId ?? "";
    String orderId = response.orderId ?? "";
    String signature = response.signature ?? "";

    // Always verify payment with backend
    await rechargeController.verifyRechargePayment(
      context: context,
      razorpayPaymentId: paymentId,
      razorpayOrderId: orderId,
      razorpaySignature: signature,
      type: _type ?? type,
    );

    // Call optional caller-provided callback for any extra handling
    if (onSuccess != null) {
      onSuccess!(response);
    }

    // Always navigate to PaymentSuccessScreen
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentSuccessScreen(
          serviceName: _serviceName,
          providerName: _providerName,
          consumerNumber: _consumerNumber,
          amount: _paidAmount.toString(),
          transactionId: paymentId,
          orderId: orderId,
          billMonth: _billMonth,
          paidVia: 'Razorpay',
        ),
      ),
    );
  }

  void _handleError(PaymentFailureResponse response) {
    if (onFailure != null) {
      onFailure!(response);
    } else {
      Fluttertoast.showToast(
        msg: "Payment Failed: ${response.message}",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "External Wallet Selected: ${response.walletName}");
  }

  void clear() {
    _razorpay.clear();
  }
}
