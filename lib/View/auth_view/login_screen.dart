import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jigrotech/View/auth_view/signup_screen.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/custom_textFiled.dart';
import '../../app_utils/font_family.dart';
import '../../app_utils/showAlertMessage.dart';
import '../../app_utils/text_widget.dart';
import '../../main.dart';
import '../../app_utils/cms_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';

import '../../getx_controller/auth_controller.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  final AuthController authController = Get.put(AuthController());
  bool isChecked = false;
  bool? isLoading;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        automaticallyImplyLeading: false,
        title:  Center(child: Image.asset(AppImages.jigroImage,height: 40,)),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Image.asset(AppImages.lMobileImage,)),
                const SizedBox(height: 10),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      text(
                        "Enter your",
                        textColor: blackColor,
                        fontSize: 30,
                        fontFamily: FontFamily.plusJakartaSansMedium,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(width: 5,),
                      text(
                        "mobile",
                        textColor: secondaryColor,
                        fontSize: 30,
                        fontFamily: FontFamily.plusJakartaSansMedium,
                        fontWeight: FontWeight.w500,
                      ),

                    ],
                  ),
                ),
                Center(
                  child: text(
                    "number",
                    textColor: blackColor,
                    fontSize: 30,
                    fontFamily: FontFamily.plusJakartaSansMedium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: text(
                    "We will send you an OTP to verify",
                    fontFamily: FontFamily.plusJakartaSansMedium,
                    textColor: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),
                CustomRoundTextField(
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  hintText: "Enter 10-digit mobile number",
                  maxLines: 2,
                  fillColor: Colors.transparent,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
                //const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: 48,
                  child: Obx(() {
                    return authController.isLoading.value
                        ? const Center(child: CircularProgressIndicator(color: primaryColor))
                        : CommonButton(
                            text: "Continue",
                            textColor: white,
                            gradient: const LinearGradient(
                              colors: [primaryColor, secondaryColor],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            fontWeight: FontWeight.w600,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontSize: 16.0,
                            borderRadius: BorderRadius.circular(15),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              String phone = phoneController.text.trim();
                              RegExp regExp = RegExp(r'^[6-9]\d{9}$');
                              if (phone.isEmpty) {
                                Fluttertoast.showToast(
                                  msg: "Please enter your mobile number",
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                );
                              } else if (!regExp.hasMatch(phone)) {
                                Fluttertoast.showToast(
                                  msg: "Please enter a valid 10-digit mobile number",
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                );
                              } else {
                                authController.sendOtpApi(
                                  context: context,
                                  mobileNumber: phone,
                                  onSuccess: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OtpScreen(mobileNumber: phone),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          );
                  }),
                ),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      text: 'By continuing, you agree to our ',
                      style: const TextStyle(
                        color: blackColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: FontFamily.plusJakartaSansRegular,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: const TextStyle(
                            color: secondaryColor,
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
                          text: ' & ',
                          style: TextStyle(
                            color: blackColor,
                            fontSize: 12,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                          ),
                        ),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: const TextStyle(
                            color: secondaryColor,
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
                const SizedBox(height: 25),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          color: greyColor,
                          fontSize: 14,
                          fontFamily: FontFamily.plusJakartaSansMedium,
                        ),
                        children: [
                          TextSpan(
                            text: "Sign Up",
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
                // const SizedBox(height: 20,),
                // SizedBox(
                //   width: MediaQuery.sizeOf(context).width,
                //   height: 55,
                //   child: Container(
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       border: Border.all(color: pinkColor)
                //     ),
                //     child:Center(
                //       child: text("Connect to a wallet",
                //           fontFamily: FontFamily.plusJakartaSansBold,
                //           textColor:blackColor,fontSize: 14,fontWeight: FontWeight.w400),
                //     ),
                //   )
                // ),
                // const SizedBox(height: 20,),
                // Row(
                //   children: [
                //     Checkbox(
                //         checkColor: Colors.white,
                //         value: isChecked,
                //         onChanged: (bool? value) {
                //           setState(() {
                //             isChecked = value!;
                //             print("hhh>>>$isChecked");
                //           });
                //         },
                //         activeColor: purpleGradientColor,
                //         //checkColor: Colors.white,
                //         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //         visualDensity: VisualDensity.compact,
                //         side: const BorderSide(color: primaryColor,width: 1)
                //     ),
                //
                //     Align(
                //       alignment: Alignment.center,
                //       child: RichText(
                //         text:  TextSpan(
                //           text: 'I certify that I am 18 years of age or older, and I agree to the\n',
                //           style:  TextStyle(color: greyColor,fontSize:10,fontFamily: FontFamily.plusJakartaSansRegular,
                //               fontWeight: FontWeight.w400
                //           ),
                //           children: <TextSpan>[
                //             TextSpan(
                //               text: 'User Agreement ',
                //               style:  TextStyle(color: pinkColor,fontSize:12 ,
                //                   fontFamily: FontFamily.plusJakartaSansRegular,
                //                   fontWeight: FontWeight.w400
                //               ),
                //               recognizer: TapGestureRecognizer()
                //                 ..onTap = () {
                //
                //                 },
                //             ),
                //             TextSpan(
                //               text: 'and ',
                //               style:  TextStyle(color: blackColor,fontSize:10 ,
                //                   fontFamily: FontFamily.plusJakartaSansRegular,
                //                   fontWeight: FontWeight.w400
                //               ),
                //               recognizer: TapGestureRecognizer()
                //                 ..onTap = () {
                //
                //                 },
                //             ),
                //             TextSpan(
                //               text: 'Privacy Policy',
                //               style:  TextStyle(color: pinkColor,fontSize:12 ,
                //                   fontFamily: FontFamily.plusJakartaSansRegular,
                //                   fontWeight: FontWeight.w400
                //               ),
                //               recognizer: TapGestureRecognizer()
                //                 ..onTap = () {
                //
                //                 },
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
