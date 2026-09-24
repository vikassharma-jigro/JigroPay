import 'package:equatable/equatable.dart';
import '../../data/models/faq_model.dart';

sealed class HelpSupportState extends Equatable {
  const HelpSupportState();

  @override
  List<Object?> get props => [];
}

final class HelpSupportInitial extends HelpSupportState {
  const HelpSupportInitial();
}

final class HelpSupportLoading extends HelpSupportState {
  const HelpSupportLoading();
}

final class HelpSupportLoaded extends HelpSupportState {
  const HelpSupportLoaded({
    required this.faqs,
    this.companyEmail,
    this.companyContact,
    this.isSubmitting = false,
    this.submitSuccess = false,
    this.submitError,
  });

  final List<FaqModel> faqs;
  final String? companyEmail;
  final String? companyContact;
  final bool isSubmitting;
  final bool submitSuccess;
  final String? submitError;

  HelpSupportLoaded copyWith({
    List<FaqModel>? faqs,
    String? companyEmail,
    String? companyContact,
    bool? isSubmitting,
    bool? submitSuccess,
    String? submitError,
  }) {
    return HelpSupportLoaded(
      faqs: faqs ?? this.faqs,
      companyEmail: companyEmail ?? this.companyEmail,
      companyContact: companyContact ?? this.companyContact,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitSuccess: submitSuccess ?? this.submitSuccess,
      submitError: submitError,
    );
  }

  @override
  List<Object?> get props => [
        faqs,
        companyEmail,
        companyContact,
        isSubmitting,
        submitSuccess,
        submitError,
      ];
}

final class HelpSupportError extends HelpSupportState {
  const HelpSupportError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
