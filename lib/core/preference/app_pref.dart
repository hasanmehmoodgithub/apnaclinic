import 'support_settings_local_model.dart';
import 'user_local_model.dart';

abstract class AppPref {
  // ==================== Authentication ====================

  Future<bool> setToken(String token, {String? defaultValue});
  String getToken();

  Future<bool> setRefreshToken(String token, {String? defaultValue});
  String getRefreshToken();

  Future<bool> setAccessTokenExpiresIn(int milliseconds, {int? defaultValue});
  int getAccessTokenExpiresIn();

  Future<bool> setRefreshTokenExpiresIn(int milliseconds, {int? defaultValue});
  int getRefreshTokenExpiresIn();

  Future<bool> setUserId(String userId, {String? defaultValue});
  String getUserId();

  Future<bool> setLoginStatus(bool isLoggedIn, {bool? defaultValue});
  bool getLoginStatus();

  // ==================== Theme ====================

  Future<bool> setThemeMode(
    String themeMode, {
    String? defaultValue,
  }); // 'light', 'dark', 'system'
  String getThemeMode(); // Default: 'system'

  // ==================== Localization ====================

  Future<bool> setLocale(String localeCode, {String? defaultValue});
  String getLocale(); // Default: 'en'

  // ==================== Onboarding ====================

  Future<bool> setOnboardingCompleted(bool completed, {bool? defaultValue});
  bool isOnboardingCompleted(); // Default: false

  /// Device-first-launch flag. Default `true` until first-install analytics runs.
  /// Not cleared on logout.
  Future<bool> setFirstTime(bool firstTime, {bool? defaultValue});
  bool isFirstTime();

  // ==================== Profile ====================

  Future<bool> setProfileCompleted(bool completed, {bool? defaultValue});
  bool isProfileCompleted(); // Default: false
  Future<bool> setUserLocalModel(UserLocalModel model);
  UserLocalModel? getUserLocalModel();
  Future<bool> clearUserLocalModel();

  // ==================== Support settings (CMS) ====================

  Future<bool> setSupportSettings(SupportSettingsLocalModel model);
  SupportSettingsLocalModel? getSupportSettings();

  // ==================== Apna Clinic AI SDK session ====================

  Future<bool> setApnaClinicAiApiKey(String value);
  String getApnaClinicAiApiKey();

  Future<bool> setApnaClinicAiSessionId(String value);
  String getApnaClinicAiSessionId();

  Future<bool> setApnaClinicAiUserId(String value);
  String getApnaClinicAiUserId();

  Future<bool> setApnaClinicAiAccessToken(String value);
  String getApnaClinicAiAccessToken();

  Future<bool> setApnaClinicAiTokenExpiresAt(int millis);
  int getApnaClinicAiTokenExpiresAt();

  Future<bool> setApnaClinicAiAuthMode(String mode);
  String getApnaClinicAiAuthMode();

  Future<bool> setApnaClinicAiConversationId(String value);
  String getApnaClinicAiConversationId();

  /// Thread id for Continue / Resume. Not replaced until a turn is sent.
  Future<bool> setApnaClinicAiHistoryConversationId(String value);
  String getApnaClinicAiHistoryConversationId();

  /// Clears Care Companion SDK credentials (guest + signed-in) and conversation id.
  Future<void> clearApnaClinicAiSession();

  // ==================== Generic Methods ====================

  Future<bool> setString(String key, String value, {String? defaultValue});
  String? getString(String key);

  Future<bool> setInt(String key, int value, {int? defaultValue});
  int? getInt(String key);

  Future<bool> setDouble(String key, double value, {double? defaultValue});
  double? getDouble(String key);

  Future<bool> setBool(String key, bool value, {bool? defaultValue});
  bool? getBool(String key);

  Future<bool> setStringList(
    String key,
    List<String> value, {
    List<String>? defaultValue,
  });
  List<String>? getStringList(String key);

  // ==================== Encryption ====================

  // ==================== Utility ====================

  Future<bool> remove(String key);
  Future<bool> clear();
}
