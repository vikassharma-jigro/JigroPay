import '../../../../core/errors/result.dart';
import '../../data/models/transaction_model.dart';
import '../repositories/history_repository.dart';

class GetTransactionHistoryUseCase {
  const GetTransactionHistoryUseCase(this._repository);
  final HistoryRepository _repository;

  Future<Result<List<TransactionModel>>> call({String? type, String? status}) {
    return _repository.fetchTransactionHistory(type: type, status: status);
  }
}
