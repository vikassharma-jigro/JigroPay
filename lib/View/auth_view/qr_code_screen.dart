import '../../app_utils/font_family.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/View/auth_view/payment_setting_screen.dart';
import 'package:jigrotech/app_utils/app_colors.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import 'package:jigrotech/app_utils/text_widget.dart';
import 'package:jigrotech/main.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({super.key});

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  String qrData = "";

  @override
  void initState() {
    super.initState();
    final upiId = "tushargoyal8096@oksbi";
    final receiverName = "Tushar Goyal";
    qrData = "upi://pay?pa=$upiId&pn=$receiverName&cu=INR";
  }

  @override
  Widget build(BuildContext context) {
    return GradientAppScaffold(
      body: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: white,
          iconTheme: const IconThemeData(
            color: purpleGradientColor, // <-- Drawer icon color
          ),
        ),
        drawer: _buildDrawer(),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.9,
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.all(18),
        children: [
          /// Header Profile
          Row(
            children: [
              text(
                "Personal",
                fontSize: 16,
                fontWeight: FontWeight.w800,
                textColor: pinkColor,
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.06),
              text(
                "Buisness",
                fontSize: 16,
                fontWeight: FontWeight.w800,
                textColor: pinkColor,
              ),
              Spacer(),
              Icon(Icons.notifications_none_outlined),
            ],
          ),
          Divider(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),

          /// Profile Segment
          Row(
            children: [
              /// Image Profile
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: SvgPicture.asset(
                  AppImages.userIcon,
                  width: 50,
                  height: 50,
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),

              // Name
              text(
                "SHRUTI SHARMA",
                fontSize: 18,
                fontWeight: FontWeight.w800,
                textColor: blackColor,
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),

              // Check Icon
              Icon(Icons.check_circle_outline, color: Colors.blue),
            ],
          ),
          Divider(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),

          /// Qr Code Section
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.purple, width: 10),
            ),
            child: Column(
              children: [
                Center(
                  child: qrData.isNotEmpty
                      ? QrImageView(
                          data: qrData,
                          version: QrVersions.auto,
                          size: 250,
                        )
                      : const CircularProgressIndicator(),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                text(
                  "tushargoyal8096@oksbi",
                  fontSize: 15,
                  textColor: blackColor,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Share QR Tap
                    _buildQrCards("Share QR", AppImages.shareImage, () {}),

                    // Save QR
                    _buildQrCards("Save QR", AppImages.qrDownloadImage, () {}),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ],
            ),
          ),

          // Bank Name
          Row(
            children: [
              text(
                "Canara Bank - 2291",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                textColor: blackColor,
              ),
              Spacer(),
              TextButton(
                onPressed: () {},
                child: text("Change Bank", fontSize: 15, textColor: pinkColor),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),

          // Card
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(colors: [Colors.orange, Colors.red]),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text(
                      "Tata Capital IPO is open!",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    text(
                      "Apply Now",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.purple),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.shield, color: Colors.green),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),

                text(
                  "Jigropay Security Shield",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: blackColor,
                ),
                Spacer(),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.purple,
                  ),
                  child: text(
                    "Active",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),

          // Settings
          text(
            "Settings",
            fontSize: 24,
            fontWeight: FontWeight.w700,
            textColor: blackColor,
            fontFamily: FontFamily.plusJakartaSansBold,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),

          // Settings Options
          Divider(),
          _buildSettingsCards(
            "UPI & Payment Settings",
            AppImages.creditCardImage,
            "UPI PIN, Bank Account & more",
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentSettingScreen(),
                ),
              );
            },
          ),

          _buildSettingsCards(
            "Automatic Payments",
            AppImages.resharesImage,
            "Manage all your UPI Automatic Payments",
            () {},
          ),

          _buildSettingsCards(
            "Orders & Bookings",
            AppImages.ordersImage,
            "Recharge , Travel & Others",
            () {},
          ),

          _buildSettingsCards(
            "UPI & Payment Settings",
            AppImages.creditCardImage,
            "UPI PIN, Bank Account & more",
            () {},
          ),

          _buildSettingsCards(
            "Profile",
            AppImages.userIcon,
            "Privacy , Notification & Language",
            () {},
          ),

          _buildSettingsCards(
            "Help & Support",
            AppImages.helpSupportsImage,
            "Customer Support , Your Queries & FAQs",
            () {},
          ),

          _buildSettingsCards(
            "Refer & Win",
            AppImages.referWinImage,
            "Win up to ₹100 Cashback",
            () {},
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppImages.splashIcon, height: 40, width: 20),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    text(
                      "Jigropay",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      textColor: blackColor,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    text(
                      "Made By India",
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      textColor: greyColor,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Image.asset(AppImages.IndiaImage, height: 40, width: 20),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.06),

          SizedBox(
            width: double.infinity,
            child: Text(
              "Terms & Conditions, Privacy policy, Grievance, Redressal Mechanism, See all policies",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: greyColor,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        ],
      ),
    );
  }

  Widget _buildQrCards(String lable, String svg, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.purple),
        ),
        child: Row(
          children: [
            SvgPicture.asset(svg),
            SizedBox(width: MediaQuery.of(context).size.width * 0.03),
            text("${lable}", fontSize: 16, textColor: blackColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCards(
    String lable,
    String svg,
    String subLable,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.04,
        ),
        child: Row(
          children: [
            SvgPicture.asset(svg),
            SizedBox(width: MediaQuery.of(context).size.width * 0.04),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text(
                  lable,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  textColor: blackColor,
                  fontFamily: FontFamily.plusJakartaSansMedium,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                text(
                  subLable,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  textColor: blackColor,
                ),
              ],
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 20, color: Colors.purple),
          ],
        ),
      ),
    );
  }
}
