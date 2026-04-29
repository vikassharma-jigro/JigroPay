import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jigrotech/View/auth_view/signup_screen.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/custom_textFiled.dart';
import '../../app_utils/font_family.dart';
import '../../app_utils/showAlertMessage.dart';
import '../../app_utils/text_widget.dart';
import '../../main.dart';
import 'package:flutter/gestures.dart';

import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  bool isChecked = false;
  bool? isLoading;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GradientAppScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios, color: purpleGradientColor),
              ),
              const SizedBox(height: 30),
              Center(child: Image.asset(AppImages.splashIcon, height: 100)),
              const SizedBox(height: 50),
              text(
                "Login to JigroPay",
                textColor: blackColor,
                fontSize: 20,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 5),
              text(
                "Login to Light is your pathway to a seamless digital experience.",
                fontFamily: FontFamily.plusJakartaSansRegular,
                textColor: greyColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 40),
              text(
                "Phone",
                fontFamily: FontFamily.plusJakartaSansMedium,
                textColor: blackColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 10),
              CustomRoundTextField(
                controller: phoneController,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Image.asset(AppImages.phoneIcon, height: 20),
                ),
                keyboardType: TextInputType.phone,
                hintText: "Phone",
                maxLines: 2,
                fillColor: Colors.transparent,
                //padding: const EdgeInsets.symmetric(vertical: 2),
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 55,
                child: CommonButton(
                  text: "Login",
                  textColor: white,
                  gradient: const LinearGradient(
                    colors: [pinkColor, purpleGradientColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  fontWeight: FontWeight.w600,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontSize: 16.0,

                  //padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  //borderRadius: BorderRadius.circular(40.0),
                  onPressed: () {
                    if (phoneController.text.isEmpty) {
                      ShowAlertDialog().showErrorAlert(
                        context,
                        "Please Enter Your Contact Number",
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OtpScreen(mobileNumber: phoneController.text),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  height: 3,
                  width: 150,
                  color: purpleGradientColor,
                ),
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: 'Don’t have an account?  ',
                      style: TextStyle(
                        color: blackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: FontFamily.plusJakartaSansRegular,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                            color: pinkColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w400,
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
              //         side: const BorderSide(color: purpleGradientColor,width: 1)
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
    );
  }
}
