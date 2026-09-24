import '../../../../core/errors/result.dart';
import '../../data/models/user_model.dart';

/// Contract for Authentication repository in JigroPay.
abstract interface class AuthRepository {
  /// Sends OTP to [phone].
  /// Returns the success message from the API.
  Future<Result<String>> sendOtp({required String phone});

  /// Verifies [otp] for [phone] with [fcmToken].
  /// Saves secure tokens to storage on success and returns [UserModel].
  Future<Result<UserModel>> verifyOtp({
    required String phone,
    required String otp,
    required String fcmToken,
  });

  /// Registers a new user with [name], [email], and [phone].
  Future<Result<UserModel>> register({
    required String name,
    required String email,
    required String phone,
  });

  /// Fetches the profile of the currently logged-in user.
  Future<Result<UserModel>> getProfile();

  /// Updates profile details (name, email, and optional profile image path).
  Future<Result<UserModel>> updateProfile({
    required String name,
    required String email,
    String? profileImage,
  });

  /// Logs out the user on the server, clears local storage tokens.
  Future<Result<void>> logout();

  /// Returns true if an active access token and session exist locally.
  Future<bool> isAuthenticated();
}
