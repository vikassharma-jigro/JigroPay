import 'package:jigrotech/core/errors/result.dart';
import 'package:jigrotech/features/recharge/data/models/recharge_plan_model.dart';
import 'package:jigrotech/features/recharge/domain/repositories/recharge_repository.dart';

class GetDthPlansUseCase {
  const GetDthPlansUseCase(this._repository);
  final RechargeRepository _repository;

  Future<Result<CategorisedPlans>> call({
    required String dthNumber,
    required String opcode,
  }) {
    return _repository.fetchPlans(
      mobileNumber: dthNumber,
      opcode: opcode,
      circle: '',
      isDth: true,
    );
  }
}
