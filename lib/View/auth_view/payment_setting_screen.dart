import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/app_utils/app_colors.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import 'package:jigrotech/app_utils/font_family.dart';
import 'package:jigrotech/app_utils/text_widget.dart';
import 'package:jigrotech/main.dart';

class PaymentSettingScreen extends StatefulWidget {
  const PaymentSettingScreen({super.key});

  @override
  State<PaymentSettingScreen> createState() => _PaymentSettingScreenState();
}

class _PaymentSettingScreenState extends State<PaymentSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return GradientAppScaffold(
      appBar: AppBar(
        title: text(
          "UPI & Payment Settings",
          textColor: white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text(
                "UPI ID",
                textColor: greyColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 16),
              // UPI ID
              _buildUPICards("UPI ID", "9222222222@pthdfc", "View", () {}),
              Divider(),

              // UPI NUMBER
              _buildUPICards("UPI Number", "9222222222", "View", () {}),
              Divider(),

              // My QR
              _buildUPICards(
                "My QR",
                "Share this QR to receive money",
                "View",
                () {},
              ),
              Divider(),
              SizedBox(height: 32),

              // Payment Account
              text(
                "Payment Accounts",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                textColor: greyColor,
                //fontFamily: FontFamily.plusJakartaSansBold,
              ),
              SizedBox(height: 16),

              // Payment Accounts Cards
              _buildPaymentCards(
                "Add Payment Account",
                "assets/images/addIcon.svg",
                false,
                false,
                Colors.transparent,
                "",
              ),

              Divider(),

              _buildPaymentCards(
                "Add RuPay Credit Card on UPI",
                AppImages.creditCardImage,
                false,
                false,
                pinkColor,
                "",
              ),
              Divider(),

              _buildPaymentCards(
                "Activate UPI Lite",
                AppImages.thunderIconImage,
                false,
                false,
                pinkColor,
                "",
              ),
              Divider(),

              _buildPaymentCards(
                "Canara Bank - 2291",
                AppImages.bankBuildIconImage,
                true,
                false,
                pinkColor,
                "Default Bank to receive money",
              ),
              Divider(),

              _buildPaymentCards(
                "Paytm Payments Bank - 9213",
                AppImages.bankBuildIconImage,
                false,
                false,
                pinkColor,
                "",
              ),
              Divider(),
              SizedBox(height: 32),

              // UPI Settings
              text(
                "UPI Settings",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                textColor: greyColor,
              ),
              SizedBox(height: 16),
              _buildPaymentCards(
                "Payment Requests",
                AppImages.messageIconImage,
                true,
                false,
                pinkColor,
                "View all requests received by you",
              ),
              Divider(),

              _buildPaymentCards(
                "Automatic Payments",
                AppImages.reshareIconImage,
                true,
                false,
                pinkColor,
                "Manage your UPI Automatic Payments",
              ),
              Divider(),

              _buildPaymentCards(
                "IPO & Trading Block Requests",
                AppImages.graphIconImage,
                true,
                false,
                pinkColor,
                "Manage payments related to your trading",
              ),
              Divider(),

              _buildPaymentCards(
                "International UPI",
                AppImages.internetIconImage,
                true,
                false,
                pinkColor,
                "Make payments while traveling abroad from your UPI linked bank accounts",
              ),
              Divider(),
              SizedBox(height: 32),

              // Other Settings
              text(
                "Other Settings Powered by JigroPay",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                textColor: greyColor,
              ),
              SizedBox(height: 16),

              _buildPaymentCards(
                "Saved Cards",
                AppImages.creditCardIcon,
                true,
                true,
                Color(0XFFFCE7F3),
                "Manage your saved cards or add new cards",
              ),
              Divider(),

              _buildPaymentCards(
                "JigroPay Assist",
                AppImages.robotIconImage,
                true,
                true,
                Color(0XFFCFFAFE),
                "Enable autofill for OTP submission at the time of making payments",
              ),
              Divider(),
              SizedBox(height: 48),

              Center(
                child: text(
                  "JigroPay UPI",
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  textColor: blackColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUPICards(
    String lable,
    String subLable,
    String buttonText,
    VoidCallback onPressed,
  ) {
    return Container(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text(
                "${lable}",
                textColor: blackColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 16),
              text(
                "${subLable}",
                textColor: blackColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 16),
            ],
          ),
          Spacer(),
          CommonButton(
            text: buttonText,
            onPressed: onPressed,
            fontFamily: "Inter",
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCards(
    String lable,
    String imagePath,
    bool isAddSubTile,
    bool isChangeColor,
    Color color,
    String subLable,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isChangeColor ? color : pinkColor.withOpacity(0.3),
            ),
            child: Center(child: SvgPicture.asset(imagePath)),
          ),
          SizedBox(width: 12),
          isAddSubTile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text(
                      "${lable}",
                      textColor: blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: text(
                        "${subLable}",
                        textColor: greyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                )
              : text(
                  "${lable}",
                  textColor: blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
          Spacer(),
          Icon(Icons.arrow_forward_ios, size: 20, color: purpleGradientColor),
        ],
      ),
    );
  }
}
