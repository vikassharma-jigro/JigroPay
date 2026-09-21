import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/category_utils.dart';
import 'payment_receipt_widget.dart';

class PaymentDetailsScreen extends StatefulWidget {
  final dynamic transactionData;

  const PaymentDetailsScreen({super.key, this.transactionData});

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  final GlobalKey _receiptKey = GlobalKey();
  bool _isSharing = false;

  // Helper to convert numeric amount to Indian currency words
  String _amountToWords(double amount) {
    if (amount <= 0) return "Rupees Zero Only";
    int integerPart = amount.floor();
    int paisaPart = ((amount - integerPart) * 100).round();

    String words = _convertNumberToWords(integerPart);
    String result = "Rupees $words";
    if (paisaPart > 0) {
      String paisaWords = _convertNumberToWords(paisaPart);
      result += " and $paisaWords Paise";
    }
    return "$result Only";
  }

  String _convertNumberToWords(int number) {
    if (number == 0) return "Zero";

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

    if (number < 20) return units[number];
    if (number < 100) {
      return tens[number ~/ 10] +
          (number % 10 != 0 ? " ${units[number % 10]}" : "");
    }
    if (number < 1000) {
      return "${units[number ~/ 100]} Hundred${number % 100 != 0 ? " ${_convertNumberToWords(number % 100)}" : ""}";
    }
    if (number < 100000) {
      return "${_convertNumberToWords(number ~/ 1000)} Thousand${number % 1000 != 0 ? " ${_convertNumberToWords(number % 1000)}" : ""}";
    }
    if (number < 10000000) {
      return "${_convertNumberToWords(number ~/ 100000)} Lakh${number % 100000 != 0 ? " ${_convertNumberToWords(number % 100000)}" : ""}";
    }
    return "${_convertNumberToWords(number ~/ 10000000)} Crore${number % 10000000 != 0 ? " ${_convertNumberToWords(number % 10000000)}" : ""}";
  }

  String _formatAmount(dynamic rawAmount) {
    if (rawAmount == null) return "36";
    double amount = double.tryParse(rawAmount.toString()) ?? 0.0;
    if (amount == amount.toInt()) {
      return amount.toInt().toString();
    }
    return amount.toStringAsFixed(2);
  }

  String _formatDateTime(dynamic rawDate) {
    if (rawDate == null || rawDate.toString().isEmpty) {
      return DateFormat('dd MMM, hh:mm a').format(DateTime.now());
    }

    String strDate = rawDate.toString().trim();
    try {
      DateTime? parsedDate = DateTime.tryParse(strDate);
      if (parsedDate != null) {
        return DateFormat('dd MMM, hh:mm a').format(parsedDate.toLocal());
      }
    } catch (_) {}

    if (int.tryParse(strDate) != null) {
      try {
        int ts = int.parse(strDate);
        if (ts < 10000000000) ts *= 1000;
        DateTime dt = DateTime.fromMillisecondsSinceEpoch(ts);
        return DateFormat('dd MMM, hh:mm a').format(dt);
      } catch (_) {}
    }

    return strDate;
  }

  void _copyToClipboard(String textToCopy, String label) {
    Clipboard.setData(ClipboardData(text: textToCopy));
    Fluttertoast.showToast(
      msg: "$label copied to clipboard",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: blackColor,
      textColor: white,
    );
  }

  Future<void> _shareReceiptImage({
    required String status,
    required String amount,
    required String toName,
    required String toSub,
    String? refId,
    String? orderId,
    required String date,
    String? note,
    String? type,
    String? amountInWords,
  }) async {
    if (_isSharing) return;

    setState(() {
      _isSharing = true;
    });

    try {
      await WidgetsBinding.instance.endOfFrame;

      RenderRepaintBoundary? boundary =
          _receiptKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) {
        Fluttertoast.showToast(msg: "Unable to generate receipt image");
        return;
      }

      if (boundary.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 100));
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
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.transactionData ?? {};

    // Extract values with sensible fallbacks for best presentation
    dynamic rawAmount =
        item['amount'] ?? item['paid_amount'] ?? item['total_amount'] ?? 36;
    double numericAmount = double.tryParse(rawAmount.toString()) ?? 36.0;
    String formattedAmountStr = _formatAmount(numericAmount);

    String statusStr = (item['status'] ?? item['payment_status'] ?? 'Success')
        .toString();
    bool isSuccess =
        statusStr.toLowerCase() == 'success' ||
        statusStr == '1' ||
        statusStr == 'true' ||
        statusStr.toLowerCase() == 'successful';

    bool isFailed =
        statusStr.toLowerCase() == 'failed' ||
        statusStr.toLowerCase() == 'failure' ||
        statusStr.toLowerCase() == 'error' ||
        statusStr == '0' ||
        statusStr.toLowerCase() == 'false';

    bool isPending =
        statusStr.toLowerCase() == 'pending' ||
        statusStr.toLowerCase() == 'processing' ||
        statusStr.toLowerCase() == 'in_progress' ||
        statusStr == '2' ||
        (!isSuccess && !isFailed);

    bool hideRefAndOrderId = isPending || isFailed;

    String consumerNo =
        item['consumer_number']?.toString() ??
        item['number']?.toString() ??
        item['mobile']?.toString() ??
        item['account_no']?.toString() ??
        "";

    // Category / Provider name (e.g., "Airtel")
    String categoryName = CategoryUtils.extractCategoryName(item);

    // Type of payment formatted into clean Normal text (e.g. mobile_operator -> "Mobile Operator")
    String type = CategoryUtils.extractAndFormatCategoryType(item);

    // Icon URL and operator code
    String iconUrl = CategoryUtils.extractIconUrl(item);
    String operatorCode = CategoryUtils.extractOperatorCode(item);

    String categoryOrTitle = categoryName.isNotEmpty
        ? categoryName
        : (item['category_name']?.toString() ??
              item['biller_name']?.toString() ??
              item['service_name']?.toString() ??
              item['name']?.toString() ??
              item['title']?.toString() ??
              (type.isNotEmpty ? type : ""));

    // Receiver details ("To:")
    String toName =
        item['receiver_name']?.toString() ??
        item['paid_to']?.toString() ??
        item['to']?.toString() ??
        (categoryName.isNotEmpty ? categoryName : null) ??
        "";
    if (toName.isEmpty) {
      if (categoryName.isNotEmpty) {
        toName = categoryName;
      } else if (categoryOrTitle.isNotEmpty) {
        toName = categoryOrTitle;
      } else if (type.isNotEmpty) {
        toName = type;
      } else {
        toName = "Payment Service";
      }
    }

    String toSub =
        item['to_details']?.toString() ??
        item['to_bank']?.toString() ??
        item['biller_id']?.toString() ??
        "";
    if (toSub.isEmpty) {
      if (consumerNo.isNotEmpty) {
        toSub = "Account - $consumerNo";
      } else if (type.isNotEmpty) {
        toSub = type;
      } else {
        toSub = "Payment Receipt";
      }
    }

    // Ref ID and Date
    String refId =
        item['upi_ref_id']?.toString() ??
        item['rrn']?.toString() ??
        item['ref_id']?.toString() ??
        item['txnid']?.toString() ??
        item['transaction_id']?.toString() ??
        item['razorpay_response']?['payment_id']?.toString() ??
        item['id']?.toString() ??
        "361316385061";

    // Order ID
    String orderId =
        item['upi_ref_id']?.toString() ??
        item['rrn']?.toString() ??
        item['ref_id']?.toString() ??
        item['txnid']?.toString() ??
        item['transaction_id']?.toString() ??
        item['razorpay_response']?['order_id']?.toString() ??
        item['id']?.toString() ??
        "361316385061";

    dynamic rawDate =
        item['created_at'] ??
        item['date'] ??
        item['created_date'] ??
        item['datetime'] ??
        item['time'] ??
        item['timestamp'] ??
        item['updated_at'] ??
        "04 Sep, 01:52 PM";

    String formattedDate = _formatDateTime(rawDate);

    // Custom Note / Pay quote
    String noteStr =
        item['note']?.toString() ??
        item['description']?.toString() ??
        item['remarks']?.toString() ??
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
            color: blackColor,
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
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: primaryColor,
                    ),
                  )
                : const Icon(Icons.share_outlined, color: blackColor, size: 22),
            onPressed: _isSharing
                ? null
                : () {
                    _shareReceiptImage(
                      status: statusText,
                      amount: formattedAmountStr,
                      toName: toName,
                      toSub: toSub,
                      refId: hideRefAndOrderId ? "" : refId,
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
            refId: hideRefAndOrderId ? "" : refId,
            orderId: hideRefAndOrderId ? "" : orderId,
            date: formattedDate,
            note: noteStr,
            type: type,
            amountInWords: _amountToWords(numericAmount),
            iconUrl: iconUrl,
            operatorCode: operatorCode,
            onCopyRefId: (hideRefAndOrderId || refId.isEmpty)
                ? null
                : () => _copyToClipboard(refId, "UPI Ref ID"),
            onCopyOrderId: (hideRefAndOrderId || orderId.isEmpty)
                ? null
                : () => _copyToClipboard(orderId, "Order ID"),
          ),
        ),
      ),
    );
  }
}
