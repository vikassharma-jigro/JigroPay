import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jigrotech/View/auth_view/verified_screen.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/custom_textFiled.dart';
import '../../app_utils/font_family.dart';
import '../../app_utils/showAlertMessage.dart';
import '../../app_utils/text_widget.dart';
import '../../getx_controller/auth_controller.dart';
import '../../main.dart';
import '../../app_utils/cms_helper.dart';
import 'package:flutter/gestures.dart';

import 'championScreen.dart';
import 'otp_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailNumberController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isChecked = false;
  String? nameError;
  String? emailError;
  String? phoneError;

  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios, color: blackColor),
            ),
            Expanded(
              child: Center(
                child: Image.asset(AppImages.jigroImage, height: 40),
              ),
            ),
            const SizedBox(width: 24),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              text(
                "Create your account",
                textColor: blackColor,
                fontSize: 22,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 5),
              text(
                "User-friendly solutions. Join us now to unlock a brighter online journey.",
                fontFamily: FontFamily.plusJakartaSansRegular,
                textColor: greyColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 25),
              text(
                "Full Name",
                fontFamily: FontFamily.plusJakartaSansMedium,
                textColor: blackColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 8),
              CustomRoundTextField(
                controller: nameController,
                // prefixIcon: Padding(
                //   padding: const EdgeInsets.only(left: 8.0),
                //   child: SvgPicture.asset(AppImages.userIcon),
                // ),
                keyboardType: TextInputType.name,
                maxLines: 1,
                hintText: "Enter Full Name",
                fillColor: Colors.transparent,
                onChanged: (val) {
                  if (nameError != null) setState(() => nameError = null);
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                  LengthLimitingTextInputFormatter(40),
                ],
              ),
              if (nameError != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, top: 4.0, bottom: 8.0),
                  child: Text(
                    nameError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              text(
                "Email Address",
                fontFamily: FontFamily.plusJakartaSansMedium,
                textColor: blackColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 8),
              CustomRoundTextField(
                controller: emailNumberController,
                // prefixIcon: Padding(
                //   padding: const EdgeInsets.only(left: 8.0),
                //   child: Image.asset(AppImages.emailIcon, height: 5),
                // ),
                hintText: "Enter Email Address",
                keyboardType: TextInputType.emailAddress,
                maxLines: 1,
                fillColor: Colors.transparent,
                onChanged: (val) {
                  if (emailError != null) setState(() => emailError = null);
                },
                inputFormatters: [LengthLimitingTextInputFormatter(50)],
              ),
              if (emailError != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, top: 4.0, bottom: 8.0),
                  child: Text(
                    emailError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              text(
                "Mobile Number",
                fontFamily: FontFamily.plusJakartaSansMedium,
                textColor: blackColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 8),
              CustomRoundTextField(
                controller: phoneController,
                // prefixIcon: Padding(
                //   padding: const EdgeInsets.only(left: 8.0),
                //   child: Image.asset(AppImages.phoneIcon, height: 5),
                // ),
                keyboardType: TextInputType.number,
                hintText: "Enter Mobile Number",
                maxLines: 1,
                fillColor: Colors.transparent,
                onChanged: (val) {
                  if (phoneError != null) setState(() => phoneError = null);
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              if (phoneError != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, top: 4.0, bottom: 8.0),
                  child: Text(
                    phoneError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                    activeColor: purpleGradientColor,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    side: const BorderSide(
                      color: primaryColor,
                      width: 1,
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text:
                            'I certify that I am 18 years of age or older, and I agree to the ',
                        style: const TextStyle(
                          color: greyColor,
                          fontSize: 11,
                          fontFamily: FontFamily.plusJakartaSansRegular,
                          fontWeight: FontWeight.w400,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: const TextStyle(
                              color: pinkColor,
                              fontSize: 12,
                              fontFamily: FontFamily.plusJakartaSansRegular,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                CmsHelper.openCmsBottomSheet(
                                  context,
                                  "Terms & Conditions",
                                  "terms_conditions",
                                );
                              },
                          ),
                          const TextSpan(
                            text: ' and ',
                            style: TextStyle(
                              color: blackColor,
                              fontSize: 11,
                              fontFamily: FontFamily.plusJakartaSansRegular,
                            ),
                          ),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: const TextStyle(
                              color: pinkColor,
                              fontSize: 12,
                              fontFamily: FontFamily.plusJakartaSansRegular,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                CmsHelper.openCmsBottomSheet(
                                  context,
                                  "Privacy Policy",
                                  "privacy_policy",
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 55,
                child: CommonButton(
                  text: "Continue",
                  textColor: white,
                  gradient: isChecked
                      ? const LinearGradient(
                          colors: [primaryColor, secondaryColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: [Colors.grey.shade400, Colors.grey.shade500],
                        ),
                  fontWeight: FontWeight.w600,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontSize: 16.0,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    String name = nameController.text.trim();
                    String email = emailNumberController.text.trim();
                    String phone = phoneController.text.trim();

                    RegExp alphaOnly = RegExp(r'^[a-zA-Z\s]+$');
                    RegExp emailReg = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                    RegExp phoneReg = RegExp(r'^[6-9]\d{9}$');

                    setState(() {
                      nameError = null;
                      emailError = null;
                      phoneError = null;
                    });

                    bool hasError = false;

                    if (name.isEmpty) {
                      nameError = "Please enter your full name";
                      hasError = true;
                    } else if (!alphaOnly.hasMatch(name)) {
                      nameError = "Please enter a valid name (alphabets only)";
                      hasError = true;
                    } else if (name.length < 2) {
                      nameError = "Full name must be at least 2 characters long";
                      hasError = true;
                    }

                    if (email.isEmpty) {
                      emailError = "Please enter your email address";
                      hasError = true;
                    } else if (!emailReg.hasMatch(email)) {
                      emailError = "Please enter a valid email address";
                      hasError = true;
                    }

                    if (phone.isEmpty) {
                      phoneError = "Please enter your mobile number";
                      hasError = true;
                    } else if (!phoneReg.hasMatch(phone)) {
                      phoneError = "Please enter a valid 10-digit mobile number";
                      hasError = true;
                    }

                    if (hasError) {
                      setState(() {});
                      return;
                    }

                    if (!isChecked) {
                      Fluttertoast.showToast(
                        msg: "Please select the checkbox to agree to terms",
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                      return;
                    }

                    authController.registerUserApi(
                      context: context,
                      name: name,
                      email: email,
                      phone: phone,
                      onSuccess: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtpScreen(
                              mobileNumber: phone,
                              email: email,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(
                        color: greyColor,
                        fontSize: 14,
                        fontFamily: FontFamily.plusJakartaSansMedium,
                      ),
                      children: [
                        TextSpan(
                          text: "Log In",
                          style: TextStyle(
                            color: secondaryColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
