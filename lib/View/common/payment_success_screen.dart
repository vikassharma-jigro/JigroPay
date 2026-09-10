import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:jigrotech/View/dashdoard_view/bottom_navigation_bar_screen.dart';
import 'package:jigrotech/app_utils/app_colors.dart';
import 'package:jigrotech/app_utils/font_family.dart';
import 'package:jigrotech/app_utils/text_widget.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final String serviceName;       // e.g. "Electricity Bill", "Cable TV"
  final String providerName;      // e.g. "JVVNL", "ACT Cable TV"
  final String consumerNumber;    // e.g. "1234567890"
  final String amount;            // e.g. "1850.00"
  final String transactionId;     // Razorpay paymentId
  final String? orderId;          // Razorpay orderId
  final String? billMonth;        // e.g. "May 2025"
  final String? paidVia;          // e.g. "HDFC Bank •••• 1234"
  final String? opcode;           // service opcode

  const PaymentSuccessScreen({
    super.key,
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

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

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

    _scaleAnim = CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut);
    _fadeAnim  = CurvedAnimation(parent: _fadeController,  curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _fadeController.forward();
      _slideController.forward();
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
    final now = DateTime.now();
    return DateFormat('dd MMM yyyy, HH:mm').format(now);
  }

  String _generateTxnId() {
    if (widget.transactionId.isNotEmpty) return widget.transactionId;
    final rand = Random().nextInt(999999999);
    return 'TXN$rand';
  }

  Future<File> _generatePdfReceipt(String txnId, String dateTime, String paidVia) async {
    final pdf = pw.Document();
    final String amountStr = double.tryParse(widget.amount)?.toStringAsFixed(2) ?? widget.amount;
    final String ticketId = txnId.replaceAll(RegExp(r'\D'), '');
    final String formattedTicketId = ticketId.isNotEmpty 
        ? (ticketId.length > 13 ? ticketId.substring(ticketId.length - 13) : ticketId.padLeft(13, '0'))
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
                color: PdfColor.fromHex("#FFFFFF"),
                borderRadius: pw.BorderRadius.circular(16),
                border: pw.Border.all(color: PdfColor.fromHex("#E2E8F0"), width: 1),
              ),
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  // 1. Success Circle Checkmark Header
                  pw.Container(
                    width: 56,
                    height: 56,
                    decoration: pw.BoxDecoration(
                      shape: pw.BoxShape.circle,
                      color: PdfColor.fromHex("#FAF5FF"),
                      border: pw.Border.all(color: PdfColor.fromHex("#8C2AC4"), width: 2.5),
                    ),
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      'v',
                      style: pw.TextStyle(
                        fontSize: 26,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex("#8C2AC4"),
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 12),
                  pw.Text(
                    'Thank you!',
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex("#0F172A"),
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Your payment has been completed successfully.',
                    style: pw.TextStyle(
                      fontSize: 11,
                      color: PdfColor.fromHex("#64748B"),
                    ),
                    textAlign: pw.TextAlign.center,
                  ),

                  pw.SizedBox(height: 16),
                  pw.Divider(borderStyle: pw.BorderStyle.dashed, color: PdfColor.fromHex("#CBD5E1"), thickness: 1),
                  pw.SizedBox(height: 16),

                  // 2. Total Amount Paid Box
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex("#FAF5FF"),
                      borderRadius: pw.BorderRadius.circular(12),
                      border: pw.Border.all(color: PdfColor.fromHex("#E9D5FF"), width: 1),
                    ),
                    child: pw.Column(
                      children: [
                        pw.Text(
                          'Total Amount Paid',
                          style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColor.fromHex("#64748B"),
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'INR $amountStr',
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromHex("#8C2AC4"),
                          ),
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 16),

                  // 3. Ticket Info Grid
                  pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Row(
                          children: [
                            pw.Container(
                              width: 32,
                              height: 32,
                              decoration: pw.BoxDecoration(
                                shape: pw.BoxShape.circle,
                                color: PdfColor.fromHex("#FAF5FF"),
                                border: pw.Border.all(color: PdfColor.fromHex("#E9D5FF")),
                              ),
                              alignment: pw.Alignment.center,
                              child: pw.Text('T', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#8C2AC4"))),
                            ),
                            pw.SizedBox(width: 8),
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('TICKET ID', style: pw.TextStyle(fontSize: 9, color: PdfColor.fromHex("#64748B"), fontWeight: pw.FontWeight.bold)),
                                pw.Text(formattedTicketId, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#0F172A"))),
                              ],
                            ),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Row(
                          children: [
                            pw.Container(
                              width: 32,
                              height: 32,
                              decoration: pw.BoxDecoration(
                                shape: pw.BoxShape.circle,
                                color: PdfColor.fromHex("#FAF5FF"),
                                border: pw.Border.all(color: PdfColor.fromHex("#E9D5FF")),
                              ),
                              alignment: pw.Alignment.center,
                              child: pw.Text('R', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#8C2AC4"))),
                            ),
                            pw.SizedBox(width: 8),
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('AMOUNT', style: pw.TextStyle(fontSize: 9, color: PdfColor.fromHex("#64748B"), fontWeight: pw.FontWeight.bold)),
                                pw.Text('INR $amountStr', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#0F172A"))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 12),
                  pw.Row(
                    children: [
                      pw.Container(
                        width: 32,
                        height: 32,
                        decoration: pw.BoxDecoration(
                          shape: pw.BoxShape.circle,
                          color: PdfColor.fromHex("#FAF5FF"),
                          border: pw.Border.all(color: PdfColor.fromHex("#E9D5FF")),
                        ),
                        alignment: pw.Alignment.center,
                        child: pw.Text('D', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#8C2AC4"))),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('DATE & TIME', style: pw.TextStyle(fontSize: 9, color: PdfColor.fromHex("#64748B"), fontWeight: pw.FontWeight.bold)),
                          pw.Text(dateTime, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#0F172A"))),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 12),
                  // Paid Via Container
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex("#F8FAFC"),
                      borderRadius: pw.BorderRadius.circular(10),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Paid Via', style: pw.TextStyle(fontSize: 10, color: PdfColor.fromHex("#64748B"))),
                        pw.SizedBox(height: 2),
                        pw.Text(paidVia, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#0F172A"))),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 16),
                  pw.Divider(borderStyle: pw.BorderStyle.dashed, color: PdfColor.fromHex("#CBD5E1"), thickness: 1),
                  pw.SizedBox(height: 16),

                  // 4. TRANSACTION DETAILS
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'TRANSACTION DETAILS',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex("#8C2AC4"),
                        ),
                      ),
                      pw.Container(
                        height: 1,
                        color: PdfColor.fromHex("#E9D5FF"),
                        margin: const pw.EdgeInsets.only(top: 4, bottom: 12),
                      ),
                      _pdfDetailRow('Service Name', widget.serviceName),
                      _pdfDetailRow('Provider', widget.providerName),
                      _pdfDetailRow('Consumer Number', widget.consumerNumber),
                      _pdfDetailRow('Transaction ID', txnId),
                      if (widget.orderId != null && widget.orderId!.isNotEmpty)
                        _pdfDetailRow('Order ID', widget.orderId!),
                      _pdfDetailRow('Date & Time', dateTime),
                      _pdfDetailRow('Paid Via', paidVia),
                      _pdfDetailRow('Status', 'SUCCESS'),
                    ],
                  ),

                  pw.SizedBox(height: 16),
                  pw.Divider(borderStyle: pw.BorderStyle.dashed, color: PdfColor.fromHex("#CBD5E1"), thickness: 1),
                  pw.SizedBox(height: 16),

                  // 5. Footer (NO Barcode)
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex("#FAF5FF"),
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Text(
                      'This is an electronically generated receipt from JigroPay, BBPS Verified & Secure Payment.',
                      style: pw.TextStyle(fontSize: 9, color: PdfColor.fromHex("#6B21A8")),
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
          pw.Text(label, style: pw.TextStyle(color: PdfColor.fromHex("#64748B"), fontSize: 11)),
          pw.Text(value.isNotEmpty ? value : '-', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#0F172A"), fontSize: 11)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String txnId = _generateTxnId();
    final String dateTime = _formattedDateTime();
    final String paidVia = widget.paidVia ?? 'Razorpay';

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => DashboardScreen()),
                  (route) => false,
                );
              },
              child: const Icon(Icons.arrow_back_ios, color: blackColor),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // ─── SUCCESS ICON ANIMATED ───────────────────────────────
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8C2AC4), Color(0xFFE81ECD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.35),
                        blurRadius: 30,
                        spreadRadius: 4,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 70,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // ─── TITLE ───────────────────────────────────────────────
              FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    text(
                      '${widget.serviceName} Payment',
                      textColor: blackColor,
                      fontSize: 20,
                      fontFamily: FontFamily.plusJakartaSansBold,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(height: 4),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF8C2AC4), Color(0xFFE81ECD)],
                      ).createShader(bounds),
                      child: const Text(
                        'Successful!',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          fontFamily: FontFamily.plusJakartaSansBold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    text(
                      'Your ${widget.serviceName.toLowerCase()} has been paid successfully.',
                      textColor: greyColor,
                      fontSize: 13,
                      fontFamily: FontFamily.plusJakartaSansRegular,
                      fontWeight: FontWeight.w400,
                    ),
                    const SizedBox(height: 12),
                    // Amount pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: text(
                        '₹${double.tryParse(widget.amount)?.toStringAsFixed(2) ?? widget.amount}',
                        textColor: const Color(0xFF22C55E),
                        fontSize: 28,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ─── TRANSACTION DETAILS CARD ─────────────────────────────
              SlideTransition(
                position: _slideAnim,
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Card Header
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF8C2AC4), Color(0xFFE81ECD)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: text(
                            'Transaction Details',
                            textColor: Colors.white,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        // Detail Rows
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _detailRow('Provider', widget.providerName),
                              _divider(),
                              _detailRow('Consumer Number', widget.consumerNumber),
                              _divider(),
                              if (widget.billMonth != null && widget.billMonth!.isNotEmpty) ...[
                                _detailRow('Bill Month', widget.billMonth!),
                                _divider(),
                              ],
                              _detailRow('Transaction ID', txnId),
                              _divider(),
                              _detailRow('Date & Time', dateTime),
                              _divider(),
                              _detailRowWithIcon('Paid Via', paidVia),
                            ],
                          ),
                        ),

                        // Footer: BBPS + Secure
                        Container(
                          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F0FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.verified, color: Color(0xFF22C55E), size: 18),
                                  const SizedBox(width: 6),
                                  text(
                                    'BBPS Verified',
                                    textColor: const Color(0xFF22C55E),
                                    fontSize: 12,
                                    fontFamily: FontFamily.plusJakartaSansBold,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.lock, color: primaryColor, size: 18),
                                  const SizedBox(width: 6),
                                  text(
                                    'Secure Payment',
                                    textColor: primaryColor,
                                    fontSize: 12,
                                    fontFamily: FontFamily.plusJakartaSansBold,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ─── BUTTONS ──────────────────────────────────────────────
              FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    // Download Receipt
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF8C2AC4), Color(0xFFE81ECD)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () async {
                            try {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Generating PDF receipt...')),
                              );
                              File pdfFile = await _generatePdfReceipt(txnId, dateTime, paidVia);
                              final OpenResult result = await OpenFile.open(pdfFile.path);
                              if (result.type == ResultType.done) {
                                Fluttertoast.showToast(msg: "Receipt downloaded & opened!");
                              } else {
                                Fluttertoast.showToast(msg: "Receipt saved at: ${pdfFile.path.split('/').last}");
                              }
                            } catch (e) {
                              Fluttertoast.showToast(msg: "Error downloading receipt: $e");
                            }
                          },
                          icon: const Icon(Icons.download_rounded, color: Colors.white),
                          label: const Text(
                            'Download Receipt',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: FontFamily.plusJakartaSansBold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Share & Pay Another
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              try {
                                File pdfFile = await _generatePdfReceipt(txnId, dateTime, paidVia);
                                final OpenResult result = await OpenFile.open(pdfFile.path);
                                if (result.type != ResultType.done) {
                                  await Clipboard.setData(ClipboardData(
                                    text: "JigroPay Receipt:\nService: ${widget.serviceName}\nProvider: ${widget.providerName}\nConsumer No: ${widget.consumerNumber}\nAmount: ₹${widget.amount}\nTxn ID: $txnId\nDate: $dateTime\nStatus: SUCCESS",
                                  ));
                                  Fluttertoast.showToast(msg: "Receipt details copied to clipboard!");
                                } else {
                                  Fluttertoast.showToast(msg: "Receipt opened for sharing!");
                                }
                              } catch (e) {
                                Fluttertoast.showToast(msg: "Error sharing receipt: $e");
                              }
                            },
                            icon: const Icon(Icons.share_rounded, color: primaryColor, size: 18),
                            label: const Text(
                              'Share',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: FontFamily.plusJakartaSansBold,
                                fontSize: 15,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: primaryColor, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => DashboardScreen()),
                                (route) => false,
                              );
                            },
                            icon: const Icon(Icons.add_circle_outline_rounded, color: primaryColor, size: 18),
                            label: const Text(
                              'Pay Another',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: FontFamily.plusJakartaSansBold,
                                fontSize: 15,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: primaryColor, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          text(
            label,
            textColor: greyColor,
            fontSize: 13,
            fontFamily: FontFamily.plusJakartaSansRegular,
            fontWeight: FontWeight.w400,
          ),
          Flexible(
            child: text(
              value.isNotEmpty ? value : '-',
              textColor: blackColor,
              fontSize: 13,
              fontFamily: FontFamily.plusJakartaSansBold,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRowWithIcon(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          text(
            label,
            textColor: greyColor,
            fontSize: 13,
            fontFamily: FontFamily.plusJakartaSansRegular,
            fontWeight: FontWeight.w400,
          ),
          Row(
            children: [
              const Icon(Icons.account_balance_rounded, size: 15, color: greyColor),
              const SizedBox(width: 6),
              text(
                value,
                textColor: blackColor,
                fontSize: 13,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Divider(height: 1, thickness: 0.5, color: Color(0xFFEEEEEE));
  }
}
