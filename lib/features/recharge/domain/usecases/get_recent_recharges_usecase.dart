import '../../../../core/errors/result.dart';
import '../../../history/data/models/transaction_model.dart';
import '../repositories/recharge_repository.dart';

class GetRecentRechargesUseCase {
  const GetRecentRechargesUseCase(this._repository);
  final RechargeRepository _repository;

  Future<Result<List<TransactionModel>>> call() {
    return _repository.fetchRecentRecharges();
  }
}
