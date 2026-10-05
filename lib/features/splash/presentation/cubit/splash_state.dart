import 'package:equatable/equatable.dart';
import '../../../../core/services/version_check_service.dart';

sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

final class SplashInitial extends SplashState {
  const SplashInitial();
}

final class SplashAuthenticated extends SplashState {
  const SplashAuthenticated();
}

final class SplashUnauthenticated extends SplashState {
  const SplashUnauthenticated({required this.showOnboarding});
  final bool showOnboarding;

  @override
  List<Object?> get props => [showOnboarding];
}

final class SplashUpdateRequired extends SplashState {
  const SplashUpdateRequired({
    required this.updateResult,
    this.nextState,
  });

  final VersionCheckResult updateResult;
  final SplashState? nextState;

  @override
  List<Object?> get props => [updateResult, nextState];
}

