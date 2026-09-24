import 'package:equatable/equatable.dart';
import '../../data/models/operator_model.dart';
import '../../data/models/order_model.dart';
import '../../data/models/recharge_plan_model.dart';

sealed class RechargeState extends Equatable {
  const RechargeState();

  @override
  List<Object?> get props => [];
}

final class RechargeInitial extends RechargeState {
  const RechargeInitial();
}

final class RechargeLoading extends RechargeState {
  const RechargeLoading([this.message]);
  final String? message;

  @override
  List<Object?> get props => [message];
}

final class RechargeLoaded extends RechargeState {
  const RechargeLoaded({
    required this.operator,
    required this.categorisedPlans,
    required this.selectedCategory,
    required this.displayedPlans,
    this.roffers = const [],
    this.searchQuery = '',
  });

  final OperatorModel operator;
  final CategorisedPlans categorisedPlans;
  final String selectedCategory;
  final List<RechargePlanModel> displayedPlans;
  final List<RechargePlanModel> roffers;
  final String searchQuery;

  RechargeLoaded copyWith({
    OperatorModel? operator,
    CategorisedPlans? categorisedPlans,
    String? selectedCategory,
    List<RechargePlanModel>? displayedPlans,
    List<RechargePlanModel>? roffers,
    String? searchQuery,
  }) {
    return RechargeLoaded(
      operator: operator ?? this.operator,
      categorisedPlans: categorisedPlans ?? this.categorisedPlans,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      displayedPlans: displayedPlans ?? this.displayedPlans,
      roffers: roffers ?? this.roffers,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        operator,
        categorisedPlans,
        selectedCategory,
        displayedPlans,
        roffers,
        searchQuery,
      ];
}

final class RechargePaymentProcessing extends RechargeState {
  const RechargePaymentProcessing([this.message]);
  final String? message;

  @override
  List<Object?> get props => [message];
}

final class RechargePaymentSuccess extends RechargeState {
  const RechargePaymentSuccess({
    required this.verifyResult,
    required this.amount,
    required this.mobileNumber,
  });

  final PaymentVerifyModel verifyResult;
  final double amount;
  final String mobileNumber;

  @override
  List<Object?> get props => [verifyResult, amount, mobileNumber];
}

final class RechargeError extends RechargeState {
  const RechargeError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
