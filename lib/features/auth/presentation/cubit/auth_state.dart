import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial resting state.
final class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Asynchronous operation in flight.
final class AuthLoading extends AuthState {
  const AuthLoading([this.message]);
  final String? message;

  @override
  List<Object?> get props => [message];
}

/// OTP successfully dispatched to user's mobile.
final class AuthOtpSent extends AuthState {
  const AuthOtpSent({
    required this.phone,
    required this.message,
    this.email,
  });

  final String phone;
  final String message;
  final String? email;

  @override
  List<Object?> get props => [phone, message, email];
}

/// User is fully authenticated with an active session.
final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);
  final UserModel user;

  @override
  List<Object?> get props => [user];
}

/// User is not logged in / logged out.
final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated([this.message]);
  final String? message;

  @override
  List<Object?> get props => [message];
}

/// Operation failed with user-facing error message.
final class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
