import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/input_validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.phone, this.email});

  final String phone;
  final String? email;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  Timer? _timer;
  final int _timerMaxSeconds = 60;
  int _currentSeconds = 0;
  String _fcmToken = '';

  @override
  void initState() {
    super.initState();
    _startTimeout();
    _initFcmToken();
  }

  Future<void> _initFcmToken() async {
    try {
      final savedToken = await StorageService.instance.getFcmToken();
      if (savedToken != null && mounted) {
        setState(() {
          _fcmToken = savedToken;
        });
        return;
      }
      if (!kIsWeb && Platform.isIOS) {
        final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken == null) return;
      }
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null && mounted) {
        setState(() {
          _fcmToken = token;
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimeout() {
    _timer?.cancel();
    setState(() => _currentSeconds = 0);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _currentSeconds = timer.tick;
        if (timer.tick >= _timerMaxSeconds) {
          timer.cancel();
        }
      });
    });
  }

  String get _timerText {
    final remaining = _timerMaxSeconds - _currentSeconds;
    final mins = (remaining ~/ 60).toString().padLeft(2, '0');
    final secs = (remaining % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  String get _maskedMobileNumber {
    final clean = widget.phone.replaceAll(RegExp(r'\D'), '');
    if (clean.length == 10) {
      return '${clean.substring(0, 2)}****${clean.substring(6, 8)}**';
    }
    return widget.phone;
  }

  void _onVerifyPressed() {
    FocusScope.of(context).unfocus();
    final otp = _otpController.text.trim();
    final error = InputValidators.otp(otp);

    if (error != null) {
      Fluttertoast.showToast(
        msg: error,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    context.read<AuthCubit>().verifyOtp(
      phone: widget.phone,
      otp: otp,
      fcmToken: _fcmToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Fluttertoast.showToast(
            msg: 'OTP verified successfully.',
            gravity: ToastGravity.CENTER,
            backgroundColor: AppColors.primary,
            textColor: Colors.white,
          );
          context.go('/dashboard');
        } else if (state is AuthError) {
          Fluttertoast.showToast(
            msg: state.message,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          context.read<AuthCubit>().reset();
        } else if (state is AuthOtpSent) {
          _startTimeout();
          _otpController.clear();
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
              onPressed: () => context.pop(),
            ),
            title: Center(child: Image.asset(AppAssets.jigro, height: 40)),
            actions: const [SizedBox(width: 48)],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Image.asset(AppAssets.lMobile)),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Enter Verification ',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppTypography.outfitMedium,
                          ),
                        ),
                        Text(
                          'OTP',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppTypography.outfitMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "We've sent a 6-digit OTP to your mobile number +91 $_maskedMobileNumber.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppTypography.outfitRegular,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: PinCodeTextField(
                      appContext: context,
                      length: 6,
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textStyle: const TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      cursorColor: AppColors.primary,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(10),
                        fieldWidth:
                            (MediaQuery.of(context).size.width / 6) - 16,
                        fieldHeight: 52,
                        activeFillColor: AppColors.white,
                        inactiveFillColor: AppColors.white,
                        selectedFillColor: AppColors.white,
                        activeColor: AppColors.secondary,
                        inactiveColor: Colors.grey.shade300,
                        selectedColor: AppColors.primary,
                        borderWidth: 1.5,
                      ),
                      enableActiveFill: true,
                      onChanged: (_) {},
                      onCompleted: (_) => _onVerifyPressed(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  AppButton(
                    label: 'Verify & Continue',
                    isLoading: isLoading,
                    onPressed: isLoading ? null : _onVerifyPressed,
                  ),
                  const SizedBox(height: 20),
                  if (_currentSeconds >= _timerMaxSeconds)
                    Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Didn't receive the code? ",
                              style: TextStyle(
                                color: AppColors.grey,
                                fontSize: 13,
                                fontFamily: AppTypography.outfitRegular,
                              ),
                            ),
                            TextSpan(
                              text: 'Resend Code',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.read<AuthCubit>().resendOtp(
                                    phone: widget.phone,
                                    email: widget.email,
                                  );
                                },
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppTypography.outfitBold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Time Left $_timerText',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.grey,
                            fontFamily: AppTypography.outfitBold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
