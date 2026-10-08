import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/services/payment_service.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../recharge/data/models/recharge_plan_model.dart';
import '../../../recharge/data/repositories/recharge_repository_impl.dart';
import '../../../recharge/domain/usecases/get_dth_plans_usecase.dart';
import '../../data/models/bill_details_model.dart';
import '../../data/models/biller_model.dart';
import '../../domain/usecases/fetch_bill_details_usecase.dart';
import '../../domain/usecases/fetch_billers_usecase.dart';
import '../../domain/usecases/pay_bill_usecase.dart';
import 'bill_payment_state.dart';

class BillPaymentCubit extends Cubit<BillPaymentState> {
  BillPaymentCubit({
    required FetchBillersUseCase fetchBillersUseCase,
    required FetchBillDetailsUseCase fetchBillDetailsUseCase,
    required PayBillUseCase payBillUseCase,
    GetDthPlansUseCase? getDthPlansUseCase,
    PaymentService? paymentService,
  }) : _fetchBillersUseCase = fetchBillersUseCase,
       _fetchBillDetailsUseCase = fetchBillDetailsUseCase,
       _payBillUseCase = payBillUseCase,
       _paymentService = paymentService ?? PaymentService(),
       _getDthPlansUseCase =
           getDthPlansUseCase ?? GetDthPlansUseCase(RechargeRepositoryImpl()),
       super(const BillPaymentInitial());

  final GetDthPlansUseCase _getDthPlansUseCase;
  final FetchBillersUseCase _fetchBillersUseCase;
  final FetchBillDetailsUseCase _fetchBillDetailsUseCase;
  final PayBillUseCase _payBillUseCase;
  final PaymentService _paymentService;

  /// Loads list of operators/billers for [serviceType].
  Future<void> loadBillers({required String serviceType}) async {
    emit(const BillPaymentLoading('Loading operators...'));

    final result = await _fetchBillersUseCase(serviceType: serviceType);
    switch (result) {
      case Success(:final data):
        emit(BillersLoaded(billers: data, displayedBillers: data));
      case Error(:final failure):
        emit(BillPaymentError(failure.message));
    }
  }

  /// Filters billers in search.
  void searchBillers(String query) {
    if (state is! BillersLoaded) return;
    final current = state as BillersLoaded;

    if (query.trim().isEmpty) {
      emit(
        current.copyWith(searchQuery: '', displayedBillers: current.billers),
      );
      return;
    }

    final q = query.trim().toLowerCase();
    final filtered = current.billers.where((b) {
      final nameMatch = b.name.toLowerCase().contains(q);
      final stateMatch = (b.state ?? '').toLowerCase().contains(q);
      return nameMatch || stateMatch;
    }).toList();

    emit(current.copyWith(searchQuery: query, displayedBillers: filtered));
  }

  /// Fetches bill details for a given consumer ID before payment.
  Future<void> fetchBill({
    required String serviceType,
    required BillerModel biller,
    required String consumerNumber,
    Map<String, dynamic>? extraFields,
  }) async {
    emit(const BillPaymentLoading('Fetching bill details from operator...'));

    final result = await _fetchBillDetailsUseCase(
      serviceType: serviceType,
      billerCode: biller.opcode,
      consumerNumber: consumerNumber,
      extraFields: extraFields,
    );

    switch (result) {
      case Success(:final data):
        emit(
          BillFetched(
            billDetails: data,
            selectedBiller: biller,
            consumerNumber: consumerNumber,
          ),
        );
      case Error(:final failure):
        emit(BillPaymentError(failure.message));
    }
  }

  Future<void> fetchPlans({
    required BillerModel biller,
    required String consumerNumber,
  }) async {
    emit(const BillPaymentLoading('Fetching DTH plans...'));

    final result = await _getDthPlansUseCase(
      dthNumber: consumerNumber,
      opcode: biller.opcode,
    );

    switch (result) {
      case Success(:final data):
        final initialCategory = data.categories.isNotEmpty
            ? data.categories.first
            : 'All Plans';
        final initialPlans = data.forCategory(initialCategory);

        emit(
          DthPlanFetched(
            plans: data,
            selectedBiller: biller,
            consumerNumber: consumerNumber,
            selectedCategory: initialCategory,
            displayedPlans: initialPlans.isNotEmpty
                ? initialPlans
                : data.allPlans,
          ),
        );
      case Error(:final failure):
        emit(BillPaymentError(failure.message));
    }
  }

  void selectDthPlanCategory(String category) {
    if (state is! DthPlanFetched) return;
    final current = state as DthPlanFetched;
    final plans = current.plans.forCategory(category);
    final effective = plans.isNotEmpty ? plans : current.plans.allPlans;

    emit(
      current.copyWith(
        selectedCategory: category,
        displayedPlans: _filterDthPlans(effective, current.searchQuery),
      ),
    );
  }

  void searchDthPlans(String query) {
    if (state is! DthPlanFetched) return;
    final current = state as DthPlanFetched;
    final basePlans = current.plans.forCategory(current.selectedCategory);
    final effective = basePlans.isNotEmpty ? basePlans : current.plans.allPlans;

    emit(
      current.copyWith(
        searchQuery: query,
        displayedPlans: _filterDthPlans(effective, query),
      ),
    );
  }

  List<RechargePlanModel> _filterDthPlans(
    List<RechargePlanModel> plans,
    String query,
  ) {
    if (query.trim().isEmpty) return plans;
    final q = query.trim().toLowerCase();
    return plans.where((plan) {
      final amountMatch = plan.amount.toString().contains(q);
      final descMatch = plan.description.toLowerCase().contains(q);
      final validityMatch = (plan.validity ?? '').toLowerCase().contains(q);
      return amountMatch || descMatch || validityMatch;
    }).toList();
  }

  /// Selects a plan from DTH list and transitions to BillFetched for confirmation & payment
  void selectPlan(RechargePlanModel plan) {
    if (state is! DthPlanFetched) return;
    final current = state as DthPlanFetched;

    emit(
      BillFetched(
        billDetails: BillDetailsModel(
          fetchId: DateTime.now().millisecondsSinceEpoch.toString(),
          consumerName: current.selectedBiller.name,
          amount: plan.amount,
          consumerNumber: current.consumerNumber,
          billerName: current.selectedBiller.name,
        ),
        selectedBiller: current.selectedBiller,
        consumerNumber: current.consumerNumber,
      ),
    );
  }

  /// Initiates payment for a fetched bill.
  Future<void> payBill({
    required BillerModel biller,
    required BillDetailsModel billDetails,
    required String consumerNumber,
    String? serviceType,
  }) async {
    final previousState = state;
    emit(const BillPaymentProcessing('Creating bill payment order...'));

    final orderResult = await _payBillUseCase.createOrder(
      opcode: biller.opcode,
      consumerNumber: consumerNumber,
      amount: billDetails.amount,
      fetchId: billDetails.fetchId,
      serviceType: serviceType?.toLowerCase() == 'dth'
          ? 'recharge'
          : serviceType,
    );

    switch (orderResult) {
      case Success(:final data):
        emit(const BillPaymentProcessing('Opening secure checkout...'));
        final paymentResult = await _paymentService.openCheckout(
          amountInPaise: CurrencyFormatter.toPaise(data.amount),
          orderId: data.razorpayOrderId.isNotEmpty
              ? data.razorpayOrderId
              : data.orderId,
          apiKey: data.razorpayKey,
          contactNumber: consumerNumber,
          description: '${biller.name} Bill Payment',
        );

        switch (paymentResult) {
          case PaymentSuccess(
            :final paymentId,
            :final orderId,
            :final signature,
          ):
            emit(const BillPaymentProcessing('Verifying bill payment...'));
            final verifyResult = await _payBillUseCase.verifyPayment(
              paymentId: paymentId,
              orderId: orderId,
              signature: signature,
              serviceType: serviceType,
            );

            switch (verifyResult) {
              case Success(:final data):
                emit(
                  BillPaymentSuccess(
                    verifyResult: data,
                    amount: billDetails.amount,
                    consumerName: billDetails.consumerName,
                  ),
                );
              case Error(:final failure):
                emit(BillPaymentError(failure.message));
            }

          case PaymentFailure(:final message):
            emit(BillPaymentError(message));

          case PaymentDismissed():
            emit(previousState);
        }

      case Error(:final failure):
        emit(BillPaymentError(failure.message));
    }
  }

  void resetToLoaded(BillersLoaded loadedState) {
    emit(loadedState);
  }
}
