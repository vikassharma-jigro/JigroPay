import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_typography.dart';
import 'core/network/api_client.dart';
import 'core/router/app_router.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'features/auth/domain/usecases/get_profile_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/send_otp_usecase.dart';
import 'features/auth/domain/usecases/verify_otp_usecase.dart';
import 'features/auth/domain/usecases/update_profile_usecase.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/splash/presentation/cubit/splash_cubit.dart';

class JigroPayApp extends StatefulWidget {
  const JigroPayApp({super.key});

  @override
  State<JigroPayApp> createState() => _JigroPayAppState();
}

class _JigroPayAppState extends State<JigroPayApp> {
  late final StreamSubscription<void> _unauthorizedSub;
  late final AuthRepositoryImpl _authRepository;
  late final AuthCubit _authCubit;
  late final SplashCubit _splashCubit;

  @override
  void initState() {
    super.initState();

    _authRepository = AuthRepositoryImpl();
    _authCubit = AuthCubit(
      sendOtpUseCase: SendOtpUseCase(_authRepository),
      verifyOtpUseCase: VerifyOtpUseCase(_authRepository),
      registerUseCase: RegisterUseCase(_authRepository),
      logoutUseCase: LogoutUseCase(_authRepository),
      checkAuthStatusUseCase: CheckAuthStatusUseCase(_authRepository),
      getProfileUseCase: GetProfileUseCase(_authRepository),
      updateProfileUseCase: UpdateProfileUseCase(_authRepository),
    );
    _splashCubit = SplashCubit();

    // Auto-logout listener on HTTP 401
    _unauthorizedSub = ApiClient.instance.unauthorizedStream.listen((_) {
      _authCubit.logout();
      AppRouter.router.go('/login');
    });
  }

  @override
  void dispose() {
    _unauthorizedSub.cancel();
    _authCubit.close();
    _splashCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: _authCubit),
        BlocProvider<SplashCubit>.value(value: _splashCubit),
      ],
      child: MaterialApp.router(
        title: 'JigroPay',
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
        theme: ThemeData(
          useMaterial3: false,
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.white,
          fontFamily: AppTypography.outfitRegular,
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            surface: AppColors.white,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: AppColors.black),
          ),
        ),
      ),
    );
  }
}
