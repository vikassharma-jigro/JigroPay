import '../../../../core/errors/result.dart';
import '../../data/models/bill_details_model.dart';
import '../repositories/bill_payment_repository.dart';

class FetchBillDetailsUseCase {
  const FetchBillDetailsUseCase(this._repository);
  final BillPaymentRepository _repository;

  Future<Result<BillDetailsModel>> call({
    required String serviceType,
    required String billerCode,
    required String consumerNumber,
    Map<String, dynamic>? extraFields,
  }) {
    return _repository.fetchBillDetails(
      serviceType: serviceType,
      billerCode: billerCode,
      consumerNumber: consumerNumber,
      extraFields: extraFields,
    );
  }
}
