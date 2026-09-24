import '../../../../core/errors/result.dart';
import '../../data/models/order_model.dart';
import '../repositories/recharge_repository.dart';

class CreateRechargeOrderUseCase {
  const CreateRechargeOrderUseCase(this._repository);
  final RechargeRepository _repository;

  Future<Result<OrderModel>> call({
    required String opcode,
    required String number,
    required double amount,
    String? type,
    String? fetchId,
  }) {
    return _repository.createOrder(
      opcode: opcode,
      number: number,
      amount: amount,
      type: type,
      fetchId: fetchId,
    );
  }
}
