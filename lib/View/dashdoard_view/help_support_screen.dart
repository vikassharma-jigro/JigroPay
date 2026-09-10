import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/app_images.dart';
import '../../app_utils/font_family.dart';
import '../../app_utils/text_widget.dart';
import '../../app_utils/custom_textFiled.dart';
import '../../getx_controller/auth_controller.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String _selectedCategory = "Recharge & Bill Payment";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.getFaqsApi(context: context);
    });
  }

  final List<String> _categories = [
    "Recharge & Bill Payment",
    "Credit Card Bill Payment",
    "Transaction Refund Status",
    "Other Issues",
  ];

  final List<Map<String, String>> _faqs = [
    {
      "question": "How do I check my transaction status?",
      "answer":
          "You can view your complete payment and recharge history by visiting the 'History' tab from the bottom navigation menu.",
    },
    {
      "question": "What if my money is deducted but recharge failed?",
      "answer":
          "Do not worry! If money is deducted for a failed transaction, it will be automatically refunded to your original payment method within 24-48 business hours.",
    },
    {
      "question": "How to pay Credit Card bills on JigroPay?",
      "answer":
          "Go to the Credit Card section on the Home screen, choose your bank, enter your registered mobile number and last 4 digits of your card, fetch bill, and pay.",
    },
    {
      "question": "Why is a PAN card required for payments ≥ ₹50,000?",
      "answer":
          "As per regulatory guidelines in India, entering a valid 10-character PAN card number is mandatory for financial transactions of ₹50,000 or above.",
    },
    {
      "question": "How can I contact JigroPay Customer Care?",
      "answer":
          "You can call our helpline, email support@jigropay.com, or submit a support ticket directly from this page.",
    },
  ];

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      Fluttertoast.showToast(msg: "Could not launch phone dialer");
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': 'JigroPay Support Query'},
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      Fluttertoast.showToast(msg: "Could not launch email app");
    }
  }

  Future<void> _openWhatsApp(String phone) async {
    final Uri launchUri = Uri.parse("https://wa.me/$phone");
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    } else {
      Fluttertoast.showToast(msg: "Could not open WhatsApp");
    }
  }

  void _submitSupportTicket() async {
    if (_messageController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: "Please describe your issue before submitting",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    String subjectText = _subjectController.text.trim().isNotEmpty
        ? _subjectController.text.trim()
        : _selectedCategory;

    var response = await authController.submitEnquiryApi(
      context: context,
      category: _selectedCategory,
      subject: subjectText,
      description: _messageController.text.trim(),
    );

    if (response != null) {
      _subjectController.clear();
      _messageController.clear();

      String successMsg = response['message']?.toString() ?? "Support ticket submitted successfully!";
      Fluttertoast.showToast(
        msg: successMsg,
        gravity: ToastGravity.CENTER,
        backgroundColor: primaryColor,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: text(
          "Help & Support",
          textAlign: TextAlign.center,
          textColor: blackColor,
          fontSize: 18,
          fontFamily: FontFamily.plusJakartaSansBold,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Support Header Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [primaryColor, secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(
                          "We're Here To Help!",
                          textColor: white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          fontFamily: FontFamily.plusJakartaSansBold,
                        ),
                        const SizedBox(height: 6),
                        text(
                          "Get quick assistance 24/7 for all your recharges, bill payments, and queries.",
                          textColor: white.withOpacity(0.9),
                          fontSize: 13,
                          fontFamily: FontFamily.plusJakartaSansRegular,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.headset_mic, color: white, size: 30),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Contact Options Title
            text(
              "Direct Contact",
              textColor: blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: FontFamily.plusJakartaSansBold,
            ),
            const SizedBox(height: 12),

            // Contact Option Cards Rows
            Obx(() {
              String contactNumber = authController.companyContact.value.isNotEmpty
                  ? authController.companyContact.value
                  : "9216075701";
              String emailAddress = authController.companyEmail.value.isNotEmpty
                  ? authController.companyEmail.value
                  : "support@jigrotech.com";

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildContactCard(
                          icon: Icons.phone_in_talk,
                          iconColor: Colors.green,
                          title: "Call Us",
                          subtitle: contactNumber,
                          onTap: () => _makePhoneCall(contactNumber),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildContactCard(
                          icon: Icons.email_outlined,
                          iconColor: Colors.blue,
                          title: "Email Us",
                          subtitle: emailAddress,
                          onTap: () => _sendEmail(emailAddress),
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 12),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: _buildContactCard(
                  //         icon: Icons.chat_outlined,
                  //         iconColor: Colors.teal,
                  //         title: "WhatsApp",
                  //         subtitle: "Chat 24x7",
                  //         onTap: () => _openWhatsApp(contactNumber),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 12),
                  //     Expanded(
                  //       child: _buildContactCard(
                  //         icon: Icons.support_agent_outlined,
                  //         iconColor: Colors.purple,
                  //         title: "Ticket",
                  //         subtitle: "Raise Inquiry",
                  //         onTap: () {
                  //           FocusScope.of(context).requestFocus(FocusNode());
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              );
            }),
            const SizedBox(height: 25),

            // Raise Ticket Section
            text(
              "Raise a Support Ticket",
              textColor: blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: FontFamily.plusJakartaSansBold,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: greyColor.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text(
                    "Select Category",
                    textColor: greyColor,
                    fontSize: 13,
                    fontFamily: FontFamily.plusJakartaSansMedium,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: greyColor),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down, color: greyColor),
                        items: _categories.map((String cat) {
                          return DropdownMenuItem<String>(
                            value: cat,
                            child: text(
                              cat,
                              textColor: blackColor,
                              fontSize: 14,
                              fontFamily: FontFamily.plusJakartaSansMedium,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedCategory = val;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  text(
                    "Subject / Transaction ID (Optional)",
                    textColor: greyColor,
                    fontSize: 13,
                    fontFamily: FontFamily.plusJakartaSansMedium,
                  ),
                  const SizedBox(height: 6),
                  CustomRoundTextField(
                    controller: _subjectController,
                    hintText: "Enter subject or Transaction ID",
                    maxLines: 1,
                    fillColor: Colors.transparent,
                  ),
                  const SizedBox(height: 10),
                  text(
                    "Describe Your Issue",
                    textColor: greyColor,
                    fontSize: 13,
                    fontFamily: FontFamily.plusJakartaSansMedium,
                  ),
                  const SizedBox(height: 6),
                  CustomRoundTextField(
                    controller: _messageController,
                    hintText: "Describe what happened in detail...",
                    minLines: 3,
                    maxLines: 5,
                    fillColor: Colors.transparent,
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _submitSupportTicket,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: text(
                        "Submit Ticket",
                        textColor: white,
                        fontSize: 15,
                        fontFamily: FontFamily.plusJakartaSansBold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // FAQs Title
            text(
              "Frequently Asked Questions",
              textColor: blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: FontFamily.plusJakartaSansBold,
            ),
            const SizedBox(height: 12),

            // FAQs List (Dynamic)
            Obx(() {
              if (authController.isFaqLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(color: primaryColor),
                  ),
                );
              }

              List<Map<String, String>> currentFaqs = authController.faqList.isNotEmpty
                  ? authController.faqList
                  : _faqs;

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: currentFaqs.length,
                itemBuilder: (context, index) {
                  var faq = currentFaqs[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xfff8fafc),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: greyColor.withOpacity(0.2)),
                    ),
                    child: ExpansionTile(
                      shape: const RoundedRectangleBorder(side: BorderSide.none),
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      iconColor: primaryColor,
                      collapsedIconColor: greyColor,
                      title: text(
                        faq["question"] ?? "",
                        textColor: blackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: FontFamily.plusJakartaSansMedium,
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 14),
                          child: text(
                            faq["answer"] ?? "",
                            textColor: greyColor,
                            fontSize: 13,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: greyColor.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text(
                    title,
                    textColor: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: FontFamily.plusJakartaSansBold,
                  ),
                  const SizedBox(height: 2),
                  text(
                    subtitle,
                    textColor: greyColor,
                    fontSize: 11,
                    fontFamily: FontFamily.plusJakartaSansRegular,
                    maxLine: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
