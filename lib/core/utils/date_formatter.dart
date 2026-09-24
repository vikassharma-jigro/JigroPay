import 'package:intl/intl.dart';

/// Date and time formatting utilities — single source of truth.
///
/// Replaces duplicated date parsing and formatting logic scattered across
/// [history_screen.dart], [payment_details_screen.dart], and receipt widgets.
abstract final class DateFormatter {
  // ── Display formats ──────────────────────────────────────────────────────────

  /// e.g. "21 Sep 2026"
  static String toDisplayDate(DateTime dt) =>
      DateFormat('dd MMM yyyy').format(dt);

  /// e.g. "21 Sep 2026"
  static String toDayMonthYear(DateTime dt) => toDisplayDate(dt);

  /// e.g. "21 Sep 2026, 12:30 PM"
  static String toDisplayDateTime(DateTime dt) =>
      DateFormat('dd MMM yyyy, hh:mm a').format(dt);

  /// e.g. "12:30 PM"
  static String toTime(DateTime dt) => DateFormat('hh:mm a').format(dt);

  /// e.g. "Sep 2026"
  static String toMonthYear(DateTime dt) => DateFormat('MMM yyyy').format(dt);

  /// e.g. "21/09/2026"
  static String toDDMMYYYY(DateTime dt) => DateFormat('dd/MM/yyyy').format(dt);

  // ── Parsing ───────────────────────────────────────────────────────────────────

  /// Parses an ISO-8601 or common API date string to [DateTime].
  ///
  /// Returns `null` if the string is null, empty, or unparseable —
  /// callers should handle null gracefully.
  static DateTime? tryParse(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      return DateTime.parse(raw.trim()).toLocal();
    } catch (_) {
      // Attempt common alternate formats
      for (final fmt in _alternateFmts) {
        try {
          return DateFormat(fmt).parseStrict(raw.trim()).toLocal();
        } catch (_) {}
      }
      return null;
    }
  }

  /// Same as [tryParse] but returns [DateTime.now()] on failure.
  static DateTime parseOrNow(String? raw) => tryParse(raw) ?? DateTime.now();

  // ── Relative time ─────────────────────────────────────────────────────────────

  /// Returns a human-readable relative time string.
  ///
  /// e.g. "Just now", "5 min ago", "2 hours ago", "Yesterday", "21 Sep 2026"
  static String toRelative(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return toDisplayDate(dt);
  }

  // ── Private ───────────────────────────────────────────────────────────────────
  static const _alternateFmts = [
    'dd-MM-yyyy HH:mm:ss',
    'dd/MM/yyyy HH:mm:ss',
    'yyyy-MM-dd HH:mm:ss',
    'dd-MM-yyyy',
    'dd/MM/yyyy',
    'MM/dd/yyyy',
  ];
}
