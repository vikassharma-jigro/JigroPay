import 'package:flutter_test/flutter_test.dart';
import 'package:jigrotech/core/errors/failures.dart';
import 'package:jigrotech/core/errors/result.dart';
import 'package:jigrotech/features/history/data/models/transaction_model.dart';
import 'package:jigrotech/features/recharge/data/models/operator_model.dart';
import 'package:jigrotech/features/recharge/data/models/order_model.dart';
import 'package:jigrotech/features/recharge/data/models/recharge_plan_model.dart';
import 'package:jigrotech/features/recharge/domain/repositories/recharge_repository.dart';
import 'package:jigrotech/features/recharge/domain/usecases/create_recharge_order_usecase.dart';
import 'package:jigrotech/features/recharge/domain/usecases/get_operator_and_plans_usecase.dart';
import 'package:jigrotech/features/recharge/domain/usecases/get_recent_recharges_usecase.dart';
import 'package:jigrotech/features/recharge/domain/usecases/get_roffers_usecase.dart';
import 'package:jigrotech/features/recharge/domain/usecases/verify_recharge_payment_usecase.dart';
import 'package:jigrotech/features/recharge/presentation/cubit/recharge_cubit.dart';
import 'package:jigrotech/features/recharge/presentation/cubit/recharge_state.dart';

class FakeRechargeRepository implements RechargeRepository {
  bool shouldSucceed = true;

  @override
  Future<Result<OperatorModel>> fetchOperator({required String mobileNumber}) async {
    if (shouldSucceed) {
      return const Success(OperatorModel(
        opcode: 'JIO',
        name: 'Reliance Jio',
        circle: 'Delhi NCR',
      ));
    }
    return const Error(ServerFailure('Failed to fetch operator'));
  }

  @override
  Future<Result<CategorisedPlans>> fetchPlans({
    required String mobileNumber,
    required String opcode,
    required String circle,
    bool isDth = false,
  }) async {
    if (shouldSucceed) {
      return const Success(CategorisedPlans({
        'Unlimited': [
          RechargePlanModel(id: '1', amount: 299, description: '1.5GB/day'),
          RechargePlanModel(id: '2', amount: 399, description: '2GB/day'),
        ],
        'Data': [
          RechargePlanModel(id: '3', amount: 19, description: '1GB addon'),
        ],
      }));
    }
    return const Error(ServerFailure('Failed to fetch plans'));
  }

  @override
  Future<Result<List<RechargePlanModel>>> fetchRoffers({
    required String mobileNumber,
    required String opcode,
  }) async {
    return const Success([
      RechargePlanModel(id: 'r1', amount: 239, description: 'Special 1.5GB/day'),
    ]);
  }

  @override
  Future<Result<OrderModel>> createOrder({
    required String opcode,
    required String number,
    required double amount,
    String? type,
    String? fetchId,
  }) async {
    return const Success(OrderModel(
      orderId: 'ord_1',
      razorpayOrderId: 'rzp_1',
      amount: 299,
      currency: 'INR',
    ));
  }

  @override
  Future<Result<PaymentVerifyModel>> verifyPayment({
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
    String? type,
  }) async {
    return const Success(PaymentVerifyModel(
      success: true,
      message: 'Recharge Successful',
    ));
  }

  @override
  Future<Result<List<TransactionModel>>> fetchRecentRecharges() async {
    return const Success([]);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeRechargeRepository fakeRepo;
  late RechargeCubit rechargeCubit;

  setUp(() {
    fakeRepo = FakeRechargeRepository();
    rechargeCubit = RechargeCubit(
      getOperatorAndPlansUseCase: GetOperatorAndPlansUseCase(fakeRepo),
      getRoffersUseCase: GetRoffersUseCase(fakeRepo),
      createRechargeOrderUseCase: CreateRechargeOrderUseCase(fakeRepo),
      verifyRechargePaymentUseCase: VerifyRechargePaymentUseCase(fakeRepo),
      getRecentRechargesUseCase: GetRecentRechargesUseCase(fakeRepo),
    );
  });

  tearDown(() {
    rechargeCubit.close();
  });

  test('initial state is RechargeInitial', () {
    expect(rechargeCubit.state, equals(const RechargeInitial()));
  });

  test('loadOperatorAndPlans emits RechargeLoading then RechargeLoaded', () async {
    expectLater(
      rechargeCubit.stream,
      emitsInOrder([
        isA<RechargeLoading>(),
        isA<RechargeLoaded>().having(
          (s) => s.operator.name,
          'operator name',
          'Reliance Jio',
        ),
        isA<RechargeLoaded>().having(
          (s) => s.roffers.length,
          'roffers count',
          1,
        ),
      ]),
    );

    await rechargeCubit.loadOperatorAndPlans(mobileNumber: '9876543210');
  });

  test('selectCategory changes displayed plans', () async {
    await rechargeCubit.loadOperatorAndPlans(mobileNumber: '9876543210');
    rechargeCubit.selectCategory('Data');

    expect(rechargeCubit.state, isA<RechargeLoaded>());
    final state = rechargeCubit.state as RechargeLoaded;
    expect(state.selectedCategory, 'Data');
    expect(state.displayedPlans.length, 1);
    expect(state.displayedPlans.first.amount, 19);
  });

  test('searchPlans filters by amount or text', () async {
    await rechargeCubit.loadOperatorAndPlans(mobileNumber: '9876543210');
    rechargeCubit.searchPlans('399');

    final state = rechargeCubit.state as RechargeLoaded;
    expect(state.displayedPlans.length, 1);
    expect(state.displayedPlans.first.amount, 399);
  });
}
