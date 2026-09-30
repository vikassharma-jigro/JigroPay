import '../../../../core/errors/result.dart';
import '../../data/models/transaction_model.dart';

abstract class HistoryRepository {
  /// Fetches transaction history with optional type filter and page.
  Future<Result<List<TransactionModel>>> fetchTransactionHistory({
    String? type,
    String? status,
    int? page,
  });
}
