import '../../../../core/errors/result.dart';
import '../../data/models/biller_model.dart';
import '../repositories/bill_payment_repository.dart';

class FetchBillersUseCase {
  const FetchBillersUseCase(this._repository);
  final BillPaymentRepository _repository;

  Future<Result<List<BillerModel>>> call({required String serviceType}) {
    return _repository.fetchBillersByType(serviceType: serviceType);
  }
}
