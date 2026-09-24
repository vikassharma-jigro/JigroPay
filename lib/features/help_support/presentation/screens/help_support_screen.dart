import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/faq_model.dart';
import '../../data/repositories/help_support_repository_impl.dart';
import '../../domain/usecases/get_faqs_usecase.dart';
import '../../domain/usecases/submit_enquiry_usecase.dart';
import '../cubit/help_support_cubit.dart';
import '../cubit/help_support_state.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = HelpSupportRepositoryImpl();
    return BlocProvider(
      create: (context) => HelpSupportCubit(
        getFaqsUseCase: GetFaqsUseCase(repo),
        submitEnquiryUseCase: SubmitEnquiryUseCase(repo),
      )..loadFaqs(),
      child: const _HelpSupportView(),
    );
  }
}

class _HelpSupportView extends StatefulWidget {
  const _HelpSupportView();

  @override
  State<_HelpSupportView> createState() => _HelpSupportViewState();
}

class _HelpSupportViewState extends State<_HelpSupportView> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String _selectedCategory = 'Recharge & Bill Payment';

  final List<String> _categories = [
    'Recharge & Bill Payment',
    'Credit Card Bill Payment',
    'Transaction Refund Status',
    'Other Issues',
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _launchPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Fluttertoast.showToast(msg: 'Could not open phone dialer');
    }
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Fluttertoast.showToast(msg: 'Could not open email client');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Help & Support',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontFamily: AppTypography.outfitBold,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Quick Support Contact Cards
            _buildContactCards(),
            const SizedBox(height: 24),

            // 2. FAQ Accordion Section
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 16,
                fontFamily: AppTypography.outfitBold,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 12),
            _buildFaqSection(),
            const SizedBox(height: 24),

            // 3. Submit Support Enquiry Form
            const Text(
              'Send Us a Message',
              style: TextStyle(
                fontSize: 16,
                fontFamily: AppTypography.outfitBold,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 12),
            _buildTicketForm(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCards() {
    return BlocBuilder<HelpSupportCubit, HelpSupportState>(
      builder: (context, state) {
        String contact = '9216075703';
        String email = 'support@jigrotech.com';

        if (state is HelpSupportLoaded) {
          if (state.companyContact != null &&
              state.companyContact!.isNotEmpty) {
            contact = state.companyContact!;
          }
          if (state.companyEmail != null && state.companyEmail!.isNotEmpty) {
            email = state.companyEmail!;
          }
        }

        final phoneDialNumber = contact.replaceAll(RegExp(r'[^\d+]'), '');

        return Row(
          children: [
            Expanded(
              child: _buildContactTile(
                icon: Icons.call_outlined,
                title: 'Helpline',
                subtitle: contact,
                color: AppColors.primary,
                onTap: () => _launchPhone(
                  phoneDialNumber.isNotEmpty ? phoneDialNumber : contact,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildContactTile(
                icon: Icons.email_outlined,
                title: 'Email Us',
                subtitle: email,
                color: AppColors.secondary,
                onTap: () => _launchEmail(email),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: AppTypography.outfitBold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: AppTypography.outfitRegular,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqSection() {
    return BlocBuilder<HelpSupportCubit, HelpSupportState>(
      builder: (context, state) {
        if (state is HelpSupportLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }

        final List<FaqModel> faqs = state is HelpSupportLoaded
            ? state.faqs
            : _fallbackFaqs();

        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: faqs.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: AppColors.border),
            itemBuilder: (context, index) {
              final faq = faqs[index];
              return ExpansionTile(
                title: Text(
                  faq.question,
                  style: const TextStyle(
                    fontFamily: AppTypography.outfitMedium,
                    fontSize: 14,
                    color: AppColors.black,
                  ),
                ),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                children: [
                  Text(
                    faq.answer,
                    style: const TextStyle(
                      fontFamily: AppTypography.outfitRegular,
                      fontSize: 13,
                      color: AppColors.text,
                      height: 1.4,
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTicketForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category dropdown
          DropdownButtonFormField<String>(
            initialValue: _selectedCategory,
            decoration: InputDecoration(
              labelText: 'Issue Category',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
            items: _categories
                .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedCategory = val);
            },
          ),
          const SizedBox(height: 14),

          // Subject input
          AppTextField(
            controller: _subjectController,
            label: 'Subject',
            hint: 'Brief summary of issue',
          ),
          const SizedBox(height: 14),

          // Message input
          AppTextField(
            controller: _messageController,
            label: 'Message',
            hint: 'Describe your issue in detail...',
            maxLines: 4,
          ),
          const SizedBox(height: 16),

          // Submit button
          BlocBuilder<HelpSupportCubit, HelpSupportState>(
            builder: (context, state) {
              final isSubmitting =
                  state is HelpSupportLoaded && state.isSubmitting;
              return AppButton(
                label: 'Submit Enquiry',
                isLoading: isSubmitting,
                onPressed: isSubmitting
                    ? null
                    : () async {
                        final subject = _subjectController.text.trim();
                        final message = _messageController.text.trim();
                        if (subject.isEmpty || message.isEmpty) {
                          Fluttertoast.showToast(
                            msg: 'Please fill in all fields',
                          );
                          return;
                        }

                        final cubit = context.read<HelpSupportCubit>();
                        final success = await cubit.submitEnquiry(
                          subject: subject,
                          message: message,
                          category: _selectedCategory,
                        );

                        if (success) {
                          Fluttertoast.showToast(
                            msg: 'Enquiry submitted! We will respond shortly.',
                          );
                          _subjectController.clear();
                          _messageController.clear();
                        } else {
                          final currentState = cubit.state;
                          final errorMsg = currentState is HelpSupportLoaded
                              ? currentState.submitError
                              : null;
                          Fluttertoast.showToast(
                            msg:
                                errorMsg ??
                                'Failed to submit enquiry. Please try again.',
                          );
                        }
                      },
              );
            },
          ),
        ],
      ),
    );
  }

  List<FaqModel> _fallbackFaqs() => const [
    FaqModel(
      question: 'How do I check my transaction status?',
      answer:
          'You can view your complete payment and recharge history by visiting the "History" tab from the bottom navigation menu.',
    ),
    FaqModel(
      question: 'What if my money is deducted but recharge failed?',
      answer:
          'Do not worry! If money is deducted for a failed transaction, it will be automatically refunded to your payment method within 24-48 business hours.',
    ),
    FaqModel(
      question: 'Why is a PAN card required for payments ≥ ₹50,000?',
      answer:
          'As per regulatory guidelines in India, entering a valid 10-character PAN card number is mandatory for transactions of ₹50,000 or above.',
    ),
  ];
}
