/// Single source of truth for emoji removal.
///
/// Previously copy-pasted as a local variable in 15+ files.
/// Import this file once and call [removeEmojis].
library;

// ignore_for_file: non_constant_identifier_names

/// Removes all emoji and special Unicode characters from [input].
///
/// Returns the cleaned string. Safe to call on empty / null strings.
String removeEmojis(String input) {
  if (input.isEmpty) return input;
  return input.replaceAll(_emojiRegex, '').trim();
}

final RegExp _emojiRegex = RegExp(
  r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]'
  r'|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff]'
  r'|[\u2702-\u27B0]|[\u24C2-\uFFFD]'
  r'|\uD83C[\uDC00-\uDFFF]|\uD83D[\uDC00-\uDE4F]'
  r'|\uD83D[\uDE80-\uDEFF]|[\u2600-\u2B55]'
  r'|\u200d|[\u23cf]|[\u23e9]|[\u231a]'
  r'|[\ufe00-\ufe0f]|\u3030|\u2764'
  r'|[\u{1F004}-\u{1F9FF}])',
  unicode: true,
);
