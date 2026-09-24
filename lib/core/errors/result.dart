import 'failures.dart';

/// Functional result type for repository and use-case operations in JigroPay.
///
/// Encapsulates either a [Success] containing [data] of type [T],
/// or an [Error] containing a domain [Failure].
///
/// Example:
/// ```dart
/// final result = await repository.sendOtp(phone: '9876543210');
/// switch (result) {
///   case Success(:final data):
///     emit(AuthOtpSent(phone: phone, message: data));
///   case Error(:final failure):
///     emit(AuthError(failure.message));
/// }
/// ```
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Error<T>;

  T? get dataOrNull => switch (this) {
        Success(:final data) => data,
        Error() => null,
      };

  Failure? get failureOrNull => switch (this) {
        Success() => null,
        Error(:final failure) => failure,
      };

  R fold<R>({
    required R Function(Failure failure) onFailure,
    required R Function(T data) onSuccess,
  }) {
    return switch (this) {
      Success(:final data) => onSuccess(data),
      Error(:final failure) => onFailure(failure),
    };
  }
}

/// Represents a successful operation holding [data].
final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;

  @override
  String toString() => 'Success($data)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;
}

/// Represents a failed operation holding a [failure].
final class Error<T> extends Result<T> {
  const Error(this.failure);
  final Failure failure;

  @override
  String toString() => 'Error($failure)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Error<T> &&
          runtimeType == other.runtimeType &&
          failure == other.failure;

  @override
  int get hashCode => failure.hashCode;
}
