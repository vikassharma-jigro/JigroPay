import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

class PaymentReceiptWidget extends StatelessWidget {
  final String status;
  final String amount;
  final String toName;
  final String toSub;
  final String? refId;
  final String? orderId;
  final String? paymentId;
  final String date;
  final String? note;
  final String? type;
  final String? amountInWords;
  final String? iconUrl;
  final String? operatorCode;
  final VoidCallback? onCopyRefId;
  final VoidCallback? onCopyOrderId;
  final VoidCallback? onCopyPaymentId;

  const PaymentReceiptWidget({
    super.key,
    required this.status,
    required this.amount,
    required this.toName,
    required this.toSub,
    this.refId,
    this.orderId,
    this.paymentId,
    required this.date,
    this.note,
    this.type,
    this.amountInWords,
    this.iconUrl,
    this.operatorCode,
    this.onCopyRefId,
    this.onCopyOrderId,
    this.onCopyPaymentId,
  });

  @override
  Widget build(BuildContext context) {
    bool isSuccess =
        status.toLowerCase().contains('success') ||
        status == '1' ||
        status == 'true';
    bool isFailed = status.toLowerCase().contains('fail') || status == '0';
    bool isPending =
        status.toLowerCase().contains('pending') || (!isSuccess && !isFailed);
    bool showRefAndOrderId = isSuccess && !isFailed && !isPending;

    Color statusColor = isSuccess
        ? AppColors.success
        : isFailed
        ? AppColors.errorBright
        : const Color(0xffF59E0B);

    IconData statusIcon = isSuccess
        ? Icons.check_rounded
        : isFailed
        ? Icons.close_rounded
        : Icons.hourglass_empty_rounded;

    String statusText = isSuccess
        ? "Payment Successful"
        : isFailed
        ? "Payment Failed"
        : "Payment Pending";

    String customNote = (note ?? '').trim();

    return Container(
      width: double.infinity,
      color: const Color(0xffF4F5F7),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Logo & "PAYMENT RECEIPT"
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/jigropay.png',
                  height: 38,
                  errorBuilder: (context, error, stackTrace) => const Text(
                    "JigroPay",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 24,
                      fontFamily: AppTypography.outfitBold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "PAYMENT RECEIPT",
                  style: TextStyle(
                    color: AppColors.black.withValues(alpha: 0.7),
                    fontSize: 12,
                    fontFamily: AppTypography.outfitBold,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Payment Status & Amount Box
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: const Border(
                bottom: BorderSide(color: AppColors.primary, width: 10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Text(
                    statusText,
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 20,
                      fontFamily: AppTypography.outfitBold,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "₹$amount",
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 34,
                            fontFamily: AppTypography.outfitBold,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          statusIcon,
                          color: AppColors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  if (amountInWords != null && amountInWords!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      amountInWords!,
                      style: const TextStyle(
                        color: AppColors.grey,
                        fontSize: 13,
                        fontFamily: AppTypography.outfitMedium,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  if (customNote.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      customNote,
                      style: TextStyle(
                        color: AppColors.black.withValues(alpha: 0.8),
                        fontSize: 14,
                        fontFamily: AppTypography.outfitMedium,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Receipt Details Ticket Box
          ClipPath(
            clipper: TicketClipper(),
            child: Container(
              width: double.infinity,
              color: AppColors.white,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildReceiptIcon(),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              toName,
                              style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                                fontFamily: AppTypography.outfitBold,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (toSub.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                toSub,
                                style: const TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 13,
                                  fontFamily: AppTypography.outfitRegular,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  CustomPaint(
                    size: const Size(double.infinity, 1),
                    painter: DashedLinePainter(),
                  ),
                  const SizedBox(height: 16),

                  // 1. Razorpay Payment ID Show karein
                  if (showRefAndOrderId &&
                      paymentId != null &&
                      paymentId!.trim().isNotEmpty) ...[
                    Text(
                      "Payment ID",
                      style: TextStyle(
                        color: AppColors.grey.withValues(alpha: 0.9),
                        fontSize: 12,
                        fontFamily: AppTypography.outfitMedium,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: onCopyPaymentId,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            paymentId!,
                            style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 15,
                              fontFamily: AppTypography.outfitBold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (onCopyPaymentId != null)
                            const Icon(
                              Icons.copy_rounded,
                              size: 16,
                              color: AppColors.grey,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // 2. Razorpay Order ID Show karein
                  if (showRefAndOrderId &&
                      orderId != null &&
                      orderId!.trim().isNotEmpty) ...[
                    Text(
                      "Order ID",
                      style: TextStyle(
                        color: AppColors.grey.withValues(alpha: 0.9),
                        fontSize: 12,
                        fontFamily: AppTypography.outfitMedium,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: onCopyOrderId,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            orderId!,
                            style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 15,
                              fontFamily: AppTypography.outfitBold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (onCopyOrderId != null)
                            const Icon(
                              Icons.copy_rounded,
                              size: 16,
                              color: AppColors.grey,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // 3. Type aur Operator Code / Biller ID Show karein
                  if (type != null && type!.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Transaction Type",
                          style: TextStyle(color: AppColors.grey, fontSize: 13),
                        ),
                        Text(
                          type!.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 13,
                            fontFamily: AppTypography.outfitBold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],

                  if (operatorCode != null && operatorCode!.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Biller / Operator",
                          style: TextStyle(color: AppColors.grey, fontSize: 13),
                        ),
                        Text(
                          operatorCode!,
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 13,
                            fontFamily: AppTypography.outfitBold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (date.isNotEmpty)
                    Text(
                      date,
                      style: const TextStyle(
                        color: AppColors.grey,
                        fontSize: 13,
                        fontFamily: AppTypography.outfitRegular,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Footer
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xff0284C7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: AppColors.white,
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "100% SECURE PAYMENTS",
                    style: TextStyle(
                      color: Color(0xff0284C7),
                      fontSize: 13,
                      fontFamily: AppTypography.outfitBold,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                "Shared via JigroPay",
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 11,
                  fontFamily: AppTypography.outfitMedium,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildReceiptIcon() {
    Widget fallbackWidget;
    if (operatorCode != null && operatorCode!.trim().isNotEmpty) {
      fallbackWidget = Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary.withValues(alpha: 0.1),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              operatorCode!.trim(),
              style: TextStyle(
                color: AppColors.primary,
                fontSize: operatorCode!.trim().length > 5 ? 10 : 12,
                fontFamily: AppTypography.outfitBold,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        ),
      );
    } else {
      IconData defaultIcon = Icons.receipt_long_rounded;
      Color defaultColor = AppColors.primary;
      String t = (type ?? '').toLowerCase();
      if (t.contains("electr") || t.contains("light") || t.contains("power")) {
        defaultIcon = Icons.bolt_rounded;
        defaultColor = Colors.orange;
      } else if (t.contains("mob") ||
          t.contains("recharge") ||
          t.contains("phone") ||
          t.contains("operator")) {
        defaultIcon = Icons.phone_android_rounded;
        defaultColor = AppColors.primary;
      } else if (t.contains("dth") || t.contains("cable") || t.contains("tv")) {
        defaultIcon = Icons.tv_rounded;
        defaultColor = AppColors.primary;
      } else if (t.contains("card") || t.contains("credit")) {
        defaultIcon = Icons.credit_card_rounded;
        defaultColor = Colors.purple;
      } else if (t.contains("water") ||
          t.contains("gas") ||
          t.contains("lpg")) {
        defaultIcon = Icons.water_drop_rounded;
        defaultColor = Colors.blue;
      }

      fallbackWidget = Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: defaultColor.withValues(alpha: 0.1),
          border: Border.all(
            color: defaultColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Center(child: Icon(defaultIcon, color: defaultColor, size: 22)),
      );
    }

    final cleanIconUrl = (iconUrl ?? '').trim();
    if (cleanIconUrl.isNotEmpty) {
      bool isSvg = cleanIconUrl.toLowerCase().endsWith('.svg');
      bool isNetwork =
          cleanIconUrl.startsWith('http://') ||
          cleanIconUrl.startsWith('https://');

      Widget imageWidget;
      if (isNetwork) {
        imageWidget = isSvg
            ? SvgPicture.network(
                cleanIconUrl,
                width: 42,
                height: 42,
                fit: BoxFit.cover,
                placeholderBuilder: (context) => fallbackWidget,
              )
            : Image.network(
                cleanIconUrl,
                width: 42,
                height: 42,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => fallbackWidget,
              );
      } else if (cleanIconUrl.startsWith('assets/')) {
        imageWidget = isSvg
            ? SvgPicture.asset(
                cleanIconUrl,
                width: 42,
                height: 42,
                fit: BoxFit.cover,
              )
            : Image.asset(
                cleanIconUrl,
                width: 42,
                height: 42,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => fallbackWidget,
              );
      } else {
        imageWidget = fallbackWidget;
      }

      return Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white,
          border: Border.all(
            color: AppColors.grey.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: ClipOval(child: imageWidget),
      );
    }

    return fallbackWidget;
  }
}

class TicketClipper extends CustomClipper<Path> {
  final double triangleWidth;
  final double triangleHeight;

  TicketClipper({this.triangleWidth = 10.0, this.triangleHeight = 8.0});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - triangleHeight);

    double x = 0;
    while (x < size.width) {
      x += triangleWidth;
      path.lineTo(x - (triangleWidth / 2), size.height);
      path.lineTo(x, size.height - triangleHeight);
    }

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;

  DashedLinePainter({
    this.color = const Color(0xFFCBD5E1),
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double startX = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
