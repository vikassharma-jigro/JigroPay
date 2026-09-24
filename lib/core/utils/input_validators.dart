/// Input validation utilities — single source of truth.
///
/// All return a `String?`: `null` means valid, a non-null string is the
/// user-facing error message. Compatible with [TextFormField.validator].
abstract final class InputValidators {
  // ── Mobile ────────────────────────────────────────────────────────────────────

  /// Validates a 10-digit Indian mobile number.
  static String? mobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a mobile number.';
    }
    final cleaned = value.trim().replaceAll(' ', '');
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(cleaned)) {
      return 'Please enter a valid 10-digit mobile number.';
    }
    return null;
  }

  /// Validates a 6-digit OTP.
  static String? otp(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter the OTP.';
    if (value.trim().length != 6 || !RegExp(r'^\d{6}$').hasMatch(value.trim())) {
      return 'OTP must be exactly 6 digits.';
    }
    return null;
  }

  // ── Name / Text ───────────────────────────────────────────────────────────────

  static String? requiredName(String? value, {String fieldName = 'Name'}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your $fieldName.';
    }
    if (value.trim().length < 2) return '$fieldName is too short.';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address.';
    }
    if (!RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  // ── Amount ────────────────────────────────────────────────────────────────────

  /// Validates a payment amount (positive number, optional min/max).
  static String? amount(String? value, {double min = 1, double? max}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an amount.';
    }
    final parsed = double.tryParse(value.trim().replaceAll(',', ''));
    if (parsed == null) return 'Please enter a valid amount.';
    if (parsed < min) return 'Minimum amount is ₹${min.toStringAsFixed(0)}.';
    if (max != null && parsed > max) {
      return 'Maximum amount is ₹${max.toStringAsFixed(0)}.';
    }
    return null;
  }

  // ── Account / Card ────────────────────────────────────────────────────────────

  /// Validates a credit/debit card number (13–19 digits).
  static String? cardNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a card number.';
    }
    final cleaned = value.replaceAll(' ', '').replaceAll('-', '');
    if (!RegExp(r'^\d{13,19}$').hasMatch(cleaned)) {
      return 'Please enter a valid card number.';
    }
    return null;
  }

  /// Validates last 4 digits of a credit card.
  static String? cardLast4(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the last 4 digits of your card.';
    }
    if (!RegExp(r'^\d{4}$').hasMatch(value.trim())) {
      return 'Please enter exactly 4 digits.';
    }
    return null;
  }

  // ── Vehicle / Bill ────────────────────────────────────────────────────────────

  /// Validates an Indian vehicle registration number (e.g. RJ14AB1234).
  static String? vehicleNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a vehicle registration number.';
    }
    final cleaned = value.trim().toUpperCase().replaceAll(' ', '');
    if (!RegExp(r'^[A-Z]{2}\d{2}[A-Z]{1,3}\d{4}$').hasMatch(cleaned)) {
      return 'Please enter a valid vehicle number (e.g. RJ14AB1234).';
    }
    return null;
  }

  /// Generic required field validator.
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  /// Validates that a numeric-only field has the expected digit [length].
  static String? numericLength(String? value, int length, {String fieldName = 'Number'}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName.';
    }
    if (!RegExp('^\\d{$length}\$').hasMatch(value.trim())) {
      return '$fieldName must be exactly $length digits.';
    }
    return null;
  }
}
