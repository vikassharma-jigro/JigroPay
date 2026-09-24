import 'package:flutter_test/flutter_test.dart';
import 'package:jigrotech/core/errors/result.dart';
import 'package:jigrotech/features/help_support/data/models/faq_model.dart';
import 'package:jigrotech/features/help_support/domain/repositories/help_support_repository.dart';
import 'package:jigrotech/features/help_support/domain/usecases/get_faqs_usecase.dart';
import 'package:jigrotech/features/help_support/domain/usecases/submit_enquiry_usecase.dart';
import 'package:jigrotech/features/help_support/presentation/cubit/help_support_cubit.dart';
import 'package:jigrotech/features/help_support/presentation/cubit/help_support_state.dart';

class _FakeHelpSupportRepository implements HelpSupportRepository {
  @override
  Future<Result<FaqResponse>> fetchFaqs() async {
    return const Success(FaqResponse(
      faqs: [
        FaqModel(question: 'Q1', answer: 'A1'),
        FaqModel(question: 'Q2', answer: 'A2'),
      ],
      companyEmail: 'support@jigrotech.com',
      companyContact: '9216075703',
    ));
  }

  @override
  Future<Result<bool>> submitEnquiry({
    required String subject,
    required String message,
    String? category,
  }) async {
    return const Success(true);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeHelpSupportRepository repo;
  late HelpSupportCubit cubit;

  setUp(() {
    repo = _FakeHelpSupportRepository();
    cubit = HelpSupportCubit(
      getFaqsUseCase: GetFaqsUseCase(repo),
      submitEnquiryUseCase: SubmitEnquiryUseCase(repo),
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is HelpSupportInitial', () {
    expect(cubit.state, equals(const HelpSupportInitial()));
  });

  test('loadFaqs emits [Loading, Loaded] with company contact info', () async {
    expectLater(
      cubit.stream,
      emitsInOrder([
        isA<HelpSupportLoading>(),
        isA<HelpSupportLoaded>()
            .having((s) => s.faqs.length, 'faqs count', 2)
            .having((s) => s.companyEmail, 'companyEmail', 'support@jigrotech.com')
            .having((s) => s.companyContact, 'companyContact', '9216075703'),
      ]),
    );

    await cubit.loadFaqs();
  });

  test('submitEnquiry succeeds and updates state', () async {
    await cubit.loadFaqs();
    final success = await cubit.submitEnquiry(
      subject: 'Issue',
      message: 'Need help',
    );

    expect(success, isTrue);
    expect(cubit.state, isA<HelpSupportLoaded>());
    final state = cubit.state as HelpSupportLoaded;
    expect(state.submitSuccess, isTrue);
  });
}
