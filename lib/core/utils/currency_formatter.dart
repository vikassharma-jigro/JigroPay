import 'package:intl/intl.dart';

/// Currency and amount formatting utilities — single source of truth.
///
/// Replaces scattered amount formatting across receipt and history screens.
abstract final class CurrencyFormatter {
  static final NumberFormat _inrCompact =
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  static final NumberFormat _inrFull =
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

  // ── Display ───────────────────────────────────────────────────────────────────

  /// e.g. `399` → `"₹399"`
  static String format(num amount) => toINR(amount);

  /// e.g. `399` → `"₹399"`
  static String toINR(num amount) => _inrCompact.format(amount);

  /// e.g. `399.50` → `"₹399.50"` (always 2 decimal places)
  static String toINRFull(num amount) => _inrFull.format(amount);

  /// e.g. `399` → `"₹399"`, `399.5` → `"₹399.50"`
  static String toINRAuto(num amount) {
    if (amount == amount.truncate()) return _inrCompact.format(amount);
    return _inrFull.format(amount);
  }

  // ── Parsing ───────────────────────────────────────────────────────────────────

  /// Safely parses a string amount, stripping ₹, commas, and spaces.
  /// Returns `0.0` if the string is null / empty / non-numeric.
  static double tryParse(String? raw) {
    if (raw == null || raw.trim().isEmpty) return 0.0;
    final cleaned = raw.trim().replaceAll('₹', '').replaceAll(',', '').trim();
    return double.tryParse(cleaned) ?? 0.0;
  }

  // ── Razorpay ──────────────────────────────────────────────────────────────────

  /// Converts a rupee [amount] to paise (integer) for Razorpay.
  /// Minimum 1 paise returned to avoid Razorpay validation errors.
  static int toPaise(double amount) {
    final paise = (amount * 100).round();
    return paise > 0 ? paise : 1;
  }

  // ── Words (Indian system) ────────────────────────────────────────────────────

  /// Converts an integer [amount] to Indian words.
  ///
  /// e.g. `150000` → `"One Lakh Fifty Thousand Only"`
  static String toWords(int amount) {
    if (amount == 0) return 'Zero Only';
    return '${_toWords(amount)} Only';
  }

  // ── Private helpers ───────────────────────────────────────────────────────────

  static String _toWords(int n) {
    if (n < 0) return 'Minus ${_toWords(-n)}';
    if (n == 0) return '';

    final ones = [
      '', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight',
      'Nine', 'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen',
      'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'
    ];
    final tens = [
      '', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy',
      'Eighty', 'Ninety'
    ];

    if (n < 20) return ones[n];
    if (n < 100) return '${tens[n ~/ 10]}${n % 10 != 0 ? ' ${ones[n % 10]}' : ''}';
    if (n < 1000) return '${ones[n ~/ 100]} Hundred${n % 100 != 0 ? ' ${_toWords(n % 100)}' : ''}';
    if (n < 100000) return '${_toWords(n ~/ 1000)} Thousand${n % 1000 != 0 ? ' ${_toWords(n % 1000)}' : ''}';
    if (n < 10000000) return '${_toWords(n ~/ 100000)} Lakh${n % 100000 != 0 ? ' ${_toWords(n % 100000)}' : ''}';
    return '${_toWords(n ~/ 10000000)} Crore${n % 10000000 != 0 ? ' ${_toWords(n % 10000000)}' : ''}';
  }
}
