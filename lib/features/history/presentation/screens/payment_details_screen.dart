import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/transaction_model.dart';
import '../widgets/payment_receipt_widget.dart';

class PaymentDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? transactionData;

  const PaymentDetailsScreen({super.key, this.transactionData});

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  final GlobalKey _receiptKey = GlobalKey();
  bool _isSharing = false;

  void _copyToClipboard(String value, String label) {
    if (value.trim().isEmpty) return;
    Clipboard.setData(ClipboardData(text: value));
    Fluttertoast.showToast(
      msg: "$label copied to clipboard",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColors.black,
      textColor: AppColors.white,
    );
  }

  String _formatAmount(double amount) {
    String val = amount.toStringAsFixed(2);
    List<String> parts = val.split(".");
    String whole = parts[0];
    String res = "";
    int len = whole.length;
    if (len > 3) {
      res = whole.substring(len - 3);
      whole = whole.substring(0, len - 3);
      while (whole.length > 2) {
        res = "${whole.substring(whole.length - 2)},$res";
        whole = whole.substring(0, whole.length - 2);
      }
      if (whole.isNotEmpty) {
        res = "$whole,$res";
      }
    } else {
      res = whole;
    }
    return "$res.${parts[1]}";
  }

  String _amountToWords(double amount) {
    if (amount <= 0) return "Rupees Zero Only";
    int integerPart = amount.floor();
    int paisaPart = ((amount - integerPart) * 100).round();

    String convertThreeDigits(int n) {
      final units = [
        "",
        "One",
        "Two",
        "Three",
        "Four",
        "Five",
        "Six",
        "Seven",
        "Eight",
        "Nine",
        "Ten",
        "Eleven",
        "Twelve",
        "Thirteen",
        "Fourteen",
        "Fifteen",
        "Sixteen",
        "Seventeen",
        "Eighteen",
        "Nineteen",
      ];
      final tens = [
        "",
        "",
        "Twenty",
        "Thirty",
        "Forty",
        "Fifty",
        "Sixty",
        "Seventy",
        "Eighty",
        "Ninety",
      ];
      String str = "";
      if (n >= 100) {
        str += "${units[n ~/ 100]} Hundred ";
        n %= 100;
      }
      if (n >= 20) {
        str += "${tens[n ~/ 10]} ";
        n %= 10;
      }
      if (n > 0) {
        str += "${units[n]} ";
      }
      return str.trim();
    }

    String res = "";
    int crores = integerPart ~/ 10000000;
    integerPart %= 10000000;
    int lakhs = integerPart ~/ 100000;
    integerPart %= 100000;
    int thousands = integerPart ~/ 1000;
    integerPart %= 1000;

    if (crores > 0) res += "${convertThreeDigits(crores)} Crore ";
    if (lakhs > 0) res += "${convertThreeDigits(lakhs)} Lakh ";
    if (thousands > 0) res += "${convertThreeDigits(thousands)} Thousand ";
    if (integerPart > 0) res += convertThreeDigits(integerPart);

    res = res.trim();
    if (res.isEmpty) res = "Zero";

    String resultStr = "Rupees $res";
    if (paisaPart > 0) {
      resultStr += " and ${convertThreeDigits(paisaPart)} Paisa";
    }
    return "$resultStr Only";
  }

  String _formatDateTime(dynamic rawDate) {
    if (rawDate == null || rawDate.toString().isEmpty) {
      return DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());
    }
    String strDate = rawDate.toString().trim();
    try {
      DateTime? parsed = DateTime.tryParse(strDate);
      if (parsed != null) {
        return DateFormat('dd MMM yyyy, hh:mm a').format(parsed.toLocal());
      }
    } catch (_) {}

    return strDate;
  }

  Future<void> _shareReceiptImage({
    required String status,
    required String amount,
    required String toName,
    required String toSub,
    required String refId,
    required String orderId,
    required String date,
    required String note,
    required String type,
    required String amountInWords,
  }) async {
    if (_isSharing) return;
    setState(() => _isSharing = true);

    try {
      await Future.delayed(const Duration(milliseconds: 100));
      final boundary =
          _receiptKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) {
        Fluttertoast.showToast(msg: "Failed to render receipt image");
        return;
      }

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        Fluttertoast.showToast(msg: "Failed to process receipt image");
        return;
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final String fileName =
          "jigropay_receipt_${DateTime.now().millisecondsSinceEpoch}.png";
      final File imgFile = File('${tempDir.path}/$fileName');
      await imgFile.writeAsBytes(pngBytes);

      await Share.shareXFiles(
        [XFile(imgFile.path)],
        text: "JigroPay Payment Receipt - $toName",
        subject: "JigroPay Payment Receipt - $toName",
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "Error sharing receipt: $e");
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.transactionData ?? {};
    final tx = TransactionModel.fromJson(item);

    double numericAmount = tx.amount;
    String formattedAmountStr = _formatAmount(numericAmount);

    bool isSuccess = tx.isSuccess;
    bool isFailed = tx.isFailed;
    bool isPending = tx.isPending;
    bool hideRefAndOrderId = isPending || isFailed;

    String consumerNo = tx.number ?? "";
    String categoryName = tx.categoryName ?? tx.operator ?? "";

    String type = tx.displayType;
    String iconUrl = tx.displayIconUrl;
    String operatorCode = tx.displayOperatorCode;
    String paymentId = tx.displayPaymentId;
    String orderId = tx.displayOrderId;

    String toName = categoryName;

    String toSub = consumerNo.isNotEmpty ? "Account - $consumerNo" : type;

    String formattedDate = _formatDateTime(tx.createdAt);

    String noteStr =
        item['note']?.toString() ??
        item['description']?.toString() ??
        "\"Paid To ${toName.toUpperCase()}\"";

    String statusText = isSuccess
        ? "Payment Successful"
        : isFailed
        ? "Payment Failed"
        : "Payment Pending";

    return Scaffold(
      backgroundColor: const Color(0xffF4F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xffF4F5F7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: _isSharing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                  )
                : const Icon(
                    Icons.share_outlined,
                    color: AppColors.black,
                    size: 22,
                  ),
            onPressed: _isSharing
                ? null
                : () {
                    _shareReceiptImage(
                      status: statusText,
                      amount: formattedAmountStr,
                      toName: toName,
                      toSub: toSub,
                      refId: "",
                      orderId: hideRefAndOrderId ? "" : orderId,
                      date: formattedDate,
                      note: noteStr,
                      type: type,
                      amountInWords: _amountToWords(numericAmount),
                    );
                  },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: RepaintBoundary(
          key: _receiptKey,
          child: PaymentReceiptWidget(
            status: statusText,
            amount: formattedAmountStr,
            toName: toName,
            toSub: toSub,
            refId: null,
            orderId: hideRefAndOrderId ? "" : orderId,
            paymentId: hideRefAndOrderId ? "" : paymentId,
            iconUrl: iconUrl,
            type: type,
            operatorCode: operatorCode,
            date: formattedDate,
            note: noteStr,
            amountInWords: _amountToWords(numericAmount),
            onCopyOrderId: (hideRefAndOrderId || orderId.isEmpty)
                ? null
                : () => _copyToClipboard(orderId, "Order ID"),
            onCopyPaymentId: (hideRefAndOrderId || paymentId.isEmpty)
                ? null
                : () => _copyToClipboard(paymentId, "Razorpay Payment ID"),
          ),
        ),
      ),
    );
  }
}
