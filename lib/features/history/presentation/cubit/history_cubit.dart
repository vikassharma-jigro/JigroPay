import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/result.dart';
import '../../data/models/transaction_model.dart';
import '../../domain/usecases/get_transaction_history_usecase.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit({
    required GetTransactionHistoryUseCase getTransactionHistoryUseCase,
  })  : _getTransactionHistoryUseCase = getTransactionHistoryUseCase,
        super(const HistoryInitial());

  final GetTransactionHistoryUseCase _getTransactionHistoryUseCase;

  /// Loads transaction history on screen open.
  Future<void> loadHistory({String? type, String? status}) async {
    emit(const HistoryLoading());

    final result =
        await _getTransactionHistoryUseCase(type: type, status: status);

    switch (result) {
      case Success(:final data):
        emit(HistoryLoaded(
          allTransactions: data,
          displayedTransactions: data,
        ));
      case Error(:final failure):
        emit(HistoryError(failure.message));
    }
  }

  /// Filters transactions by category/status tab ('All', 'Success', 'Pending', 'Failed').
  void filterByStatus(String filter) {
    if (state is! HistoryLoaded) return;
    final current = state as HistoryLoaded;

    final filtered = _applyFilters(
      current.allTransactions,
      filter,
      current.searchQuery,
    );

    emit(current.copyWith(
      selectedFilter: filter,
      displayedTransactions: filtered,
    ));
  }

  /// Filters transactions by query (amount, operator, number, orderId).
  void search(String query) {
    if (state is! HistoryLoaded) return;
    final current = state as HistoryLoaded;

    final filtered = _applyFilters(
      current.allTransactions,
      current.selectedFilter,
      query,
    );

    emit(current.copyWith(
      searchQuery: query,
      displayedTransactions: filtered,
    ));
  }

  List<TransactionModel> _applyFilters(
    List<TransactionModel> list,
    String filter,
    String query,
  ) {
    var result = list;

    if (filter == 'Success') {
      result = result.where((t) => t.isSuccess).toList();
    } else if (filter == 'Pending') {
      result = result.where((t) => t.isPending).toList();
    } else if (filter == 'Failed') {
      result = result.where((t) => t.isFailed).toList();
    }

    if (query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      result = result.where((t) {
        final numMatch = (t.number ?? '').toLowerCase().contains(q);
        final opMatch = (t.operator ?? '').toLowerCase().contains(q);
        final ordMatch = (t.orderId ?? '').toLowerCase().contains(q);
        final refMatch = (t.refId ?? '').toLowerCase().contains(q);
        final amtMatch = t.amount.toString().contains(q);
        return numMatch || opMatch || ordMatch || refMatch || amtMatch;
      }).toList();
    }

    return result;
  }
}
