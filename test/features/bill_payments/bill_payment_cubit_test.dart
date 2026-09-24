import 'package:flutter_test/flutter_test.dart';
import 'package:jigrotech/core/errors/failures.dart';
import 'package:jigrotech/core/errors/result.dart';
import 'package:jigrotech/features/bill_payments/data/models/bill_details_model.dart';
import 'package:jigrotech/features/bill_payments/data/models/biller_model.dart';
import 'package:jigrotech/features/bill_payments/domain/repositories/bill_payment_repository.dart';
import 'package:jigrotech/features/bill_payments/domain/usecases/fetch_bill_details_usecase.dart';
import 'package:jigrotech/features/bill_payments/domain/usecases/fetch_billers_usecase.dart';
import 'package:jigrotech/features/bill_payments/domain/usecases/pay_bill_usecase.dart';
import 'package:jigrotech/features/bill_payments/presentation/cubit/bill_payment_cubit.dart';
import 'package:jigrotech/features/bill_payments/presentation/cubit/bill_payment_state.dart';
import 'package:jigrotech/features/recharge/data/models/order_model.dart';

class FakeBillPaymentRepository implements BillPaymentRepository {
  bool shouldSucceed = true;

  @override
  Future<Result<List<BillerModel>>> fetchBillersByType({required String serviceType}) async {
    if (shouldSucceed) {
      return const Success([
        BillerModel(opcode: 'JVVNL', name: 'Jaipur Vidyut Vitran Nigam Ltd', state: 'Rajasthan'),
        BillerModel(opcode: 'AVVNL', name: 'Ajmer Vidyut Vitran Nigam Ltd', state: 'Rajasthan'),
      ]);
    }
    return const Error(ServerFailure('Failed to load billers'));
  }

  @override
  Future<Result<BillDetailsModel>> fetchBillDetails({
    required String serviceType,
    required String billerCode,
    required String consumerNumber,
    Map<String, dynamic>? extraFields,
  }) async {
    if (shouldSucceed) {
      return Success(BillDetailsModel(
        fetchId: 'F100',
        consumerName: 'Rajesh Sharma',
        amount: 1450.0,
        consumerNumber: consumerNumber,
      ));
    }
    return const Error(ServerFailure('Invalid consumer number'));
  }

  @override
  Future<Result<OrderModel>> createBillOrder({
    required String opcode,
    required String consumerNumber,
    required double amount,
    required String fetchId,
    String? serviceType,
  }) async {
    return const Success(OrderModel(
      orderId: 'ord_bill_1',
      razorpayOrderId: 'rzp_bill_1',
      amount: 1450.0,
      currency: 'INR',
    ));
  }

  @override
  Future<Result<PaymentVerifyModel>> verifyBillPayment({
    required String paymentId,
    required String orderId,
    required String signature,
    String? serviceType,
  }) async {
    return const Success(PaymentVerifyModel(
      success: true,
      message: 'Bill Payment Successful',
    ));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeBillPaymentRepository fakeRepo;
  late BillPaymentCubit billPaymentCubit;

  setUp(() {
    fakeRepo = FakeBillPaymentRepository();
    billPaymentCubit = BillPaymentCubit(
      fetchBillersUseCase: FetchBillersUseCase(fakeRepo),
      fetchBillDetailsUseCase: FetchBillDetailsUseCase(fakeRepo),
      payBillUseCase: PayBillUseCase(fakeRepo),
    );
  });

  tearDown(() {
    billPaymentCubit.close();
  });

  test('initial state is BillPaymentInitial', () {
    expect(billPaymentCubit.state, equals(const BillPaymentInitial()));
  });

  test('loadBillers loads billers list and emits BillersLoaded', () async {
    expectLater(
      billPaymentCubit.stream,
      emitsInOrder([
        isA<BillPaymentLoading>(),
        isA<BillersLoaded>().having(
          (s) => s.billers.length,
          'billers length',
          2,
        ),
      ]),
    );

    await billPaymentCubit.loadBillers(serviceType: 'electricity');
  });

  test('searchBillers filters billers correctly', () async {
    await billPaymentCubit.loadBillers(serviceType: 'electricity');
    billPaymentCubit.searchBillers('Jaipur');

    final state = billPaymentCubit.state as BillersLoaded;
    expect(state.displayedBillers.length, 1);
    expect(state.displayedBillers.first.opcode, 'JVVNL');
  });

  test('fetchBill emits BillPaymentLoading then BillFetched', () async {
    expectLater(
      billPaymentCubit.stream,
      emitsInOrder([
        isA<BillPaymentLoading>(),
        isA<BillFetched>().having(
          (s) => s.billDetails.consumerName,
          'consumer name',
          'Rajesh Sharma',
        ),
      ]),
    );

    await billPaymentCubit.fetchBill(
      serviceType: 'electricity',
      biller: const BillerModel(opcode: 'JVVNL', name: 'JVVNL'),
      consumerNumber: '123456789012',
    );
  });
}
