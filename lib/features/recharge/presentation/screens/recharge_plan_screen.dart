import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jigrotech/core/mixins/ui_feedback_mixin.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../data/models/recharge_plan_model.dart';
import '../../data/repositories/recharge_repository_impl.dart';
import '../../domain/usecases/create_recharge_order_usecase.dart';
import '../../domain/usecases/get_operator_and_plans_usecase.dart';
import '../../domain/usecases/get_recent_recharges_usecase.dart';
import '../../domain/usecases/get_roffers_usecase.dart';
import '../../domain/usecases/verify_recharge_payment_usecase.dart';
import '../cubit/recharge_cubit.dart';
import '../cubit/recharge_state.dart';
import '../widgets/operator_header_widget.dart';
import '../widgets/plan_card_widget.dart';
import '../widgets/plan_category_tabs_widget.dart';
import '../widgets/plan_details_bottom_sheet.dart';
import '../widgets/roffer_banner_widget.dart';
import 'payment_success_screen.dart';

class RechargePlanScreen extends StatelessWidget {
  const RechargePlanScreen({
    super.key,
    required this.mobileNumber,
    this.contactName,
  });

  final String mobileNumber;
  final String? contactName;

  @override
  Widget build(BuildContext context) {
    final repo = RechargeRepositoryImpl();
    return BlocProvider(
      create: (context) => RechargeCubit(
        getOperatorAndPlansUseCase: GetOperatorAndPlansUseCase(repo),
        getRoffersUseCase: GetRoffersUseCase(repo),
        createRechargeOrderUseCase: CreateRechargeOrderUseCase(repo),
        verifyRechargePaymentUseCase: VerifyRechargePaymentUseCase(repo),
        getRecentRechargesUseCase: GetRecentRechargesUseCase(repo),
      )..loadOperatorAndPlans(mobileNumber: mobileNumber),
      child: _RechargePlanView(
        mobileNumber: mobileNumber,
        contactName: contactName,
      ),
    );
  }
}

class _RechargePlanView extends StatefulWidget {
  const _RechargePlanView({required this.mobileNumber, this.contactName});

  final String mobileNumber;
  final String? contactName;

  @override
  State<_RechargePlanView> createState() => _RechargePlanViewState();
}

class _RechargePlanViewState extends State<_RechargePlanView>
    with UiFeedbackMixin {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RechargeCubit, RechargeState>(
      listener: (context, state) {
        if (state is RechargePaymentSuccess) {
          context.go(
            '/payment-success',
            extra: PaymentSuccessArgs(
              serviceName: 'Mobile Recharge',
              providerName: widget.contactName ?? 'Mobile Recharge',
              consumerNumber: state.mobileNumber,
              amount: state.amount.toStringAsFixed(0),
              transactionId: state.verifyResult.transactionId ?? '',
              orderId:
                  state.verifyResult.refId ?? state.verifyResult.rechargeId,
              paidVia: 'Razorpay',
            ),
          );
        } else if (state is RechargeError) {
          showErrorToast(state.message);
        }
      },
      builder: (context, state) {
        final isProcessingPayment = state is RechargePaymentProcessing;

        return LoadingOverlay(
          isLoading: isProcessingPayment,
          message: state is RechargePaymentProcessing ? state.message : null,
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
                onPressed: () => context.pop(),
              ),
              title: const Text(
                'Select a Recharge Plan',
                style: TextStyle(
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

  Widget _buildBody(BuildContext context, RechargeState state) {
    if (state is RechargeLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator.adaptive(),
            const SizedBox(height: 16),
            Text(
              state.message ?? 'Loading plans...',
              style: const TextStyle(
                fontFamily: AppTypography.outfitMedium,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      );
    }

    if (state is RechargeError && state is! RechargeLoaded) {
      return Center(
        child: EmptyStateWidget(
          icon: Icons.error_outline,
          title: 'Unable to Load Plans',
          subtitle: state.message,
          actionLabel: 'Retry',
          onAction: () {
            context.read<RechargeCubit>().loadOperatorAndPlans(
              mobileNumber: widget.mobileNumber,
            );
          },
        ),
      );
    }

    if (state is RechargeLoaded) {
      final categories = [
        if (state.roffers.isNotEmpty) 'Special Offers',
        ...state.categorisedPlans.categories,
      ];

      return Column(
        children: [
          // 1. Operator Header
          OperatorHeaderWidget(
            mobileNumber: widget.mobileNumber,
            operator: state.operator,
            contactName: widget.contactName,
          ),

          // 2. Search Field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                context.read<RechargeCubit>().searchPlans(query);
              },
              decoration: InputDecoration(
                hintText: 'Search plan amount, data, or validity...',
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
                          context.read<RechargeCubit>().searchPlans('');
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

          // 3. R-Offers Banner
          if (state.roffers.isNotEmpty &&
              state.selectedCategory != 'Special Offers')
            RofferBannerWidget(
              offerCount: state.roffers.length,
              onTap: () {
                context.read<RechargeCubit>().selectCategory('Special Offers');
              },
            ),

          // 4. Category Tabs
          PlanCategoryTabsWidget(
            categories: categories,
            selectedCategory: state.selectedCategory,
            onSelectCategory: (cat) {
              context.read<RechargeCubit>().selectCategory(cat);
            },
          ),

          const SizedBox(height: 8),

          // 5. Plans List
          Expanded(
            child: state.displayedPlans.isEmpty
                ? const EmptyStateWidget(
                    icon: Icons.search_off,
                    title: 'No Plans Found',
                    subtitle:
                        'Try searching with another amount or switch category.',
                  )
                : ListView.builder(
                    itemCount: state.displayedPlans.length,
                    itemBuilder: (context, index) {
                      final plan = state.displayedPlans[index];
                      return PlanCardWidget(
                        plan: plan,
                        onTap: () => _openPlanDetails(context, plan, state),
                      );
                    },
                  ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  void _openPlanDetails(
    BuildContext context,
    RechargePlanModel plan,
    RechargeLoaded loadedState,
  ) {
    PlanDetailsBottomSheet.show(
      context: context,
      plan: plan,
      onProceedToPay: () {
        context.read<RechargeCubit>().initiatePayment(
          plan: plan,
          mobileNumber: widget.mobileNumber,
          opcode: loadedState.operator.opcode,
        );
      },
    );
  }
}
