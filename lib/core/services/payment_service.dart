import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../utils/api_message_cleaner.dart';

// ── Result types ─────────────────────────────────────────────────────────────

/// Sealed result returned by [PaymentService.openCheckout].
sealed class PaymentResult {
  const PaymentResult();
}

final class PaymentSuccess extends PaymentResult {
  const PaymentSuccess({
    required this.paymentId,
    required this.orderId,
    required this.signature,
  });
  final String paymentId;
  final String orderId;
  final String signature;
}

final class PaymentFailure extends PaymentResult {
  const PaymentFailure({required this.message, this.code});
  final String message;
  final int? code;
}

final class PaymentDismissed extends PaymentResult {
  const PaymentDismissed();
}

// ── Service ───────────────────────────────────────────────────────────────────

/// Razorpay payment gateway service.
///
/// Replaces [RazorpayHelper]. Key improvements:
/// - **No [BuildContext]** — returns a [Future<PaymentResult>] instead.
/// - **No GetX** — uses a completer for result passing.
/// - Caller (Cubit) handles navigation and toasts based on the result type.
/// - Lifecycle: call [dispose()] when the containing widget is disposed.
class PaymentService {
  PaymentService({Razorpay? razorpay}) : _razorpay = razorpay {
    if (_razorpay != null) {
      _initListeners(_razorpay!);
    }
  }

  Razorpay? _razorpay;
  Completer<PaymentResult>? _completer;

  void _ensureInitialized() {
    if (_razorpay == null) {
      _razorpay = Razorpay();
      _initListeners(_razorpay!);
    }
  }

  void _initListeners(Razorpay rzp) {
    rzp.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onSuccess);
    rzp.on(Razorpay.EVENT_PAYMENT_ERROR, _onError);
    rzp.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
  }

  // ── Public API ────────────────────────────────────────────────────────────────

  /// Opens the Razorpay checkout UI.
  ///
  /// [apiKey] — Razorpay key from server order response (falls back to build env key).
  /// [orderId] — Razorpay order ID from [createOrder] API.
  /// [amountInPaise] — Amount in paise (1 INR = 100 paise).
  Future<PaymentResult> openCheckout({
    required int amountInPaise,
    required String orderId,
    String? apiKey,
    String name = 'JigroPay',
    String description = 'Service Payment',
    String? contactNumber,
    String? email,
  }) {
    // Cancel any pending checkout
    _completer?.complete(const PaymentDismissed());
    _completer = Completer<PaymentResult>();

    final effectiveKey = (apiKey != null && apiKey.isNotEmpty)
        ? apiKey
        : _razorpayLiveKey;

    final options = {
      'key': effectiveKey,
      'amount': amountInPaise > 0 ? amountInPaise : 100,
      'name': name.isNotEmpty ? name : 'JigroPay',
      'description': description.isNotEmpty ? description : 'Service Payment',
      if (orderId.isNotEmpty) 'order_id': orderId,
      'retry': {'enabled': true},
      'send_sms_hash': true,
      'prefill': {
        'contact': (contactNumber != null && contactNumber.isNotEmpty)
            ? contactNumber
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
      _ensureInitialized();
      _razorpay!.open(options);
    } catch (e) {
      final msg = cleanApiMessage(e);
      _completer!.complete(
        PaymentFailure(message: msg.isNotEmpty ? msg : 'Failed to open payment.'),
      );
    }

    return _completer!.future;
  }

  /// Must be called in the widget's [dispose] method to release Razorpay resources.
  void dispose() {
    _completer?.complete(const PaymentDismissed());
    _completer = null;
    try {
      _razorpay?.clear();
    } catch (e) {
      debugPrint('[PaymentService] dispose error: $e');
    }
  }

  // ── Private event handlers ────────────────────────────────────────────────────

  void _onSuccess(PaymentSuccessResponse response) {
    _completer?.complete(
      PaymentSuccess(
        paymentId: response.paymentId ?? '',
        orderId: response.orderId ?? '',
        signature: response.signature ?? '',
      ),
    );
    _completer = null;
  }

  void _onError(PaymentFailureResponse response) {
    final msg = cleanApiMessage(response.message);
    _completer?.complete(
      PaymentFailure(
        message: msg.isNotEmpty ? msg : 'Payment was cancelled or failed.',
        code: response.code,
      ),
    );
    _completer = null;
  }

  void _onExternalWallet(ExternalWalletResponse response) {
    debugPrint('[PaymentService] External wallet: ${response.walletName}');
    // External wallets complete asynchronously — keep completer open.
    // The result will be a dismissal from the user's perspective.
    _completer?.complete(const PaymentDismissed());
    _completer = null;
  }
}

// ── Razorpay key ─────────────────────────────────────────────────────────────
// ⚠️  SECURITY: Move to --dart-define build variable in CI/CD pipeline.
// e.g. flutter build apk --dart-define=RAZORPAY_KEY=rzp_live_...
// Then use: const String.fromEnvironment('RAZORPAY_KEY', defaultValue: '')
const String _razorpayLiveKey =
    String.fromEnvironment('RAZORPAY_KEY', defaultValue: 'rzp_live_TLKy91eX8x6Xum');
