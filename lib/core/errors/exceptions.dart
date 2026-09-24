/// Typed exception hierarchy for JigroPay.
///
/// All exceptions in this file are thrown by the network/data layer and
/// caught at the repository layer, which converts them into [Failure] objects
/// for the presentation layer.
library;

// ── Base ─────────────────────────────────────────────────────────────────────

/// Root of the JigroPay exception hierarchy.
sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

// ── Network ───────────────────────────────────────────────────────────────────

/// Thrown when there is no internet connection or DNS lookup fails.
final class NetworkException extends AppException {
  const NetworkException([
    super.message = 'No internet connection. Please check your network.',
  ]);
}

/// Thrown when a Dio request exceeds connect / receive / send timeout.
final class TimeoutException extends AppException {
  const TimeoutException([
    super.message = 'Request timed out. Please try again.',
  ]);
}

// ── Server ────────────────────────────────────────────────────────────────────

/// Thrown for non-2xx HTTP responses that carry a structured API error.
final class ServerException extends AppException {
  const ServerException({
    required String message,
    required this.statusCode,
  }) : super(message);

  final int statusCode;
}

/// Thrown specifically for 401 Unauthorized — triggers auto-logout.
final class UnauthorizedException extends AppException {
  const UnauthorizedException([
    super.message = 'Session expired. Please login again.',
  ]);
}

// ── Data ──────────────────────────────────────────────────────────────────────

/// Thrown when JSON decoding / model parsing fails on a required field.
final class ParseException extends AppException {
  const ParseException({
    required String field,
    String? context,
  }) : super(
          context != null
              ? 'Failed to parse "$field" in $context.'
              : 'Failed to parse required field "$field".',
        );
}

// ── Validation ────────────────────────────────────────────────────────────────

/// Thrown when input validation fails before an API call is made.
final class ValidationException extends AppException {
  const ValidationException(super.message);
}
