import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/input_validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/cms_bottom_sheet.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isChecked = false;
  String? _nameError;
  String? _emailError;
  String? _phoneError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onContinue() {
    FocusScope.of(context).unfocus();
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    setState(() {
      _nameError = InputValidators.requiredName(name, fieldName: 'Full Name');
      _emailError = InputValidators.email(email);
      _phoneError = InputValidators.mobile(phone);
    });

    if (_nameError != null || _emailError != null || _phoneError != null) {
      return;
    }

    if (!_isChecked) {
      Fluttertoast.showToast(
        msg: 'Please select the checkbox to agree to terms',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    context.read<AuthCubit>().register(
          name: name,
          email: email,
          phone: phone,
        );
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
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
              onPressed: () => context.pop(),
            ),
            title: Center(
              child: Image.asset(AppAssets.jigro, height: 40),
            ),
            actions: const [SizedBox(width: 48)],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Create your account',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 22,
                      fontFamily: AppTypography.outfitBold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'User-friendly solutions. Join us now to unlock a brighter online journey.',
                    style: TextStyle(
                      fontFamily: AppTypography.outfitRegular,
                      color: AppColors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Full Name',
                    style: TextStyle(
                      fontFamily: AppTypography.outfitMedium,
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppTextField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    hint: 'Enter Full Name',
                    onChanged: (_) {
                      if (_nameError != null) setState(() => _nameError = null);
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                      LengthLimitingTextInputFormatter(40),
                    ],
                  ),
                  if (_nameError != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, top: 4.0),
                      child: Text(
                        _nameError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 16),
                  const Text(
                    'Email Address',
                    style: TextStyle(
                      fontFamily: AppTypography.outfitMedium,
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppTextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    hint: 'Enter Email Address',
                    onChanged: (_) {
                      if (_emailError != null) {
                        setState(() => _emailError = null);
                      }
                    },
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50),
                    ],
                  ),
                  if (_emailError != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, top: 4.0),
                      child: Text(
                        _emailError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 16),
                  const Text(
                    'Mobile Number',
                    style: TextStyle(
                      fontFamily: AppTypography.outfitMedium,
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppTextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    hint: 'Enter 10-digit mobile number',
                    onChanged: (_) {
                      if (_phoneError != null) {
                        setState(() => _phoneError = null);
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                  if (_phoneError != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, top: 4.0),
                      child: Text(
                        _phoneError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value: _isChecked,
                        onChanged: (val) {
                          setState(() {
                            _isChecked = val ?? false;
                          });
                        },
                        activeColor: AppColors.primary,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        side: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text:
                                'I certify that I am 18 years of age or older, and I agree to the ',
                            style: const TextStyle(
                              color: AppColors.grey,
                              fontSize: 12,
                              fontFamily: AppTypography.outfitRegular,
                              fontWeight: FontWeight.w400,
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
                                text: ' and ',
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
                    ],
                  ),
                  const SizedBox(height: 30),
                  AppButton(
                    label: 'Continue',
                    isLoading: isLoading,
                    isEnabled: _isChecked,
                    onPressed: (_isChecked && !isLoading) ? _onContinue : null,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child: RichText(
                        text: const TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 14,
                            fontFamily: AppTypography.outfitMedium,
                          ),
                          children: [
                            TextSpan(
                              text: 'Login',
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
        );
      },
    );
  }
}
