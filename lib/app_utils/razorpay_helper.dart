import 'package:flutter/material.dart';
import 'package:jigrotech/core/config/env_configu.dart';
import 'package:jigrotech/core/mixins/ui_feedback_mixin.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../core/errors/result.dart';
import '../core/utils/api_message_cleaner.dart';
import '../features/recharge/data/repositories/recharge_repository_impl.dart';
import '../features/recharge/presentation/screens/payment_success_screen.dart';

//. RazorPay Key Constants
final razorpayKeyConstant = EnvConfig.razorpayLiveKey;

//. Helper
class RazorpayHelper with UiFeedbackMixin {
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

  //. Payment Flow
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

    final repo = RechargeRepositoryImpl();

    final orderResult = await repo.createOrder(
      opcode: opcode,
      number: number,
      amount: amount,
      type: type ?? this.type,
      fetchId: fetchId,
    );

    switch (orderResult) {
      case Success(:final data):
        openPayment(
          amount: amount,
          description: description,
          contact: number,
          orderId: data.razorpayOrderId.isNotEmpty
              ? data.razorpayOrderId
              : data.orderId,
          apiKey: data.razorpayKey,
        );
      case Error(:final failure):
        String apiMessage = cleanApiMessage(failure.message);
        if (apiMessage.isNotEmpty) {
          showErrorToast(apiMessage);
        }
    }
  }

  //. Open Payment Screen
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
    String activeKey = (apiKey != null && apiKey.isNotEmpty)
        ? apiKey
        : razorpayKeyConstant;

    var options = {
      'key': activeKey,
      'amount': amountInPaise > 0 ? amountInPaise : 100,
      'name': name.isNotEmpty ? name : 'JigroPay',
      'description': description.isNotEmpty ? description : 'Service Payment',
      if (orderId != null && orderId.isNotEmpty) 'order_id': orderId,
      'retry': {'enabled': true},
      'send_sms_hash': true,
      'prefill': {
        'contact': (contact != null && contact.isNotEmpty)
            ? contact
            : '9694870658',
        'email': (email != null && email.isNotEmpty)
            ? email
            : 'user@jigropay.com',
      },
      'external': {
        'wallets': ['paytm'],
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      showErrorToast("Error launching payment: $e");
    }
  }

  //. Handles Success Response
  void _handleSuccess(PaymentSuccessResponse response) async {
    final repo = RechargeRepositoryImpl();
    String paymentId = response.paymentId ?? "";
    String orderId = response.orderId ?? "";
    String signature = response.signature ?? "";

    // Always verify payment with backend
    await repo.verifyPayment(
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
          args: PaymentSuccessArgs(
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
      ),
    );
  }

  //. Handles Error Response
  void _handleError(PaymentFailureResponse response) {
    if (onFailure != null) {
      onFailure!(response);
    } else {
      String cleanMsg = cleanApiMessage(response.message);
      if (cleanMsg.isEmpty) cleanMsg = "Payment was cancelled or failed.";
      showErrorToast("Payment Failed: $cleanMsg");
    }
  }

  //. Handles External Response
  void _handleExternalWallet(ExternalWalletResponse response) {
    showLoadingToast("External Wallet Selected: ${response.walletName}");
  }

  //. Clear
  void clear() {
    _razorpay.clear();
  }
}
