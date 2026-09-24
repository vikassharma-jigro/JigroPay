/// UI-facing Failure hierarchy for JigroPay.
///
/// Repositories catch [AppException]s and convert them into [Failure] objects.
/// Cubits hold [Failure] in their error states and pass [Failure.message] to
/// the toast / error widget — no raw stack traces ever reach the UI layer.
library;

import 'exceptions.dart';

// ── Base ─────────────────────────────────────────────────────────────────────

/// Root of the JigroPay Failure hierarchy.
sealed class Failure {
  const Failure(this.message);
  final String message;

  @override
  String toString() => '$runtimeType($message)';
}

// ── Concrete Failures ─────────────────────────────────────────────────────────

/// No internet / DNS failure.
final class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'No internet connection. Please check your network.',
  ]);
}

/// Request timed out.
final class TimeoutFailure extends Failure {
  const TimeoutFailure([
    super.message = 'Request timed out. Please try again.',
  ]);
}

/// 4xx / 5xx server error with a user-readable message.
final class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode});
  final int? statusCode;
}

/// 401 — session expired.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    super.message = 'Session expired. Please login again.',
  ]);
}

/// JSON / model parse failure (e.g. missing required field).
final class ParseFailure extends Failure {
  const ParseFailure(super.message);
}

/// Input validation failed before any API call.
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Catch-all for unexpected errors.
final class UnknownFailure extends Failure {
  const UnknownFailure([
    super.message = 'Something went wrong. Please try again.',
  ]);
}

// ── Converter ────────────────────────────────────────────────────────────────

/// Maps any [AppException] to the corresponding [Failure].
///
/// Call this inside repository `catch` blocks:
/// ```dart
/// } on AppException catch (e) {
///   return Failure.fromException(e);
/// }
/// ```
extension FailureMapper on AppException {
  Failure toFailure() {
    return switch (this) {
      NetworkException e => NetworkFailure(e.message),
      TimeoutException e => TimeoutFailure(e.message),
      UnauthorizedException e => UnauthorizedFailure(e.message),
      ServerException e => ServerFailure(e.message, statusCode: e.statusCode),
      ParseException e => ParseFailure(e.message),
      ValidationException e => ValidationFailure(e.message),
    };
  }
}
