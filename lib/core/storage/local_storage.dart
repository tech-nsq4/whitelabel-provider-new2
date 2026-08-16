import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorage {
  LocalStorage()
      : _box = GetStorage(),
        _secureBox = const FlutterSecureStorage();

  final GetStorage _box;
  final FlutterSecureStorage _secureBox;

  // ─── Generic typed methods ────────────────────────────────────────────────
  T? read<T>(String key) => _box.read<T>(key);
  Future<void> write<T>(String key, T value) => _box.write(key, value);
  Future<void> remove(String key) => _box.remove(key);
  bool has(String key) => _box.hasData(key);

  Future<void> clearAll() async {
    await _secureBox.delete(key: _tokenKey);
    await _box.erase();
  }

  // ─── Auth ─────────────────────────────────────────────────────────────────
  // The token is the one secret worth protecting from a rooted/jailbroken
  // device or a plain file-system backup, so it lives in the platform
  // keystore (Keychain on iOS, EncryptedSharedPreferences/Keystore on
  // Android) instead of GetStorage's plaintext JSON file. `_hasTokenKey`
  // mirrors "is a token set" in GetStorage so `isLoggedIn` can stay a cheap
  // synchronous getter for widgets/router that need it at build time.
  static const _tokenKey = 'token';
  static const _hasTokenKey = 'has_token';
  static const _userKey = 'user';

  Future<String?> getToken() => _secureBox.read(key: _tokenKey);

  Future<void> setToken(String v) async {
    await _secureBox.write(key: _tokenKey, value: v);
    await write(_hasTokenKey, true);
  }

  Future<void> removeToken() async {
    await _secureBox.delete(key: _tokenKey);
    await remove(_hasTokenKey);
  }

  Map<String, dynamic>? getUser() => read<Map<String, dynamic>>(_userKey);
  Future<void> setUser(Map<String, dynamic> user) => write(_userKey, user);

  bool get isLoggedIn => read<bool>(_hasTokenKey) ?? false;

  // ─── Onboarding ───────────────────────────────────────────────────────────
  static const _onboardingSeenKey = 'onboarding_seen';

  bool get isOnboardingSeen => read<bool>(_onboardingSeenKey) ?? false;
  Future<void> setOnboardingSeen() => write(_onboardingSeenKey, true);

  // ─── Settings ─────────────────────────────────────────────────────────────
  static const _langKey = 'lang';

  String getLang() => read<String>(_langKey) ?? 'ar';
  Future<void> setLang(String lang) => write(_langKey, lang);

  // ─── Consultation drafts ────────────────────────────────────────────────
  static const _consultationDraftsKey = 'consultation_drafts';

  Map<String, dynamic> _consultationDrafts() =>
      read<Map>(_consultationDraftsKey)?.cast<String, dynamic>() ?? {};

  Map<String, dynamic>? getConsultationDraft(String appointmentId) {
    final draft = _consultationDrafts()[appointmentId];
    return draft == null ? null : (draft as Map).cast<String, dynamic>();
  }

  Future<void> saveConsultationDraft(
      String appointmentId, Map<String, dynamic> draft) async {
    final drafts = _consultationDrafts();
    drafts[appointmentId] = draft;
    await write(_consultationDraftsKey, drafts);
  }

  Future<void> removeConsultationDraft(String appointmentId) async {
    final drafts = _consultationDrafts();
    drafts.remove(appointmentId);
    await write(_consultationDraftsKey, drafts);
  }
}
