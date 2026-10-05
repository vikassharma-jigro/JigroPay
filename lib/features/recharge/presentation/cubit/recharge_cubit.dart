import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/services/payment_service.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../history/data/models/transaction_model.dart';
import '../../data/models/recharge_plan_model.dart';
import '../../domain/usecases/create_recharge_order_usecase.dart';
import '../../domain/usecases/get_operator_and_plans_usecase.dart';
import '../../domain/usecases/get_recent_recharges_usecase.dart';
import '../../domain/usecases/get_roffers_usecase.dart';
import '../../domain/usecases/verify_recharge_payment_usecase.dart';
import 'recharge_state.dart';

class RechargeCubit extends Cubit<RechargeState> {
  RechargeCubit({
    required GetOperatorAndPlansUseCase getOperatorAndPlansUseCase,
    required GetRoffersUseCase getRoffersUseCase,
    required CreateRechargeOrderUseCase createRechargeOrderUseCase,
    required VerifyRechargePaymentUseCase verifyRechargePaymentUseCase,
    required GetRecentRechargesUseCase getRecentRechargesUseCase,
    PaymentService? paymentService,
  }) : _getOperatorAndPlansUseCase = getOperatorAndPlansUseCase,
       _getRoffersUseCase = getRoffersUseCase,
       _createRechargeOrderUseCase = createRechargeOrderUseCase,
       _verifyRechargePaymentUseCase = verifyRechargePaymentUseCase,
       _getRecentRechargesUseCase = getRecentRechargesUseCase,
       _paymentService = paymentService ?? PaymentService(),
       super(const RechargeInitial());

  final GetOperatorAndPlansUseCase _getOperatorAndPlansUseCase;
  final GetRoffersUseCase _getRoffersUseCase;
  final CreateRechargeOrderUseCase _createRechargeOrderUseCase;
  final VerifyRechargePaymentUseCase _verifyRechargePaymentUseCase;
  final GetRecentRechargesUseCase _getRecentRechargesUseCase;
  final PaymentService _paymentService;

  /// Loads operator details and plans for [mobileNumber].
  Future<void> loadOperatorAndPlans({required String mobileNumber}) async {
    emit(const RechargeLoading('Fetching operator & plans...'));

    final result = await _getOperatorAndPlansUseCase(
      mobileNumber: mobileNumber,
    );
    switch (result) {
      case Success(:final data):
        final categorised = data.categorisedPlans;
        final initialCategory = categorised.categories.isNotEmpty
            ? categorised.categories.first
            : 'All Plans';
        final initialPlans = categorised.forCategory(initialCategory);

        emit(
          RechargeLoaded(
            operator: data.operator,
            categorisedPlans: categorised,
            selectedCategory: initialCategory,
            displayedPlans: initialPlans.isNotEmpty
                ? initialPlans
                : categorised.allPlans,
          ),
        );

        // Load R-Offers in background without blocking screen load
        _loadRoffers(mobileNumber: mobileNumber, opcode: data.operator.opcode);

      case Error(:final failure):
        emit(RechargeError(failure.message));
    }
  }

  /// Fetches recent recharge transactions.
  Future<Result<List<TransactionModel>>> fetchRecentRecharges() =>
      _getRecentRechargesUseCase();

  Future<void> _loadRoffers({
    required String mobileNumber,
    required String opcode,
  }) async {
    final result = await _getRoffersUseCase(
      mobileNumber: mobileNumber,
      opcode: opcode,
    );
    if (result is Success<List<RechargePlanModel>> && state is RechargeLoaded) {
      final current = state as RechargeLoaded;
      emit(current.copyWith(roffers: result.data));
    }
  }

  /// Switches the active plan category tab.
  void selectCategory(String category) {
    if (state is! RechargeLoaded) return;
    final current = state as RechargeLoaded;

    final plans = category == 'Special Offers'
        ? current.roffers
        : current.categorisedPlans.forCategory(category);

    emit(
      current.copyWith(
        selectedCategory: category,
        displayedPlans: _applySearch(plans, current.searchQuery),
      ),
    );
  }

  /// Filters plans in the active category by [query].
  void searchPlans(String query) {
    if (state is! RechargeLoaded) return;
    final current = state as RechargeLoaded;

    final basePlans = current.selectedCategory == 'Special Offers'
        ? current.roffers
        : current.categorisedPlans.forCategory(current.selectedCategory);

    final effectiveBase = basePlans.isNotEmpty
        ? basePlans
        : current.categorisedPlans.allPlans;

    emit(
      current.copyWith(
        searchQuery: query,
        displayedPlans: _applySearch(effectiveBase, query),
      ),
    );
  }

  List<RechargePlanModel> _applySearch(
    List<RechargePlanModel> plans,
    String query,
  ) {
    if (query.trim().isEmpty) return plans;
    final q = query.trim().toLowerCase();
    return plans.where((plan) {
      final amountMatch = plan.amount.toString().contains(q);
      final descMatch = plan.description.toLowerCase().contains(q);
      final validityMatch = (plan.validity ?? '').toLowerCase().contains(q);
      final dataMatch = (plan.data ?? '').toLowerCase().contains(q);
      return amountMatch || descMatch || validityMatch || dataMatch;
    }).toList();
  }

  /// Initiates order creation and Razorpay checkout for [plan].
  Future<void> initiatePayment({
    required RechargePlanModel plan,
    required String mobileNumber,
    required String opcode,
  }) async {
    final previousState = state;
    emit(const RechargePaymentProcessing('Creating order...'));

    final orderResult = await _createRechargeOrderUseCase(
      opcode: opcode,
      number: mobileNumber,
      amount: plan.amount,
    );

    switch (orderResult) {
      case Success(:final data):
        emit(const RechargePaymentProcessing('Opening secure checkout...'));
        final paymentResult = await _paymentService.openCheckout(
          amountInPaise: CurrencyFormatter.toPaise(data.amount),
          orderId: data.razorpayOrderId.isNotEmpty
              ? data.razorpayOrderId
              : data.orderId,
          apiKey: data.razorpayKey,
          contactNumber: mobileNumber,
          description: 'Recharge for ₹${plan.amount.toStringAsFixed(0)}',
        );

        switch (paymentResult) {
          case PaymentSuccess(
            :final paymentId,
            :final orderId,
            :final signature,
          ):
            emit(const RechargePaymentProcessing('Verifying payment...'));
            final verifyResult = await _verifyRechargePaymentUseCase(
              razorpayPaymentId: paymentId,
              razorpayOrderId: orderId,
              razorpaySignature: signature,
            );

            switch (verifyResult) {
              case Success(:final data):
                emit(
                  RechargePaymentSuccess(
                    verifyResult: data,
                    amount: plan.amount,
                    mobileNumber: mobileNumber,
                  ),
                );
              case Error(:final failure):
                emit(RechargeError(failure.message));
            }

          case PaymentFailure(:final message):
            emit(RechargeError(message));

          case PaymentDismissed():
            // User cancelled payment sheet — restore previous plans screen
            emit(previousState);
        }

      case Error(:final failure):
        emit(RechargeError(failure.message));
    }
  }

  void resetToLoaded(RechargeLoaded loadedState) {
    emit(loadedState);
  }
}
