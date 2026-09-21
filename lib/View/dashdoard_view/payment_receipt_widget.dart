import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/app_images.dart';
import '../../app_utils/category_utils.dart';
import '../../app_utils/font_family.dart';
import '../../app_utils/text_widget.dart';

class PaymentReceiptWidget extends StatelessWidget {
  final String status;
  final String amount;
  final String toName;
  final String toSub;
  final String? refId;
  final String? orderId;
  final String date;
  final String? note;
  final String? type;
  final String? amountInWords;
  final String? iconUrl;
  final String? operatorCode;
  final VoidCallback? onCopyRefId;
  final VoidCallback? onCopyOrderId;

  const PaymentReceiptWidget({
    super.key,
    required this.status,
    required this.amount,
    required this.toName,
    required this.toSub,
    this.refId,
    this.orderId,
    required this.date,
    this.note,
    this.type,
    this.amountInWords,
    this.iconUrl,
    this.operatorCode,
    this.onCopyRefId,
    this.onCopyOrderId,
  });

  @override
  Widget build(BuildContext context) {
    bool isSuccess = status.toLowerCase().contains('success') ||
        status == '1' ||
        status == 'true';
    bool isFailed = status.toLowerCase().contains('fail') ||
        status == '0';
    bool isPending = status.toLowerCase().contains('pending') ||
        (!isSuccess && !isFailed);
    bool showRefAndOrderId = isSuccess && !isFailed && !isPending;

    Color statusColor = isSuccess
        ? const Color(0xff22C55E)
        : isFailed
            ? const Color(0xffDC2626)
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

    String categoryType = CategoryUtils.formatCategoryType(type);
    String customNote = (note ?? '').trim();

    return Container(
      width: double.infinity,
      color: const Color(0xffF4F5F7), // Fully opaque background for crisp PNG capture
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Header: Logo & "PAYMENT RECEIPT"
          Center(
            child: Column(
              children: [
                Image.asset(
                  AppImages.jigroImage,
                  height: 38,
                  errorBuilder: (context, error, stackTrace) => text(
                    "JigroPay",
                    textColor: primaryColor,
                    fontSize: 24,
                    fontFamily: FontFamily.plusJakartaSansBold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                text(
                  "PAYMENT RECEIPT",
                  textColor: blackColor.withOpacity(0.7),
                  fontSize: 12,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w700,
                  latterSpacing: 1.5,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // CARD 1: Payment Status & Amount Box
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(.1),
                  borderRadius: BorderRadius.circular(16),
                  border: const Border(
                    bottom: BorderSide(color: primaryColor, width: 10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
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

                      // Status Text
                      text(
                        statusText,
                        textColor: blackColor,
                        fontSize: 20,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontWeight: FontWeight.w700,
                      ),

                      const SizedBox(height: 16),

                      // Amount Display
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: text(
                              "₹$amount",
                              textColor: blackColor,
                              fontSize: 34,
                              fontFamily: FontFamily.plusJakartaSansBold,
                              fontWeight: FontWeight.w800,
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
                              color: white,
                              size: 16,
                            ),
                          ),
                        ],
                      ),

                      if (amountInWords != null && amountInWords!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        text(
                          amountInWords!,
                          textColor: greyColor,
                          fontSize: 13,
                          fontFamily: FontFamily.plusJakartaSansMedium,
                          fontWeight: FontWeight.w500,
                        ),
                      ],

                      if (customNote.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        text(
                          customNote,
                          textColor: blackColor.withOpacity(0.8),
                          fontSize: 14,
                          fontFamily: FontFamily.plusJakartaSansMedium,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Paid To Category Badge - Show if category type exists
              if (categoryType.isNotEmpty)
                Positioned(
                  top: -12,
                  right: 20,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: green1Color),
                      borderRadius: BorderRadius.circular(50),
                      color: greenColor.withOpacity(.95),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: text(
                        categoryType,
                        textColor: blackColor.withOpacity(0.8),
                        fontSize: 13,
                        fontFamily: FontFamily.plusJakartaSansMedium,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // CARD 2: White Receipt Details Ticket with Sawtooth Cut at Bottom
          ClipPath(
            clipper: TicketClipper(triangleWidth: 12.0, triangleHeight: 8.0),
            child: Container(
              width: double.infinity,
              color: white,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TO Section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "To:  ",
                                    style: TextStyle(
                                      color: blackColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily:
                                          FontFamily.plusJakartaSansBold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: toName,
                                    style: const TextStyle(
                                      color: blackColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily:
                                          FontFamily.plusJakartaSansBold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (toSub.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              text(
                                toSub,
                                textColor: greyColor,
                                fontSize: 13,
                                fontFamily: FontFamily.plusJakartaSansRegular,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      _buildReceiptIcon(),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Dashed Line Divider
                  CustomPaint(
                    size: const Size(double.infinity, 1),
                    painter: DashedLinePainter(
                      color: Colors.grey.shade300,
                      dashWidth: 6.0,
                      dashSpace: 4.0,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // UPI Ref ID Row
                  if (showRefAndOrderId && refId != null && refId!.isNotEmpty) ...[
                    InkWell(
                      onTap: onCopyRefId,
                      child: Row(
                        children: [
                          Expanded(
                            child: text(
                              "UPI Ref ID: $refId",
                              textColor: blackColor.withOpacity(0.85),
                              fontSize: 14,
                              fontFamily: FontFamily.plusJakartaSansMedium,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (onCopyRefId != null)
                            const Icon(
                              Icons.copy_rounded,
                              size: 16,
                              color: greyColor,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],

                  // Order ID Row
                  if (showRefAndOrderId && orderId != null && orderId!.isNotEmpty) ...[
                    InkWell(
                      onTap: onCopyOrderId,
                      child: Row(
                        children: [
                          Expanded(
                            child: text(
                              "Order ID: $orderId",
                              textColor: blackColor.withOpacity(0.85),
                              fontSize: 14,
                              fontFamily: FontFamily.plusJakartaSansMedium,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (onCopyOrderId != null)
                            const Icon(
                              Icons.copy_rounded,
                              size: 16,
                              color: greyColor,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],

                  // Date & Time
                  if (date.isNotEmpty)
                    text(
                      date,
                      textColor: greyColor,
                      fontSize: 13,
                      fontFamily: FontFamily.plusJakartaSansRegular,
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Footer: 100% SECURE PAYMENTS Badge & Shared Tagline
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
                      color: white,
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  text(
                    "100% SECURE PAYMENTS",
                    textColor: const Color(0xff0284C7),
                    fontSize: 13,
                    fontFamily: FontFamily.plusJakartaSansBold,
                    fontWeight: FontWeight.w700,
                    latterSpacing: 0.8,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              text(
                "Shared via JigroPay",
                textColor: greyColor,
                fontSize: 11,
                fontFamily: FontFamily.plusJakartaSansMedium,
                fontWeight: FontWeight.w500,
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
          color: primaryColor.withValues(alpha: 0.1),
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: text(
              operatorCode!.trim(),
              textColor: primaryColor,
              fontSize: operatorCode!.trim().length > 5 ? 10 : 12,
              fontFamily: FontFamily.plusJakartaSansBold,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
              maxLine: 1,
            ),
          ),
        ),
      );
    } else {
      IconData defaultIcon = Icons.receipt_long_rounded;
      Color defaultColor = primaryColor;
      String t = (type ?? '').toLowerCase();
      if (t.contains("electr") || t.contains("light") || t.contains("power")) {
        defaultIcon = Icons.bolt_rounded;
        defaultColor = Colors.orange;
      } else if (t.contains("mob") ||
          t.contains("recharge") ||
          t.contains("phone") ||
          t.contains("operator")) {
        defaultIcon = Icons.phone_android_rounded;
        defaultColor = primaryColor;
      } else if (t.contains("dth") || t.contains("cable") || t.contains("tv")) {
        defaultIcon = Icons.tv_rounded;
        defaultColor = primaryColor;
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
        child: Center(
          child: Icon(
            defaultIcon,
            color: defaultColor,
            size: 22,
          ),
        ),
      );
    }

    final cleanIconUrl = (iconUrl ?? '').trim();
    if (cleanIconUrl.isNotEmpty) {
      bool isSvg = cleanIconUrl.toLowerCase().endsWith('.svg');
      bool isNetwork = cleanIconUrl.startsWith('http://') ||
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
          color: white,
          border: Border.all(
            color: greyColor.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: ClipOval(child: imageWidget),
      );
    }

    return fallbackWidget;
  }
}

// Custom Clipper for Zigzag / Sawtooth Receipt Cut at Bottom
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

// Custom Painter for Horizontal Dashed Line Separator
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
