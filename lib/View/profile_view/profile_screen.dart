import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app_utils/cms_helper.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/custom_textFiled.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../app_utils/app_images.dart';
import '../../../getx_controller/auth_controller.dart';
import '../../../main.dart';
import '../auth_view/login_screen.dart';
import '../auth_view/verified_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController authController = Get.put(AuthController());

  String _formatDateTime(dynamic item) {
    if (item is! Map) return "";

    dynamic rawDate = item['created_at'] ??
        item['date'] ??
        item['created_date'] ??
        item['datetime'] ??
        item['time'] ??
        item['timestamp'] ??
        item['updated_at'];

    if (rawDate == null || rawDate.toString().isEmpty) {
      return "";
    }

    String strDate = rawDate.toString().trim();

    try {
      DateTime? parsedDate = DateTime.tryParse(strDate);
      if (parsedDate != null) {
        return DateFormat('dd MMM yyyy, hh:mm a').format(parsedDate.toLocal());
      }
    } catch (_) {}

    if (int.tryParse(strDate) != null) {
      try {
        int ts = int.parse(strDate);
        if (ts < 10000000000) ts *= 1000;
        DateTime dt = DateTime.fromMillisecondsSinceEpoch(ts);
        return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
      } catch (_) {}
    }

    List<String> patterns = [
      'yyyy-MM-dd HH:mm:ss',
      'yyyy/MM/dd HH:mm:ss',
      'dd-MM-yyyy HH:mm:ss',
      'dd/MM/yyyy HH:mm:ss',
      'dd-MM-yyyy hh:mm a',
      'dd/MM/yyyy hh:mm a',
      'yyyy-MM-dd',
      'dd-MM-yyyy',
      'dd/MM/yyyy',
    ];

    for (String pattern in patterns) {
      try {
        DateTime dt = DateFormat(pattern).parse(strDate);
        return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
      } catch (_) {}
    }

    return strDate;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.getProfileApi(context: context);
    });
  }

  void _showEditProfileModal(BuildContext context) {
    var user = authController.profileData;
    TextEditingController nameController = TextEditingController(
      text: user['name']?.toString() ?? user['username']?.toString() ?? "",
    );
    TextEditingController emailController = TextEditingController(
      text: user['email']?.toString() ?? "",
    );
    String? selectedImagePath;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 25,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 25,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: text(
                        "Update Profile",
                        textColor: blackColor,
                        fontSize: 20,
                        fontFamily: FontFamily.plusJakartaSansBold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: primaryColor, width: 2),
                            ),
                            child: ClipOval(
                              child: selectedImagePath != null
                                  ? Image.file(
                                      File(selectedImagePath!),
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.person, size: 50, color: greyColor),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(
                                  source: ImageSource.gallery,
                                );
                                if (image != null) {
                                  setModalState(() {
                                    selectedImagePath = image.path;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt, color: white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    text(
                      "Full Name",
                      fontFamily: FontFamily.plusJakartaSansMedium,
                      textColor: blackColor,
                      fontSize: 14,
                    ),
                    const SizedBox(height: 8),
                    CustomRoundTextField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      hintText: "Enter full name",
                      maxLines: 2,
                      fillColor: Colors.transparent,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                        LengthLimitingTextInputFormatter(40),
                      ],
                    ),
                    const SizedBox(height: 15),
                    text(
                      "Email Address",
                      fontFamily: FontFamily.plusJakartaSansMedium,
                      textColor: blackColor,
                      fontSize: 14,
                    ),
                    const SizedBox(height: 8),
                    CustomRoundTextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      hintText: "Enter email address",
                      maxLines: 2,
                      fillColor: Colors.transparent,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(50),
                      ],
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Obx(() {
                        return authController.isLoading.value
                            ? const Center(child: CircularProgressIndicator(color: primaryColor))
                            : CommonButton(
                                text: "Update Profile",
                                textColor: white,
                                fontFamily: FontFamily.plusJakartaSansMedium,
                                fontWeight: FontWeight.w400,
                                gradient: const LinearGradient(
                                  colors: [primaryColor, secondaryColor],
                                ),
                                borderRadius: BorderRadius.circular(15),
                                onPressed: () {
                                  String name = nameController.text.trim();
                                  String email = emailController.text.trim();

                                  RegExp nameReg = RegExp(r'^[a-zA-Z\s]+$');
                                  RegExp emailReg = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

                                  if (name.isEmpty) {
                                    Fluttertoast.showToast(
                                      msg: "Please enter your full name",
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                    );
                                  } else if (!nameReg.hasMatch(name)) {
                                    Fluttertoast.showToast(
                                      msg: "Please enter a valid name (alphabets only)",
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                    );
                                  } else if (name.length < 2) {
                                    Fluttertoast.showToast(
                                      msg: "Name must be at least 2 characters long",
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                    );
                                  } else if (email.isEmpty) {
                                    Fluttertoast.showToast(
                                      msg: "Please enter your email address",
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                    );
                                  } else if (!emailReg.hasMatch(email)) {
                                    Fluttertoast.showToast(
                                      msg: "Please enter a valid email address",
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                    );
                                  } else {
                                    String currentEmail = user['email']?.toString() ?? user['user']?['email']?.toString() ?? "";
                                    if (currentEmail.isNotEmpty && email.toLowerCase() != currentEmail.toLowerCase()) {
                                      Navigator.pop(ctx);
                                      Fluttertoast.showToast(
                                        msg: "Please verify your new email address to complete the update.",
                                        backgroundColor: primaryColor,
                                        textColor: Colors.white,
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => VerifiedScreen(
                                            email: email,
                                            mobile: user['phone']?.toString() ?? user['mobile']?.toString(),
                                          ),
                                        ),
                                      );
                                    } else {
                                      authController.updateProfileApi(
                                        context: ctx,
                                        name: name,
                                        email: email,
                                        profileImage: selectedImagePath,
                                        onSuccess: () {
                                          Navigator.pop(ctx);
                                        },
                                      );
                                    }
                                  }
                                },
                              );
                      }),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _buildSectionHeader("Profile", "Settings"),
                  const SizedBox(height: 15),
                  _buildListItem(
                    icon: Icons.person,
                    iconColor: const Color(0xff6e2ae9),
                    title: "Update Profile",
                    subtitle: "Manage your personal profile details",
                    onTap: () => _showEditProfileModal(context),
                  ),
                  _buildListItem(
                    icon: Icons.history,
                    iconColor: const Color(0xfff59e0b),
                    title: "Transaction History",
                    subtitle: "View your past transactions & bill payments",
                    onTap: () => _showTransactionHistoryModal(context),
                  ),
                  /*
                  const SizedBox(height: 25),
                  _buildSectionHeader("Payment", "Settings"),
                  const SizedBox(height: 15),
                  _buildListItem(
                    icon: Icons.account_balance,
                    iconColor: const Color(0xff4b68e9),
                    title: "Linked Bank Accounts",
                    subtitle: "Manage linked bank accounts",
                  ),
                  _buildListItem(
                    icon: Icons.credit_card,
                    iconColor: const Color(0xff3b82f6),
                    title: "Saved Cards",
                    subtitle: "Manage saved credit and debit cards",
                  ),
                  _buildListItem(
                    icon: Icons.calendar_month,
                    iconColor: const Color(0xff14b8a6), // Teal
                    title: "Autopay Settings",
                    subtitle: "Manage recurring autopay mandates",
                  ),
                  _buildListItem(
                    icon: Icons.settings,
                    iconColor: const Color(0xff06b6d4), // Cyan
                    title: "UPI Settings",
                    subtitle: "Manage your UPI IDs and PINs",
                  ),
                  */
                  const SizedBox(height: 25),
                  _buildSectionHeader("Security", "& Privacy"),
                  const SizedBox(height: 15),
                  _buildListItem(
                    icon: Icons.description,
                    iconColor: const Color(0xff64748b), // Slate Grey
                    title: "Terms & Conditions",
                    subtitle: "Read terms and conditions",
                    onTap: () => _openCmsPage(context, "Terms & Conditions", "terms_conditions"),
                  ),
                  _buildListItem(
                    icon: Icons.privacy_tip,
                    iconColor: const Color(0xff8b5cf6), // Purple
                    title: "Privacy & Policy",
                    subtitle: "Read our privacy policy",
                    onTap: () => _openCmsPage(context, "Privacy Policy", "privacy_policy"),
                  ),
                  _buildListItem(
                    icon: Icons.logout,
                    iconColor: Colors.red,
                    title: "Logout",
                    subtitle: "Log out of your account",
                    onTap: () => _showLogoutDialog(context),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTransactionHistoryModal(BuildContext context) {
    authController.getTransactionHistoryApi(context: context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 15),
                  text(
                    "Transaction History",
                    textColor: blackColor,
                    fontSize: 20,
                    fontFamily: FontFamily.plusJakartaSansBold,
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: Obx(() {
                      if (authController.isTransactionLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        );
                      }

                      var historyList = authController.transactionHistoryList;

                      if (historyList.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.history, size: 60, color: greyColor),
                              const SizedBox(height: 10),
                              text(
                                "No transaction history found",
                                textColor: greyColor,
                                fontSize: 14,
                                fontFamily: FontFamily.plusJakartaSansMedium,
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        controller: scrollController,
                        itemCount: historyList.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          var item = historyList[index];
                          String title = item['title']?.toString() ??
                              item['description']?.toString() ??
                              item['type']?.toString() ??
                              item['service_name']?.toString() ??
                              "Transaction";
                          String amount = item['amount']?.toString() ?? "0";
                          String status = item['status']?.toString() ?? "Success";
                          String date = _formatDateTime(item);

                          bool isSuccess = status.toLowerCase() == "success" || status == "1" || status == "true";

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: (isSuccess ? Colors.green : Colors.red).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isSuccess ? Icons.arrow_downward : Icons.close,
                                color: isSuccess ? Colors.green : Colors.red,
                                size: 20,
                              ),
                            ),
                            title: text(
                              title,
                              textColor: blackColor,
                              fontSize: 15,
                              fontFamily: FontFamily.plusJakartaSansBold,
                            ),
                            subtitle: date.isNotEmpty
                                ? text(
                                    date,
                                    textColor: greyColor,
                                    fontSize: 12,
                                    fontFamily: FontFamily.plusJakartaSansRegular,
                                  )
                                : null,
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                text(
                                  "₹ $amount",
                                  textColor: blackColor,
                                  fontSize: 16,
                                  fontFamily: FontFamily.plusJakartaSansBold,
                                ),
                                text(
                                  status,
                                  textColor: isSuccess ? Colors.green : Colors.red,
                                  fontSize: 12,
                                  fontFamily: FontFamily.plusJakartaSansMedium,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openCmsPage(BuildContext context, String pageTitle, String key) {
    CmsHelper.openCmsBottomSheet(context, pageTitle, key);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: greyColor)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await authController.logoutApi(context: context);
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 240,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Curve
          Positioned(
            top: -100,
            left: -150,
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // SafeArea(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: const [
          //         Icon(Icons.sort, color: white, size: 28),
          //       ],
          //     ),
          //   ),
          // ),

          // User Info Section
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Obx(() {
              var user = authController.profileData;
              String name = user['name']?.toString() ??
                  user['username']?.toString() ??
                  "User Name";
              String phone = user['phone']?.toString() ??
                  user['mobile']?.toString() ??
                  user['contact']?.toString() ??
                  "";
              String email = user['email']?.toString() ?? "";
              String? profileImg = user['profile_image_url']?.toString() ?? user['avatar']?.toString();

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: white, width: 3),
                    ),
                    child: ClipOval(
                      child: Obx(() {
                        // 1. Show local image immediately after update
                        final localPath = authController.localProfileImagePath.value;
                        if (localPath != null && localPath.isNotEmpty) {
                          return Image.file(
                            File(localPath),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.person, size: 50, color: greyColor),
                          );
                        }
                        // 2. Fall back to network URL from API
                        if (profileImg != null && profileImg.startsWith('http')) {
                          return Image.network(
                            profileImg,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.person, size: 50, color: greyColor),
                          );
                        }
                        return const Icon(Icons.person, size: 50, color: greyColor);
                      }),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(
                          name,
                          textColor: blackColor,
                          fontSize: 20,
                          fontFamily: FontFamily.plusJakartaSansBold,
                        ),
                        if (phone.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          text(
                            phone.startsWith('+') ? phone : "+91 $phone",
                            textColor: blackColor.withOpacity(0.8),
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                          ),
                        ],
                        if (email.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          text(
                            email,
                            textColor: greyColor,
                            fontSize: 12,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                          ),
                        ],
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => _showEditProfileModal(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: secondaryColor, // Pink color
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, color: white, size: 18),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String pinkText, String blackText) {
    return Row(
      children: [
        text(
          pinkText,
          textColor: secondaryColor, // Pink
          fontSize: 16,
          fontFamily: FontFamily.plusJakartaSansBold,
        ),
        const SizedBox(width: 4),
        text(
          blackText,
          textColor: blackColor,
          fontSize: 16,
          fontFamily: FontFamily.plusJakartaSansBold,
        ),
      ],
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 24),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text(
                        title,
                        textColor: blackColor,
                        fontSize: 16,
                        fontFamily: FontFamily.plusJakartaSansBold,
                      ),
                      const SizedBox(height: 2),
                      text(
                        subtitle,
                        textColor: greyColor,
                        fontSize: 12,
                        fontFamily: FontFamily.plusJakartaSansRegular,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward, color: blackColor, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade200, thickness: 1, height: 1),
          ],
        ),
      ),
    );
  }
}
