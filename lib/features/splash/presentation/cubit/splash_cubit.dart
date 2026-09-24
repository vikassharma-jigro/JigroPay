import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/storage_service.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({StorageService? storageService})
      : _storageService = storageService ?? StorageService.instance,
        super(const SplashInitial());

  final StorageService _storageService;

  /// Determines destination screen on app launch.
  /// Strictly checks local secure storage only — no startup network calls.
  Future<void> determineStartupRoute() async {
    final token = await _storageService.getAccessToken();
    final isLoggedIn = _storageService.isLoggedIn && token != null && token.isNotEmpty;

    if (isLoggedIn) {
      emit(const SplashAuthenticated());
    } else {
      final showOnboarding = !_storageService.isOnboardingShown;
      emit(SplashUnauthenticated(showOnboarding: showOnboarding));
    }
  }
}
