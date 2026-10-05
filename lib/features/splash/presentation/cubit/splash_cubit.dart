import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/version_check_service.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({
    StorageService? storageService,
    VersionCheckService? versionCheckService,
  }) : _storageService = storageService ?? StorageService.instance,
       _versionCheckService = versionCheckService ?? VersionCheckService(),
       super(const SplashInitial());

  final StorageService _storageService;
  final VersionCheckService _versionCheckService;

  /// Determines destination screen on app launch, evaluating version control first.
  Future<void> determineStartupRoute() async {
    try {
      final versionResult = await _versionCheckService.checkAppVersion();

      if (versionResult.isForceUpdate) {
        emit(SplashUpdateRequired(updateResult: versionResult));
        return;
      } else if (versionResult.isUpdateAvailable) {
        final nextState = await _resolveNextState();
        emit(
          SplashUpdateRequired(
            updateResult: versionResult,
            nextState: nextState,
          ),
        );
        return;
      }
    } catch (_) {
      // Graceful fallback: Network issue or timeout must not prevent app startup
    }

    final nextState = await _resolveNextState();
    emit(nextState);
  }

  Future<SplashState> _resolveNextState() async {
    final token = await _storageService.getAccessToken();
    final isLoggedIn =
        _storageService.isLoggedIn && token != null && token.isNotEmpty;

    if (isLoggedIn) {
      return const SplashAuthenticated();
    } else {
      final showOnboarding = !_storageService.isOnboardingShown;
      return SplashUnauthenticated(showOnboarding: showOnboarding);
    }
  }
}
