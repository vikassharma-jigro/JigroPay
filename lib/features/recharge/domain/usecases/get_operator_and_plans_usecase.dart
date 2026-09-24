import '../../../../core/errors/result.dart';
import '../../data/models/operator_model.dart';
import '../../data/models/recharge_plan_model.dart';
import '../repositories/recharge_repository.dart';

class OperatorAndPlans {
  const OperatorAndPlans({
    required this.operator,
    required this.categorisedPlans,
  });

  final OperatorModel operator;
  final CategorisedPlans categorisedPlans;
}

class GetOperatorAndPlansUseCase {
  const GetOperatorAndPlansUseCase(this._repository);
  final RechargeRepository _repository;

  Future<Result<OperatorAndPlans>> call({
    required String mobileNumber,
  }) async {
    // 1. Fetch Operator
    final operatorResult = await _repository.fetchOperator(mobileNumber: mobileNumber);
    if (operatorResult is Error<OperatorModel>) {
      return Error(operatorResult.failure);
    }

    final op = (operatorResult as Success<OperatorModel>).data;
    final opcode = op.opcode.isNotEmpty ? op.opcode : 'A';
    final circle = op.circleCode ?? op.circle ?? 'DL';

    // 2. Fetch Plans
    final plansResult = await _repository.fetchPlans(
      mobileNumber: mobileNumber,
      opcode: opcode,
      circle: circle,
    );

    if (plansResult is Error<CategorisedPlans>) {
      // Even if plans fail, return operator with empty plans
      return Success(OperatorAndPlans(
        operator: op,
        categorisedPlans: const CategorisedPlans({}),
      ));
    }

    final plans = (plansResult as Success<CategorisedPlans>).data;
    return Success(OperatorAndPlans(
      operator: op,
      categorisedPlans: plans,
    ));
  }
}
