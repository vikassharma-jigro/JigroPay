import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jigrotech/app_utils/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../app_utils/app_images.dart';
import '../../app_utils/font_family.dart';
import '../../app_utils/text_widget.dart';
import 'package:flutter/gestures.dart';

import '../../main.dart';
import 'championScreen.dart';



class EmailOtpScreen extends StatefulWidget {
  final String? email;
  final String? mobile;
  const EmailOtpScreen({super.key,this.email,this.mobile});

  @override
  State<EmailOtpScreen> createState() => _EmailOtpScreenState();
}


class _EmailOtpScreenState extends State<EmailOtpScreen> {
  // late OTPTextEditController phoneNumberController;
  TextEditingController emailNumberController = TextEditingController();
 Timer? _timer;
  final interval = const Duration(seconds: 1);
  final int timerMaxSeconds = 60;
  int currentSeconds = 0;
  //late OTPInteractor _otpInteractor;
  @override
  void initState() {
    startTimeout();
    // _otpInteractor = OTPInteractor();
    // phoneNumberController = OTPTextEditController(
    //   codeLength: 6,
    //   onCodeReceive: (code) {
    //     print("📥 OTP Received: $code");
    //   },
    // );

    // _startListening();
    super.initState();
  }
  // void _startListening() async {
  //   await _otpInteractor.getAppSignature(); // print this if backend needs it
  //   phoneNumberController.startListenUserConsent(
  //         (code) {
  //       // Extract the OTP using RegExp
  //       final otp = RegExp(r'\d{6}').stringMatch(code ?? '');
  //       return otp??"";
  //     },
  //     // strategies: [UserConsentStrategy()],
  //   );
  // }


  @override
  void dispose() {
    // phoneNumberController.stopListen();
    _timer?.cancel();// Stop SMS listening
    super.dispose();
  }
  String get timerText => '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}:${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout() {
    var duration = interval;
    _timer = Timer.periodic(duration, (timer) {
      setState(() {
        // print(timer.tick);
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) timer.cancel();
      });
    });
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
              SizedBox(height: 10,),
              InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_ios,color: pinkColor,)),
              SizedBox(height: 25,),
              Center(
                child: Image.asset(AppImages.splashIcon,height: 100,),
              ),
              const SizedBox(
                height: 45,
              ),
              text("Enter authentication code "  ,
                  textAlign: TextAlign.center,
                  textColor:blackColor,fontSize: 19,fontWeight: FontWeight.w600,fontFamily: FontFamily.plusJakartaSansBold),
              text("Enter the 6-digit code we just texted to your email address ${widget.email}."  ,
                  textAlign: TextAlign.center,
                  textColor:greyColor,fontSize: 14,fontWeight: FontWeight.w500,
                  fontFamily: FontFamily.plusJakartaSansRegular),


              const SizedBox(
                height: 30,
              ),
              Padding(
                padding:  const EdgeInsets.only(left:  15, right: 15),
                child: PinCodeTextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), FilteringTextInputFormatter.digitsOnly],
                  appContext: context,
                  length: 6,
                  textStyle: const TextStyle(color: blackColor),
                  obscureText: false,
                  cursorColor: purpleGradientColor,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10),
                      fieldWidth: (MediaQuery.of(context).size.width / 6) - 17,
                      activeFillColor: white,
                      inactiveColor: purpleGradientColor,
                      activeColor:pinkColor,
                      disabledColor: blueColor,
                      errorBorderColor: Colors.red,
                      inactiveFillColor: white,
                      selectedFillColor: white,
                      borderWidth: 0,
                      inactiveBorderWidth: 1,
                      activeBoxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          spreadRadius: 1,
                          offset: const Offset(2, 2),
                        ),
                      ],


                      //borderWidth: 2,
                      selectedColor: purpleGradientColor),
                  animationDuration: const Duration(milliseconds: 800),
                  enableActiveFill: true,
                  controller: emailNumberController,
                  onCompleted: (otp) {

                  },
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      // currentText = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 30,),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 55,
                child: CommonButton(
                  text: "Submit",
                  gradient: const LinearGradient(
                    colors: [pinkColor, purpleGradientColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  textColor: white,
                  fontWeight: FontWeight.w500,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontSize:18.0,
                  //padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  borderRadius: BorderRadius.circular(15.0),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  VerifiedChampionScreen(mobile: widget.mobile,),));

                  },),
              ),

              const SizedBox(height: 20,),
              Center(
                child: Container(
                  height: 3,
                  width: 150,
                  color: purpleGradientColor,
                ),
              ),
              const SizedBox(height: 20,),
              currentSeconds == 60
                  ? Center(
                child: RichText(
                    text: TextSpan(children: [
                      const TextSpan(
                          text: 'Dont receive the code? ',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily:
                              FontFamily.plusJakartaSansRegular)),
                      TextSpan(
                          text: 'Resend Code',
                          recognizer:  TapGestureRecognizer()
                            ..onTap = () {
                              _timer?.cancel();
                              startTimeout();
                              startTimeout();
                            },
                          style: const TextStyle(
                              decoration: TextDecoration.underline,
                              color: purpleGradientColor,
                              fontSize: 12,
                              fontFamily:
                              FontFamily.plusJakartaSansRegular))
                    ])),
              ):
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Time Left ${timerText}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: FontFamily.plusJakartaSansBold,
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
