import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:jigrotech/core/mixins/ui_feedback_mixin.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/input_validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/repositories/pan_service_repository_impl.dart';
import '../../domain/usecases/initiate_pan_application_usecase.dart';
import '../cubit/pan_service_cubit.dart';
import '../cubit/pan_service_state.dart';

class PanServicesScreen extends StatelessWidget {
  const PanServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = PanServiceRepositoryImpl();
    return BlocProvider(
      create: (context) => PanServiceCubit(
        initiatePanApplicationUseCase: InitiatePanApplicationUseCase(repo),
      ),
      child: const _PanServicesView(),
    );
  }
}

class _PanServicesView extends StatefulWidget {
  const _PanServicesView();

  @override
  State<_PanServicesView> createState() => _PanServicesViewState();
}

class _PanServicesViewState extends State<_PanServicesView>
    with UiFeedbackMixin {
  final TextEditingController _mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _mobileError;

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _handleUrlLaunch(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      showErrorToast('Invalid redirection URL received');
      return;
    }

    try {
      final launched = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        showErrorToast('Could not open browser. Please visit: $url');
      }
    }
  }

  void _onProceed() {
    final mobile = _mobileController.text.trim();
    final error = InputValidators.mobile(mobile);
    setState(() => _mobileError = error);

    if (error != null) {
      return;
    }

    context.read<PanServiceCubit>().initiatePanApplication(
      mobileNumber: mobile,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.black,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'PAN Services',
          style: TextStyle(
            fontSize: 18,
            fontFamily: AppTypography.outfitBold,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<PanServiceCubit, PanServiceState>(
        listener: (context, state) {
          if (state is PanServiceSuccess) {
            if (state.redirectUrl.startsWith('http://') ||
                state.redirectUrl.startsWith('https://')) {
              showLoadingToast('Redirecting to NSDL PAN portal...');
              _handleUrlLaunch(state.redirectUrl);
            } else {
              showSuccessToast(state.redirectUrl);
            }
          } else if (state is PanServiceError) {
            showErrorToast(state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is PanServiceLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Promo Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0.85),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.asset(
                                AppAssets.pan,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'NSDL PAN Services',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: AppTypography.outfitBold,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'New PAN Card & e-KYC',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: AppTypography.outfitRegular,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const Divider(color: Colors.white24, height: 1),
                        const SizedBox(height: 14),
                        _buildFeatureRow(
                          IconsaxPlusLinear.flash,
                          'Instant e-PAN digital issuance',
                        ),
                        const SizedBox(height: 8),
                        _buildFeatureRow(
                          IconsaxPlusLinear.shield_tick,
                          '100% paperless Aadhaar e-KYC verification',
                        ),
                        const SizedBox(height: 8),
                        _buildFeatureRow(
                          IconsaxPlusLinear.global,
                          'Official Protean / NSDL government integration',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Input Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Apply for PAN Card',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: AppTypography.outfitBold,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Enter your 10-digit mobile number to initiate your online application session with the NSDL portal.',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: AppTypography.outfitRegular,
                            color: AppColors.grey,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),

                        AppTextField(
                          controller: _mobileController,
                          label: 'Mobile Number',
                          hint: 'Enter 10-digit mobile number',
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          prefixIcon: IconsaxPlusLinear.mobile,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          onChanged: (_) {
                            if (_mobileError != null) {
                              setState(() => _mobileError = null);
                            }
                          },
                        ),
                        if (_mobileError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 6, left: 4),
                            child: Text(
                              _mobileError!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontFamily: AppTypography.outfitRegular,
                              ),
                            ),
                          ),

                        const SizedBox(height: 24),

                        AppButton(
                          label: 'Proceed to NSDL Portal',
                          onPressed: isLoading ? null : _onProceed,
                          isLoading: isLoading,
                          icon: IconsaxPlusLinear.export_1,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Disclaimer Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.border.withValues(alpha: 0.6),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          IconsaxPlusLinear.info_circle,
                          size: 18,
                          color: AppColors.grey,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "You will be redirected to Protean eGov (formerly NSDL) official portal to complete your Aadhaar e-Sign and document submission.",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: AppTypography.outfitRegular,
                              color: AppColors.text.withValues(alpha: 0.7),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (state is PanServiceSuccess &&
                      (state.redirectUrl.startsWith('http://') ||
                          state.redirectUrl.startsWith('https://'))) ...[
                    const SizedBox(height: 16),
                    AppButton(
                      label: 'Re-open NSDL Portal',
                      onPressed: () => _handleUrlLaunch(state.redirectUrl),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                      ),
                      icon: IconsaxPlusLinear.link_2,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: AppTypography.outfitMedium,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
