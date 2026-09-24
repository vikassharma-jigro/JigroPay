import 'dart:convert';

/// Extracts a human-readable message from any raw API response or exception.
///
/// Extracted from [ApiBaseHelper] into a standalone pure function so it
/// can be unit-tested independently and reused across the codebase without
/// importing Flutter or GetX.
String cleanApiMessage(dynamic rawInput) {
  if (rawInput == null) return '';

  const String fallback = 'Server error occurred. Please try again.';

  // 1. Map — scan known message keys, then nested keys, then any string value.
  if (rawInput is Map) {
    const messageKeys = [
      'message', 'msg', 'error', 'errors', 'description',
      'error_description', 'detail', 'details', 'reason', 'reasons',
      'error_message', 'errorMessage', 'error_msg', 'errorMsg',
      'statusMessage', 'status_message', 'responseMessage',
      'response_message', 'res_msg', 'resMsg', 'info', 'response',
    ];

    for (final key in messageKeys) {
      if (rawInput.containsKey(key)) {
        final val = rawInput[key];
        if (val != null && val != rawInput) {
          final extracted = cleanApiMessage(val);
          if (extracted.isNotEmpty && extracted != fallback) return extracted;
        }
      }
    }

    const nestedKeys = ['data', 'result', 'payload', 'body'];
    for (final key in nestedKeys) {
      if (rawInput.containsKey(key)) {
        final val = rawInput[key];
        if (val is Map || val is List) {
          final extracted = cleanApiMessage(val);
          if (extracted.isNotEmpty && extracted != fallback) return extracted;
        }
      }
    }

    for (final value in rawInput.values) {
      if (value is String && value.isNotEmpty) {
        final trimmed = value.trim();
        if (!_isTechnical(trimmed)) {
          final res = cleanApiMessage(trimmed);
          if (res.isNotEmpty && res != fallback) return res;
        }
      }
    }

    return fallback;
  }

  // 2. List — return the first extractable message.
  if (rawInput is List) {
    for (final item in rawInput) {
      final extracted = cleanApiMessage(item);
      if (extracted.isNotEmpty && extracted != fallback) return extracted;
    }
    return fallback;
  }

  String text = rawInput.toString().trim();
  if (text.isEmpty) return '';

  // 3. HTML page (500 Nginx / Apache).
  if (text.contains('<html') ||
      text.contains('<!DOCTYPE') ||
      text.contains('<head') ||
      text.contains('<body')) {
    return fallback;
  }

  // 4. Dio / network exception string.
  if (text.contains('DioException') ||
      text.contains('SocketException') ||
      text.contains('HttpException')) {
    if (text.contains('SocketException') ||
        text.contains('Failed host lookup') ||
        text.contains('Network is unreachable')) {
      return 'No internet connection. Please check your network.';
    }
    if (text.contains('connectTimeout') ||
        text.contains('receiveTimeout') ||
        text.contains('sendTimeout')) {
      return 'Request timed out. Please try again.';
    }
    return fallback;
  }

  // 5. Raw JSON string.
  if ((text.startsWith('{') && text.endsWith('}')) ||
      (text.startsWith('[') && text.endsWith(']'))) {
    try {
      final decoded = jsonDecode(text);
      if (decoded != null && decoded != rawInput) {
        final msg = cleanApiMessage(decoded);
        if (msg.isNotEmpty) return msg;
      }
    } catch (_) {}
  }

  // 6. Embedded JSON in exception message string.
  final firstBrace = text.indexOf('{');
  final lastBrace = text.lastIndexOf('}');
  if (firstBrace != -1 && lastBrace > firstBrace) {
    try {
      final jsonSub = text.substring(firstBrace, lastBrace + 1);
      final decoded = jsonDecode(jsonSub);
      if (decoded != null) {
        final msg = cleanApiMessage(decoded);
        if (msg.isNotEmpty) return msg;
      }
    } catch (_) {}
  }

  // 7. Regex extract key-value from Dart Map.toString().
  final messageRegExp = RegExp(
    r'(?:message|msg|error|description|detail|reason)\s*:\s*([^,\}\]]+)',
    caseSensitive: false,
  );
  final match = messageRegExp.firstMatch(text);
  if (match != null && match.groupCount >= 1) {
    final matchedMsg = match.group(1)?.trim() ?? '';
    if (matchedMsg.isNotEmpty && !_isTechnical(matchedMsg)) {
      final cleaned =
          matchedMsg.replaceAll('"', '').replaceAll("'", '').trim();
      if (cleaned.isNotEmpty) return cleaned;
    }
  }

  if (_isTechnical(text)) return fallback;

  // 8. Strip brackets and normalise.
  text = text
      .replaceAll('{', '')
      .replaceAll('}', '')
      .replaceAll('[', '')
      .replaceAll(']', '')
      .replaceAll('"', '')
      .trim();

  if (text.toLowerCase() == 'invalid' ||
      text.toLowerCase() == 'invalid otp') {
    return 'Invalid OTP. Please try again.';
  }

  if (text.toLowerCase() == 'internal server error' ||
      text == '500' ||
      text == '400' ||
      text == '502' ||
      text == '504') {
    return fallback;
  }

  return text;
}

bool _isTechnical(String str) {
  if (str.startsWith('{') || str.startsWith('[')) {
    return true;
  }
  if (str.endsWith('}') || str.endsWith(']')) {
    return true;
  }
  if (str.contains('status:') ||
      str.contains('statusCode:') ||
      str.contains('status_code:')) {
    return true;
  }
  if (str.contains('<!DOCTYPE') || str.contains('<html')) {
    return true;
  }
  if (str.contains('DioException') ||
      str.contains('Stack trace:') ||
      str.contains('Exception:')) {
    return true;
  }
  return false;
}
