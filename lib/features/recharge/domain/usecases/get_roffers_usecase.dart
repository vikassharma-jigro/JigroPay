import '../../../../core/errors/result.dart';
import '../../data/models/recharge_plan_model.dart';
import '../repositories/recharge_repository.dart';

class GetRoffersUseCase {
  const GetRoffersUseCase(this._repository);
  final RechargeRepository _repository;

  Future<Result<List<RechargePlanModel>>> call({
    required String mobileNumber,
    required String opcode,
  }) {
    return _repository.fetchRoffers(
      mobileNumber: mobileNumber,
      opcode: opcode,
    );
  }
}
