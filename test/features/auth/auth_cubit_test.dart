import 'package:flutter_test/flutter_test.dart';
import 'package:jigrotech/core/errors/failures.dart';
import 'package:jigrotech/core/errors/result.dart';
import 'package:jigrotech/features/auth/data/models/user_model.dart';
import 'package:jigrotech/features/auth/domain/repositories/auth_repository.dart';
import 'package:jigrotech/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:jigrotech/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:jigrotech/features/auth/domain/usecases/logout_usecase.dart';
import 'package:jigrotech/features/auth/domain/usecases/register_usecase.dart';
import 'package:jigrotech/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:jigrotech/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:jigrotech/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:jigrotech/features/auth/presentation/cubit/auth_state.dart';

class FakeAuthRepository implements AuthRepository {
  bool shouldSucceed = true;
  String errorMessage = 'Failed';
  bool isUserAuth = false;

  @override
  Future<Result<String>> sendOtp({required String phone}) async {
    if (shouldSucceed) {
      return const Success('OTP Sent Successfully');
    }
    return Error(ServerFailure(errorMessage));
  }

  @override
  Future<Result<UserModel>> verifyOtp({
    required String phone,
    required String otp,
    required String fcmToken,
  }) async {
    if (shouldSucceed) {
      return Success(UserModel(id: 1, name: 'Test User', phone: phone));
    }
    return Error(ServerFailure(errorMessage));
  }

  @override
  Future<Result<UserModel>> register({
    required String name,
    required String email,
    required String phone,
  }) async {
    if (shouldSucceed) {
      return Success(UserModel(id: 2, name: name, phone: phone, email: email));
    }
    return Error(ServerFailure(errorMessage));
  }

  @override
  Future<Result<UserModel>> getProfile() async {
    if (shouldSucceed) {
      return const Success(
        UserModel(id: 1, name: 'Profile User', phone: '9876543210'),
      );
    }
    return Error(ServerFailure(errorMessage));
  }

  @override
  Future<Result<UserModel>> updateProfile({
    required String name,
    required String email,
    String? profileImage,
  }) async {
    if (shouldSucceed) {
      return Success(
        UserModel(id: 1, name: name, phone: '9876543210', email: email),
      );
    }
    return Error(ServerFailure(errorMessage));
  }

  @override
  Future<Result<void>> logout() async {
    isUserAuth = false;
    return const Success(null);
  }

  @override
  Future<bool> isAuthenticated() async => isUserAuth;
}

void main() {
  late FakeAuthRepository fakeRepo;
  late AuthCubit authCubit;

  setUp(() {
    fakeRepo = FakeAuthRepository();
    authCubit = AuthCubit(
      sendOtpUseCase: SendOtpUseCase(fakeRepo),
      verifyOtpUseCase: VerifyOtpUseCase(fakeRepo),
      registerUseCase: RegisterUseCase(fakeRepo),
      logoutUseCase: LogoutUseCase(fakeRepo),
      checkAuthStatusUseCase: CheckAuthStatusUseCase(fakeRepo),
      getProfileUseCase: GetProfileUseCase(fakeRepo),
    );
  });

  tearDown(() {
    authCubit.close();
  });

  test('initial state is AuthInitial', () {
    expect(authCubit.state, equals(const AuthInitial()));
  });

  group('sendOtp', () {
    test('emits [AuthLoading, AuthOtpSent] on success', () async {
      final expected = [
        const AuthLoading(),
        const AuthOtpSent(
          phone: '9876543210',
          message: 'OTP Sent Successfully',
        ),
      ];

      expectLater(authCubit.stream, emitsInOrder(expected));
      await authCubit.sendOtp(phone: '9876543210');
    });

    test('emits [AuthLoading, AuthError] on failure', () async {
      fakeRepo.shouldSucceed = false;
      fakeRepo.errorMessage = 'Mobile not found';

      final expected = [
        const AuthLoading(),
        const AuthError('Mobile not found'),
      ];

      expectLater(authCubit.stream, emitsInOrder(expected));
      await authCubit.sendOtp(phone: '9876543210');
    });
  });

  group('verifyOtp', () {
    test('emits [AuthLoading, AuthAuthenticated] on success', () async {
      final expected = [
        const AuthLoading(),
        const AuthAuthenticated(
          UserModel(id: 1, name: 'Test User', phone: '9876543210'),
        ),
      ];

      expectLater(authCubit.stream, emitsInOrder(expected));
      await authCubit.verifyOtp(
        phone: '9876543210',
        otp: '123456',
        fcmToken: 'test-token',
      );
    });

    test('emits [AuthLoading, AuthError] on invalid OTP', () async {
      fakeRepo.shouldSucceed = false;
      fakeRepo.errorMessage = 'Invalid OTP';

      final expected = [const AuthLoading(), const AuthError('Invalid OTP')];

      expectLater(authCubit.stream, emitsInOrder(expected));
      await authCubit.verifyOtp(
        phone: '9876543210',
        otp: '000000',
        fcmToken: 'test-token',
      );
    });
  });

  group('register', () {
    test('emits [AuthLoading, AuthOtpSent] on success', () async {
      final expected = [
        const AuthLoading(),
        const AuthOtpSent(
          phone: '9876543210',
          email: 'test@example.com',
          message: 'Registration submitted. Please verify the OTP sent.',
        ),
      ];

      expectLater(authCubit.stream, emitsInOrder(expected));
      await authCubit.register(
        name: 'New User',
        email: 'test@example.com',
        phone: '9876543210',
      );
    });
  });

  group('logout', () {
    test('emits [AuthLoading, AuthUnauthenticated]', () async {
      final expected = [const AuthLoading(), const AuthUnauthenticated()];

      expectLater(authCubit.stream, emitsInOrder(expected));
      await authCubit.logout();
    });
  });
}
