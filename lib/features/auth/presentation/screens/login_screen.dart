import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_auth/smart_auth.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/input_validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/cms_bottom_sheet.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  bool _isRequestingPhoneNumber = false;
  bool _hasDismissedHint = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  Future<void> _requestPhoneNumberHint({bool force = false}) async {
    if (kIsWeb || !Platform.isAndroid) return;
    if (_isRequestingPhoneNumber) return;
    if (!force && _phoneController.text.trim().isNotEmpty) return;
    if (!force && _hasDismissedHint && _phoneController.text.trim().isEmpty) {
      return;
    }

    _isRequestingPhoneNumber = true;
    try {
      FocusScope.of(context).unfocus();
      final res = await SmartAuth.instance.requestPhoneNumberHint();
      if (res.hasData && res.data != null && res.data!.isNotEmpty) {
        final String raw = res.data!;
        String digits = raw.replaceAll(RegExp(r'\D'), '');
        if (digits.length > 10) {
          digits = digits.substring(digits.length - 10);
        }
        setState(() {
          _phoneController.text = digits;
          _phoneController.selection = TextSelection.fromPosition(
            TextPosition(offset: _phoneController.text.length),
          );
        });
        _hasDismissedHint = false;
      } else if (res.isCanceled) {
        _hasDismissedHint = true;
        if (mounted) {
          _phoneFocusNode.requestFocus();
        }
      }
    } catch (e) {
      debugPrint('SmartAuth requestPhoneNumberHint error: $e');
    } finally {
      _isRequestingPhoneNumber = false;
    }
  }

  void _onContinuePressed() {
    FocusScope.of(context).unfocus();
    final phone = _phoneController.text.trim();
    final error = InputValidators.mobile(phone);

    if (error != null) {
      Fluttertoast.showToast(
        msg: error,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    context.read<AuthCubit>().sendOtp(phone: phone);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthOtpSent) {
          Fluttertoast.showToast(
            msg: state.message,
            gravity: ToastGravity.CENTER,
            backgroundColor: AppColors.primary,
            textColor: Colors.white,
          );
          context.push(
            '/otp',
            extra: {'phone': state.phone, 'email': state.email},
          );
        } else if (state is AuthError) {
          Fluttertoast.showToast(
            msg: state.message,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          context.read<AuthCubit>().reset();
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Center(child: Image.asset(AppAssets.jigro, height: 40)),
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Image.asset(AppAssets.lMobile)),
                    const SizedBox(height: 10),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Enter your',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 30,
                              fontFamily: AppTypography.outfitMedium,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'mobile',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 30,
                              fontFamily: AppTypography.outfitMedium,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Center(
                      child: Text(
                        'number',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 30,
                          fontFamily: AppTypography.outfitMedium,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Center(
                      child: Text(
                        'We will send you an OTP to verify',
                        style: TextStyle(
                          fontFamily: AppTypography.outfitRegular,
                          color: AppColors.text,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    AppTextField(
                      controller: _phoneController,
                      focusNode: _phoneFocusNode,
                      keyboardType: TextInputType.number,
                      hint: 'Enter 10-digit mobile number',
                      onTap: _requestPhoneNumberHint,
                      onChanged: (val) {
                        if (val.isEmpty) {
                          _hasDismissedHint = false;
                        }
                      },
                      suffixWidget: IconButton(
                        icon: const Icon(
                          Icons.sim_card_outlined,
                          color: AppColors.primary,
                          size: 22,
                        ),
                        tooltip: 'Select SIM number',
                        onPressed: () => _requestPhoneNumberHint(force: true),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      label: 'Continue',
                      isLoading: isLoading,
                      onPressed: isLoading ? null : _onContinuePressed,
                    ),
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          text: 'By continuing, you agree to our ',
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppTypography.outfitRegular,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Terms & Conditions',
                              style: const TextStyle(
                                color: AppColors.secondary,
                                fontSize: 12,
                                fontFamily: AppTypography.outfitRegular,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  CmsBottomSheet.show(
                                    context,
                                    title: 'Terms & Conditions',
                                    pageKey: 'terms_conditions',
                                  );
                                },
                            ),
                            const TextSpan(
                              text: ' & ',
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 12,
                                fontFamily: AppTypography.outfitRegular,
                              ),
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: const TextStyle(
                                color: AppColors.secondary,
                                fontSize: 12,
                                fontFamily: AppTypography.outfitRegular,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  CmsBottomSheet.show(
                                    context,
                                    title: 'Privacy Policy',
                                    pageKey: 'privacy_policy',
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
                        onTap: () => context.push('/signup'),
                        child: RichText(
                          text: const TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              color: AppColors.grey,
                              fontSize: 14,
                              fontFamily: AppTypography.outfitMedium,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 14,
                                  fontFamily: AppTypography.outfitBold,
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
          ),
        );
      },
    );
  }
}
