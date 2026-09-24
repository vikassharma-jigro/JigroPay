import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/result.dart';
import '../../domain/usecases/get_faqs_usecase.dart';
import '../../domain/usecases/submit_enquiry_usecase.dart';
import 'help_support_state.dart';

class HelpSupportCubit extends Cubit<HelpSupportState> {
  HelpSupportCubit({
    required GetFaqsUseCase getFaqsUseCase,
    required SubmitEnquiryUseCase submitEnquiryUseCase,
  })  : _getFaqsUseCase = getFaqsUseCase,
        _submitEnquiryUseCase = submitEnquiryUseCase,
        super(const HelpSupportInitial());

  final GetFaqsUseCase _getFaqsUseCase;
  final SubmitEnquiryUseCase _submitEnquiryUseCase;

  /// Loads FAQs lazily on screen open.
  Future<void> loadFaqs() async {
    emit(const HelpSupportLoading());
    final result = await _getFaqsUseCase();
    switch (result) {
      case Success(:final data):
        emit(HelpSupportLoaded(
          faqs: data.faqs,
          companyEmail: data.companyEmail,
          companyContact: data.companyContact,
        ));
      case Error(:final failure):
        emit(HelpSupportError(failure.message));
    }
  }

  /// Submits enquiry ticket.
  Future<bool> submitEnquiry({
    required String subject,
    required String message,
    String? category,
  }) async {
    final current = state is HelpSupportLoaded ? state as HelpSupportLoaded : null;
    if (current != null) {
      emit(current.copyWith(isSubmitting: true, submitError: null));
    }

    final result = await _submitEnquiryUseCase(
      subject: subject,
      message: message,
      category: category,
    );

    switch (result) {
      case Success():
        if (current != null) {
          emit(current.copyWith(
            isSubmitting: false,
            submitSuccess: true,
            submitError: null,
          ));
        }
        return true;
      case Error(:final failure):
        if (current != null) {
          emit(current.copyWith(
            isSubmitting: false,
            submitSuccess: false,
            submitError: failure.message,
          ));
        }
        return false;
    }
  }
}
