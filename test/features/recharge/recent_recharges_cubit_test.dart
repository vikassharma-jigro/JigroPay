import 'package:flutter_test/flutter_test.dart';
import 'package:jigrotech/core/errors/failures.dart';
import 'package:jigrotech/core/errors/result.dart';
import 'package:jigrotech/features/history/data/models/transaction_model.dart';
import 'package:jigrotech/features/recharge/data/models/operator_model.dart';
import 'package:jigrotech/features/recharge/data/models/order_model.dart';
import 'package:jigrotech/features/recharge/data/models/recharge_plan_model.dart';
import 'package:jigrotech/features/recharge/domain/repositories/recharge_repository.dart';
import 'package:jigrotech/features/recharge/domain/usecases/get_recent_recharges_usecase.dart';
import 'package:jigrotech/features/recharge/presentation/cubit/recent_recharges_cubit.dart';
import 'package:jigrotech/features/recharge/presentation/cubit/recent_recharges_state.dart';

class _FakeRechargeRepository implements RechargeRepository {
  bool shouldSucceed = true;

  @override
  Future<Result<List<TransactionModel>>> fetchRecentRecharges() async {
    if (shouldSucceed) {
      return Success([
        TransactionModel(
          id: '1',
          number: '9876543210',
          operator: 'Airtel',
          amount: 299,
          status: 'success',
          createdAt: DateTime(2024, 1, 1),
        ),
      ]);
    }
    return const Error(ServerFailure('Network error'));
  }

  @override
  Future<Result<OperatorModel>> fetchOperator({required String mobileNumber}) =>
      throw UnimplementedError();

  @override
  Future<Result<CategorisedPlans>> fetchPlans({
    required String mobileNumber,
    required String opcode,
    required String circle,
    bool isDth = false,
  }) =>
      throw UnimplementedError();

  @override
  Future<Result<List<RechargePlanModel>>> fetchRoffers({
    required String mobileNumber,
    required String opcode,
  }) =>
      throw UnimplementedError();

  @override
  Future<Result<OrderModel>> createOrder({
    required String opcode,
    required String number,
    required double amount,
    String? type,
    String? fetchId,
  }) =>
      throw UnimplementedError();

  @override
  Future<Result<PaymentVerifyModel>> verifyPayment({
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
    String? type,
  }) =>
      throw UnimplementedError();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeRechargeRepository fakeRepo;
  late RecentRechargesCubit cubit;

  setUp(() {
    fakeRepo = _FakeRechargeRepository();
    cubit = RecentRechargesCubit(
      getRecentRechargesUseCase: GetRecentRechargesUseCase(fakeRepo),
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is RecentRechargesInitial', () {
    expect(cubit.state, equals(const RecentRechargesInitial()));
  });

  test('loadRecentRecharges emits [Loading, Loaded] on success', () async {
    expectLater(
      cubit.stream,
      emitsInOrder([
        isA<RecentRechargesLoading>(),
        isA<RecentRechargesLoaded>().having(
          (s) => s.recharges.length,
          'recharges count',
          1,
        ),
      ]),
    );

    await cubit.loadRecentRecharges();
  });

  test('loadRecentRecharges emits [Loading, Error] on failure', () async {
    fakeRepo.shouldSucceed = false;

    expectLater(
      cubit.stream,
      emitsInOrder([
        isA<RecentRechargesLoading>(),
        isA<RecentRechargesError>().having(
          (s) => s.message,
          'error message',
          'Network error',
        ),
      ]),
    );

    await cubit.loadRecentRecharges();
  });
}
