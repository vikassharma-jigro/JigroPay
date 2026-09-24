import 'package:equatable/equatable.dart';
import '../../data/models/transaction_model.dart';

sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

final class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

final class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

final class HistoryLoaded extends HistoryState {
  const HistoryLoaded({
    required this.allTransactions,
    required this.displayedTransactions,
    this.selectedFilter = 'All',
    this.searchQuery = '',
  });

  final List<TransactionModel> allTransactions;
  final List<TransactionModel> displayedTransactions;
  final String selectedFilter;
  final String searchQuery;

  HistoryLoaded copyWith({
    List<TransactionModel>? allTransactions,
    List<TransactionModel>? displayedTransactions,
    String? selectedFilter,
    String? searchQuery,
  }) {
    return HistoryLoaded(
      allTransactions: allTransactions ?? this.allTransactions,
      displayedTransactions:
          displayedTransactions ?? this.displayedTransactions,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        allTransactions,
        displayedTransactions,
        selectedFilter,
        searchQuery,
      ];
}

final class HistoryError extends HistoryState {
  const HistoryError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
