import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jigrotech/core/constants/app_endpoints.dart';
import 'package:jigrotech/core/mixins/ui_feedback_mixin.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../data/models/biller_model.dart';
import '../../data/repositories/bill_payment_repository_impl.dart';
import '../../domain/usecases/fetch_bill_details_usecase.dart';
import '../../domain/usecases/fetch_billers_usecase.dart';
import '../../domain/usecases/pay_bill_usecase.dart';
import '../../../recharge/presentation/screens/payment_success_screen.dart';
import '../cubit/bill_payment_cubit.dart';
import '../cubit/bill_payment_state.dart';

class GenericBillPaymentScreen extends StatelessWidget {
  const GenericBillPaymentScreen({
    super.key,
    required this.serviceType,
    required this.title,
    this.accountNumberLabel = 'Consumer Number',
    this.accountNumberHint = 'Enter consumer / account number',
  });

  final String serviceType;
  final String title;
  final String accountNumberLabel;
  final String accountNumberHint;

  @override
  Widget build(BuildContext context) {
    final repo = BillPaymentRepositoryImpl();
    return BlocProvider(
      create: (context) => BillPaymentCubit(
        fetchBillersUseCase: FetchBillersUseCase(repo),
        fetchBillDetailsUseCase: FetchBillDetailsUseCase(repo),
        payBillUseCase: PayBillUseCase(repo),
      )..loadBillers(serviceType: serviceType),
      child: _GenericBillPaymentView(
        serviceType: serviceType,
        title: title,
        accountNumberLabel: accountNumberLabel,
        accountNumberHint: accountNumberHint,
      ),
    );
  }
}

class _GenericBillPaymentView extends StatefulWidget {
  const _GenericBillPaymentView({
    required this.serviceType,
    required this.title,
    required this.accountNumberLabel,
    required this.accountNumberHint,
  });

  final String serviceType;
  final String title;
  final String accountNumberLabel;
  final String accountNumberHint;

  @override
  State<_GenericBillPaymentView> createState() =>
      _GenericBillPaymentViewState();
}

class _GenericBillPaymentViewState extends State<_GenericBillPaymentView>
    with UiFeedbackMixin {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _consumerNumberController =
      TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  BillerModel? _selectedBiller;

  @override
  void dispose() {
    _searchController.dispose();
    _consumerNumberController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BillPaymentCubit, BillPaymentState>(
      listener: (context, state) {
        if (state is BillPaymentSuccess) {
          context.go(
            '/payment-success',
            extra: PaymentSuccessArgs(
              serviceName: widget.title,
              providerName: _selectedBiller?.name ?? widget.title,
              consumerNumber: _consumerNumberController.text.trim(),
              amount: state.amount.toStringAsFixed(2),
              transactionId: state.verifyResult.transactionId ?? '',
              orderId:
                  state.verifyResult.refId ?? state.verifyResult.rechargeId,
              paidVia: 'Razorpay',
            ),
          );
        } else if (state is BillPaymentError) {
          showErrorToast(state.message);
        }
      },
      builder: (context, state) {
        final isProcessing = state is BillPaymentProcessing;

        return LoadingOverlay(
          isLoading: isProcessing,
          message: state is BillPaymentProcessing ? state.message : null,
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
                onPressed: () {
                  if (state is BillFetched) {
                    context.read<BillPaymentCubit>().loadBillers(
                      serviceType: widget.serviceType,
                    );
                  } else if (_selectedBiller != null) {
                    setState(() => _selectedBiller = null);
                  } else {
                    context.pop();
                  }
                },
              ),
              title: Text(
                widget.title,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 18,
                  fontFamily: AppTypography.outfitBold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: _buildBody(context, state),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, BillPaymentState state) {
    if (state is BillPaymentLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator.adaptive(),
            const SizedBox(height: 16),
            Text(
              state.message ?? 'Loading...',
              style: const TextStyle(
                fontFamily: AppTypography.outfitMedium,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      );
    }

    if (state is BillFetched) {
      return _buildBillDetailsCard(context, state);
    }

    if (_selectedBiller != null) {
      return _buildConsumerInputForm(context, _selectedBiller!);
    }

    if (state is BillersLoaded) {
      return _buildBillersList(context, state);
    }

    if (state is BillPaymentError) {
      return Center(
        child: EmptyStateWidget(
          icon: Icons.error_outline,
          title: 'Unable to Load Biller',
          subtitle: state.message,
          actionLabel: 'Retry',
          onAction: () {
            context.read<BillPaymentCubit>().loadBillers(
              serviceType: widget.serviceType,
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }

  // ── Step 1: Biller list selection ──────────────────────────────────────────

  Widget _buildBillersList(BuildContext context, BillersLoaded state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: TextField(
            controller: _searchController,
            onChanged: (q) => context.read<BillPaymentCubit>().searchBillers(q),
            decoration: InputDecoration(
              hintText: 'Search ${widget.title} operator...',
              hintStyle: const TextStyle(
                fontFamily: AppTypography.outfitRegular,
                fontSize: 13,
                color: AppColors.grey,
              ),
              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        context.read<BillPaymentCubit>().searchBillers('');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              filled: true,
              fillColor: AppColors.light,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
            ),
          ),
        ),
        Expanded(
          child: state.displayedBillers.isEmpty
              ? const EmptyStateWidget(
                  icon: Icons.search_off,
                  title: 'No Operators Found',
                  subtitle: 'Try searching with another operator name.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  itemCount: state.displayedBillers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final biller = state.displayedBillers[index];

                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedBiller = biller);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.light,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: ClipOval(
                                child:
                                    biller.imageUrl != null &&
                                        biller.imageUrl!.isNotEmpty
                                    ? Image.network(
                                        "${AppEndpoints.getHost()}${biller.imageUrl!.trim()}",
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) {
                                          return Center(
                                            child: Text(
                                              biller.opcode
                                                  .substring(0, 2)
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                fontFamily:
                                                    AppTypography.outfitBold,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.black,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Center(
                                        child: Text(
                                          biller.opcode
                                              .substring(0, 2)
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            fontFamily:
                                                AppTypography.outfitBold,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    biller.name,
                                    style: const TextStyle(
                                      fontFamily: AppTypography.outfitBold,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  if (biller.state != null &&
                                      biller.state!.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      biller.state!,
                                      style: const TextStyle(
                                        fontFamily: AppTypography.outfitRegular,
                                        fontSize: 12,
                                        color: AppColors.grey,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: AppColors.grey,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ── Step 2: Consumer number input ──────────────────────────────────────────

  Widget _buildConsumerInputForm(BuildContext context, BillerModel biller) {
    final isCreditCard = widget.serviceType.toLowerCase() == 'credit_card';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected Biller Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.light,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(Icons.business, color: AppColors.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    biller.name,
                    style: const TextStyle(
                      fontFamily: AppTypography.outfitBold,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppColors.black,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _selectedBiller = null),
                  child: const Text(
                    'Change',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text(
            widget.accountNumberLabel,
            style: const TextStyle(
              fontFamily: AppTypography.outfitBold,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          AppTextField(
            controller: _consumerNumberController,
            hint: widget.accountNumberHint,
            keyboardType: isCreditCard
                ? TextInputType.number
                : TextInputType.text,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          ),

          if (isCreditCard) ...[
            const SizedBox(height: 16),
            const Text(
              'Registered Mobile Number',
              style: TextStyle(
                fontFamily: AppTypography.outfitBold,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            AppTextField(
              controller: _mobileController,
              hint: 'Enter 10-digit registered mobile',
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
            ),
          ],

          const SizedBox(height: 32),
          AppButton(
            label: 'Fetch Bill',
            onPressed: () {
              FocusScope.of(context).unfocus();
              final consumerNo = _consumerNumberController.text.trim();
              if (consumerNo.isEmpty) {
                showErrorToast('Please enter ${widget.accountNumberLabel}');
                return;
              }

              context.read<BillPaymentCubit>().fetchBill(
                serviceType: widget.serviceType,
                biller: biller,
                consumerNumber: consumerNo,
                extraFields: isCreditCard
                    ? {'mobile': _mobileController.text.trim()}
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Step 3: Bill details card & Proceed to Pay ──────────────────────────────

  Widget _buildBillDetailsCard(BuildContext context, BillFetched state) {
    final bill = state.billDetails;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bill Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.selectedBiller.name,
                      style: const TextStyle(
                        fontFamily: AppTypography.outfitBold,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    const Icon(
                      Icons.verified,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),

                _buildDetailRow('Consumer Name', bill.consumerName),
                const SizedBox(height: 10),
                _buildDetailRow(
                  widget.accountNumberLabel,
                  bill.consumerNumber ?? state.consumerNumber,
                ),
                if (bill.billNumber != null) ...[
                  const SizedBox(height: 10),
                  _buildDetailRow('Bill Number', bill.billNumber!),
                ],
                if (bill.dueDate != null) ...[
                  const SizedBox(height: 10),
                  _buildDetailRow(
                    'Due Date',
                    DateFormatter.toDayMonthYear(bill.dueDate!),
                  ),
                ],
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),

                // Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Amount Due',
                      style: TextStyle(
                        fontFamily: AppTypography.outfitBold,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.toINR(bill.amount),
                      style: const TextStyle(
                        fontFamily: AppTypography.outfitBold,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          AppButton(
            label: 'Pay ${CurrencyFormatter.toINR(bill.amount)}',
            onPressed: () {
              context.read<BillPaymentCubit>().payBill(
                biller: state.selectedBiller,
                billDetails: bill,
                consumerNumber: state.consumerNumber,
                serviceType: widget.serviceType,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppTypography.outfitRegular,
            fontSize: 13,
            color: AppColors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: AppTypography.outfitMedium,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
