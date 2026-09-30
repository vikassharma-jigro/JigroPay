import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jigrotech/core/mixins/ui_feedback_mixin.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/app_button.dart';

/// Arguments for navigating to [PaymentSuccessScreen].
class PaymentSuccessArgs {
  const PaymentSuccessArgs({
    required this.serviceName,
    required this.providerName,
    required this.consumerNumber,
    required this.amount,
    required this.transactionId,
    this.orderId,
    this.billMonth,
    this.paidVia,
    this.opcode,
  });

  final String serviceName;
  final String providerName;
  final String consumerNumber;
  final String amount;
  final String transactionId;
  final String? orderId;
  final String? billMonth;
  final String? paidVia;
  final String? opcode;
}

/// Clean-architecture Payment Success screen with PDF receipt generation & sharing.
class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key, required this.args});

  final PaymentSuccessArgs args;

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with TickerProviderStateMixin, UiFeedbackMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  bool _isGeneratingPdf = false;

  @override
  void initState() {
    super.initState();
    HapticFeedback.heavyImpact();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnim = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _fadeController.forward();
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  String _formattedDateTime() {
    return DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now());
  }

  String _effectiveTxnId() {
    if (widget.args.transactionId.isNotEmpty) {
      return widget.args.transactionId;
    }
    final rand = Random().nextInt(999999999);
    return 'TXN$rand';
  }

  Future<File> _generatePdfReceipt(
    String txnId,
    String dateTime,
    String paidVia,
  ) async {
    final pdf = pw.Document();
    final String amountStr =
        double.tryParse(widget.args.amount)?.toStringAsFixed(2) ??
        widget.args.amount;
    final String ticketId = txnId.replaceAll(RegExp(r'\D'), '');
    final String formattedTicketId = ticketId.isNotEmpty
        ? (ticketId.length > 13
              ? ticketId.substring(ticketId.length - 13)
              : ticketId.padLeft(13, '0'))
        : '0120034399434';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Container(
              width: 440,
              padding: const pw.EdgeInsets.all(24),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#FFFFFF'),
                borderRadius: pw.BorderRadius.circular(16),
                border: pw.Border.all(
                  color: PdfColor.fromHex('#E2E8F0'),
                  width: 1,
                ),
              ),
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Container(
                    width: 56,
                    height: 56,
                    decoration: pw.BoxDecoration(
                      shape: pw.BoxShape.circle,
                      color: PdfColor.fromHex('#FAF5FF'),
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#8C2AC4'),
                        width: 2.5,
                      ),
                    ),
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      '✓',
                      style: pw.TextStyle(
                        fontSize: 26,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex('#8C2AC4'),
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 12),
                  pw.Text(
                    'Thank you!',
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex('#0F172A'),
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Your payment has been completed successfully.',
                    style: pw.TextStyle(
                      fontSize: 11,
                      color: PdfColor.fromHex('#64748B'),
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.SizedBox(height: 16),
                  pw.Divider(
                    borderStyle: pw.BorderStyle.dashed,
                    color: PdfColor.fromHex('#CBD5E1'),
                    thickness: 1,
                  ),
                  pw.SizedBox(height: 16),
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#FAF5FF'),
                      borderRadius: pw.BorderRadius.circular(12),
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#E9D5FF'),
                        width: 1,
                      ),
                    ),
                    child: pw.Column(
                      children: [
                        pw.Text(
                          'Total Amount Paid',
                          style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColor.fromHex('#64748B'),
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'INR $amountStr',
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromHex('#8C2AC4'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 16),
                  _pdfDetailRow('Receipt ID', formattedTicketId),
                  _pdfDetailRow('Service Name', widget.args.serviceName),
                  _pdfDetailRow('Provider', widget.args.providerName),
                  _pdfDetailRow(
                    'Consumer / Mobile',
                    widget.args.consumerNumber,
                  ),
                  _pdfDetailRow('Transaction ID', txnId),
                  if (widget.args.orderId != null &&
                      widget.args.orderId!.isNotEmpty)
                    _pdfDetailRow('Order ID', widget.args.orderId!),
                  _pdfDetailRow('Date & Time', dateTime),
                  _pdfDetailRow('Paid Via', paidVia),
                  _pdfDetailRow('Status', 'SUCCESS'),
                  pw.SizedBox(height: 16),
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#FAF5FF'),
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Text(
                      'This is an electronically generated receipt from JigroPay, BBPS Verified & Secure Payment.',
                      style: pw.TextStyle(
                        fontSize: 9,
                        color: PdfColor.fromHex('#6B21A8'),
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    final outputDir = await getApplicationDocumentsDirectory();
    final file = File('${outputDir.path}/JigroPay_Receipt_$txnId.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  pw.Widget _pdfDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              color: PdfColor.fromHex('#64748B'),
              fontSize: 11,
            ),
          ),
          pw.Text(
            value.isNotEmpty ? value : '-',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              color: PdfColor.fromHex('#0F172A'),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _shareReceipt(
    String txnId,
    String dateTime,
    String paidVia,
  ) async {
    setState(() => _isGeneratingPdf = true);
    try {
      final file = await _generatePdfReceipt(txnId, dateTime, paidVia);
      // ignore: deprecated_member_use
      await Share.shareXFiles(
        [XFile(file.path)],
        text:
            'JigroPay Receipt - ${widget.args.serviceName} Payment of INR ${widget.args.amount}',
      );
    } catch (e) {
      showErrorToast('Error sharing receipt: $e');
    } finally {
      if (mounted) setState(() => _isGeneratingPdf = false);
    }
  }

  Future<void> _downloadReceipt(
    String txnId,
    String dateTime,
    String paidVia,
  ) async {
    setState(() => _isGeneratingPdf = true);
    try {
      final file = await _generatePdfReceipt(txnId, dateTime, paidVia);
      await OpenFile.open(file.path);
      showSuccessToast('Receipt saved to device');
    } catch (e) {
      showErrorToast('Error saving receipt: $e');
    } finally {
      if (mounted) setState(() => _isGeneratingPdf = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String txnId = _effectiveTxnId();
    final String dateTime = _formattedDateTime();
    final String paidVia = widget.args.paidVia ?? 'Razorpay';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go('/dashboard');
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: AppColors.black),
            onPressed: () => context.go('/dashboard'),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined, color: AppColors.black),
              onPressed: _isGeneratingPdf
                  ? null
                  : () => _shareReceipt(txnId, dateTime, paidVia),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Animated Success Icon
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.brandGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 28,
                        spreadRadius: 4,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title & Amount
              FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    Text(
                      '${widget.args.serviceName} Payment',
                      style: AppTypography.h3.copyWith(color: AppColors.black),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Successful!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        fontFamily: AppTypography.outfitBold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your ${widget.args.serviceName.toLowerCase()} has been paid successfully.',
                      textAlign: TextAlign.center,
                      style: AppTypography.body2.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightWhite1,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        '₹${widget.args.amount}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.black,
                          fontFamily: AppTypography.outfitBold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Transaction Details Card
              SlideTransition(
                position: _slideAnim,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TRANSACTION DETAILS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _detailRow('Service', widget.args.serviceName),
                      _detailRow('Provider', widget.args.providerName),
                      _detailRow('Consumer No.', widget.args.consumerNumber),
                      _detailRow('Transaction ID', txnId, canCopy: true),
                      if (widget.args.orderId != null &&
                          widget.args.orderId!.isNotEmpty)
                        _detailRow('Order ID', widget.args.orderId!),
                      if (widget.args.billMonth != null &&
                          widget.args.billMonth!.isNotEmpty)
                        _detailRow('Bill Month', widget.args.billMonth!),
                      _detailRow('Date & Time', dateTime),
                      _detailRow('Paid Via', paidVia),
                      _detailRow(
                        'Status',
                        'COMPLETED',
                        valueColor: AppColors.success,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Download / Share Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isGeneratingPdf
                          ? null
                          : () => _downloadReceipt(txnId, dateTime, paidVia),
                      icon: const Icon(
                        Icons.download_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      label: const Text(
                        'Download PDF',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isGeneratingPdf
                          ? null
                          : () => _shareReceipt(txnId, dateTime, paidVia),
                      icon: const Icon(
                        Icons.share_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      label: const Text(
                        'Share Receipt',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Done Button
              AppButton(
                label: 'Done',
                onPressed: () => context.go('/dashboard'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(
    String label,
    String value, {
    Color? valueColor,
    bool canCopy = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.grey,
              fontFamily: AppTypography.outfitRegular,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: valueColor ?? AppColors.black,
                      fontFamily: AppTypography.outfitBold,
                    ),
                  ),
                ),
                if (canCopy) ...[
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: value));
                      showLoadingToast('Copied to clipboard');
                    },
                    child: const Icon(
                      Icons.copy,
                      size: 14,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
