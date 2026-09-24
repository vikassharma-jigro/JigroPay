import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/services/payment_service.dart';
import '../../../../core/utils/currency_formatter.dart';
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
    PaymentService? paymentService,
  })  : _fetchBillersUseCase = fetchBillersUseCase,
        _fetchBillDetailsUseCase = fetchBillDetailsUseCase,
        _payBillUseCase = payBillUseCase,
        _paymentService = paymentService ?? PaymentService(),
        super(const BillPaymentInitial());

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
        emit(BillersLoaded(
          billers: data,
          displayedBillers: data,
        ));
      case Error(:final failure):
        emit(BillPaymentError(failure.message));
    }
  }

  /// Filters billers in search.
  void searchBillers(String query) {
    if (state is! BillersLoaded) return;
    final current = state as BillersLoaded;

    if (query.trim().isEmpty) {
      emit(current.copyWith(
        searchQuery: '',
        displayedBillers: current.billers,
      ));
      return;
    }

    final q = query.trim().toLowerCase();
    final filtered = current.billers.where((b) {
      final nameMatch = b.name.toLowerCase().contains(q);
      final stateMatch = (b.state ?? '').toLowerCase().contains(q);
      return nameMatch || stateMatch;
    }).toList();

    emit(current.copyWith(
      searchQuery: query,
      displayedBillers: filtered,
    ));
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
        emit(BillFetched(
          billDetails: data,
          selectedBiller: biller,
          consumerNumber: consumerNumber,
        ));
      case Error(:final failure):
        emit(BillPaymentError(failure.message));
    }
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
      serviceType: serviceType,
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
          case PaymentSuccess(:final paymentId, :final orderId, :final signature):
            emit(const BillPaymentProcessing('Verifying bill payment...'));
            final verifyResult = await _payBillUseCase.verifyPayment(
              paymentId: paymentId,
              orderId: orderId,
              signature: signature,
              serviceType: serviceType,
            );

            switch (verifyResult) {
              case Success(:final data):
                emit(BillPaymentSuccess(
                  verifyResult: data,
                  amount: billDetails.amount,
                  consumerName: billDetails.consumerName,
                ));
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
