import 'package:equatable/equatable.dart';
import '../../../history/data/models/transaction_model.dart';

sealed class RecentRechargesState extends Equatable {
  const RecentRechargesState();

  @override
  List<Object?> get props => [];
}

final class RecentRechargesInitial extends RecentRechargesState {
  const RecentRechargesInitial();
}

final class RecentRechargesLoading extends RecentRechargesState {
  const RecentRechargesLoading();
}

final class RecentRechargesLoaded extends RecentRechargesState {
  const RecentRechargesLoaded(this.recharges);
  final List<TransactionModel> recharges;

  @override
  List<Object?> get props => [recharges];
}

final class RecentRechargesError extends RecentRechargesState {
  const RecentRechargesError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
