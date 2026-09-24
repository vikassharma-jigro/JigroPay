import 'package:flutter_test/flutter_test.dart';
import 'package:jigrotech/core/errors/failures.dart';
import 'package:jigrotech/core/errors/result.dart';
import 'package:jigrotech/features/history/data/models/transaction_model.dart';
import 'package:jigrotech/features/history/domain/repositories/history_repository.dart';
import 'package:jigrotech/features/history/domain/usecases/get_transaction_history_usecase.dart';
import 'package:jigrotech/features/history/presentation/cubit/history_cubit.dart';
import 'package:jigrotech/features/history/presentation/cubit/history_state.dart';

class _FakeHistoryRepository implements HistoryRepository {
  bool shouldSucceed = true;

  @override
  Future<Result<List<TransactionModel>>> fetchTransactionHistory({
    String? type,
    String? status,
  }) async {
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
        TransactionModel(
          id: '2',
          number: '9123456780',
          operator: 'Jio',
          amount: 666,
          status: 'failed',
          createdAt: DateTime(2024, 1, 2),
        ),
      ]);
    }
    return const Error(ServerFailure('History failed'));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeHistoryRepository repo;
  late HistoryCubit cubit;

  setUp(() {
    repo = _FakeHistoryRepository();
    cubit = HistoryCubit(
      getTransactionHistoryUseCase: GetTransactionHistoryUseCase(repo),
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is HistoryInitial', () {
    expect(cubit.state, equals(const HistoryInitial()));
  });

  test('loadHistory emits [Loading, Loaded] on success', () async {
    expectLater(
      cubit.stream,
      emitsInOrder([
        isA<HistoryLoading>(),
        isA<HistoryLoaded>()
            .having((s) => s.allTransactions.length, 'total count', 2),
      ]),
    );

    await cubit.loadHistory();
  });

  test('filterByStatus filters correctly by success/failed', () async {
    await cubit.loadHistory();

    cubit.filterByStatus('Success');
    expect(cubit.state, isA<HistoryLoaded>());
    var state = cubit.state as HistoryLoaded;
    expect(state.displayedTransactions.length, 1);
    expect(state.displayedTransactions.first.operator, 'Airtel');

    cubit.filterByStatus('Failed');
    state = cubit.state as HistoryLoaded;
    expect(state.displayedTransactions.length, 1);
    expect(state.displayedTransactions.first.operator, 'Jio');
  });

  test('search filters transactions by query', () async {
    await cubit.loadHistory();

    cubit.search('666');
    final state = cubit.state as HistoryLoaded;
    expect(state.displayedTransactions.length, 1);
    expect(state.displayedTransactions.first.amount, 666);
  });
}
