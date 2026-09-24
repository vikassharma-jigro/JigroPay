import 'package:equatable/equatable.dart';
import '../../../recharge/data/models/order_model.dart';
import '../../data/models/bill_details_model.dart';
import '../../data/models/biller_model.dart';

sealed class BillPaymentState extends Equatable {
  const BillPaymentState();

  @override
  List<Object?> get props => [];
}

final class BillPaymentInitial extends BillPaymentState {
  const BillPaymentInitial();
}

final class BillPaymentLoading extends BillPaymentState {
  const BillPaymentLoading([this.message]);
  final String? message;

  @override
  List<Object?> get props => [message];
}

final class BillersLoaded extends BillPaymentState {
  const BillersLoaded({
    required this.billers,
    required this.displayedBillers,
    this.searchQuery = '',
  });

  final List<BillerModel> billers;
  final List<BillerModel> displayedBillers;
  final String searchQuery;

  BillersLoaded copyWith({
    List<BillerModel>? billers,
    List<BillerModel>? displayedBillers,
    String? searchQuery,
  }) {
    return BillersLoaded(
      billers: billers ?? this.billers,
      displayedBillers: displayedBillers ?? this.displayedBillers,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [billers, displayedBillers, searchQuery];
}

final class BillFetched extends BillPaymentState {
  const BillFetched({
    required this.billDetails,
    required this.selectedBiller,
    required this.consumerNumber,
  });

  final BillDetailsModel billDetails;
  final BillerModel selectedBiller;
  final String consumerNumber;

  @override
  List<Object?> get props => [billDetails, selectedBiller, consumerNumber];
}

final class BillPaymentProcessing extends BillPaymentState {
  const BillPaymentProcessing([this.message]);
  final String? message;

  @override
  List<Object?> get props => [message];
}

final class BillPaymentSuccess extends BillPaymentState {
  const BillPaymentSuccess({
    required this.verifyResult,
    required this.amount,
    required this.consumerName,
  });

  final PaymentVerifyModel verifyResult;
  final double amount;
  final String consumerName;

  @override
  List<Object?> get props => [verifyResult, amount, consumerName];
}

final class BillPaymentError extends BillPaymentState {
  const BillPaymentError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
