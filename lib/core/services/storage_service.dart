import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Secure storage service for JigroPay.
///
/// - **Sensitive** data (auth tokens, member ID) → [FlutterSecureStorage]
///   (encrypted Keychain on iOS, EncryptedSharedPreferences on Android)
/// - **Non-sensitive** UI prefs (onboarding shown, dark mode) → [SharedPreferences]
///
/// Replaces [SpUtil] and removes direct token access via a global `sp` variable.
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  late final FlutterSecureStorage _secure;
  late final SharedPreferences _prefs;

  // ── Key constants ─────────────────────────────────────────────────────────────
  static const String _keyAccessToken = 'access_token';
  static const String _keyMemberToken = 'member_token';
  static const String _keyMemberId = 'member_id';
  static const String _keyFcmToken = 'fcm_token';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyIsSliderShown = 'IS_SLIDER';
  static const String _keyDarkMode = 'dark';
  static const String _keyUserName = 'userName';

  // ── Initialization ────────────────────────────────────────────────────────────

  /// Must be called once in [main()] before [runApp].
  static Future<void> init() async {
    instance._secure = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        resetOnError: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ),
    );
    instance._prefs = await SharedPreferences.getInstance();
  }

  // ── Auth Tokens (Secure) ──────────────────────────────────────────────────────

  Future<String?> getAccessToken() => _secure.read(key: _keyAccessToken);
  Future<void> setAccessToken(String token) =>
      _secure.write(key: _keyAccessToken, value: token);

  Future<String?> getMemberToken() => _secure.read(key: _keyMemberToken);
  Future<void> setMemberToken(String token) =>
      _secure.write(key: _keyMemberToken, value: token);

  Future<String?> getMemberId() => _secure.read(key: _keyMemberId);
  Future<void> setMemberId(String id) =>
      _secure.write(key: _keyMemberId, value: id);

  Future<String?> getFcmToken() => _secure.read(key: _keyFcmToken);
  Future<void> setFcmToken(String token) =>
      _secure.write(key: _keyFcmToken, value: token);

  // ── Session flags ─────────────────────────────────────────────────────────────

  bool get isLoggedIn => _prefs.getBool(_keyIsLoggedIn) ?? false;
  Future<void> setLoggedIn({required bool value}) =>
      _prefs.setBool(_keyIsLoggedIn, value);

  bool get isOnboardingShown => _prefs.getBool(_keyIsSliderShown) ?? false;
  Future<void> setOnboardingShown() =>
      _prefs.setBool(_keyIsSliderShown, true);

  // ── Non-sensitive UI Prefs ────────────────────────────────────────────────────

  bool get isDarkMode => _prefs.getBool(_keyDarkMode) ?? false;
  Future<void> setDarkMode({required bool value}) =>
      _prefs.setBool(_keyDarkMode, value);

  String? get userName => _prefs.getString(_keyUserName);
  Future<void> setUserName(String name) =>
      _prefs.setString(_keyUserName, name);

  // ── Logout cleanup ────────────────────────────────────────────────────────────

  /// Clears all sensitive keys on logout. Preserves non-sensitive UI prefs.
  Future<void> clearOnLogout() async {
    await Future.wait([
      _secure.delete(key: _keyAccessToken),
      _secure.delete(key: _keyMemberToken),
      _secure.delete(key: _keyMemberId),
      _prefs.remove(_keyIsLoggedIn),
      _prefs.remove(_keyUserName),
    ]);
  }

  /// Nuclear option — clears everything (e.g. account deletion).
  Future<void> clearAll() async {
    await _secure.deleteAll();
    await _prefs.clear();
  }
}
