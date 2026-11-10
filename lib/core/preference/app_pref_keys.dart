import '../di/dependency_injection.dart';
import '../services/encryption_service.dart';

class AppPrefKeys {
  AppPrefKeys._();

  static final _encryption = sl<EncryptionService>();
  static String get _prefVersion => _encryption.obfuscateKey("app_pref_v1");

  static String get token =>
      _encryption.obfuscateKey('auth_token$_prefVersion');
  static String get refreshToken =>
      _encryption.obfuscateKey('refresh_token$_prefVersion');
  static String get accessTokenExpiresIn =>
      _encryption.obfuscateKey('access_token_expires_in$_prefVersion');
  static String get refreshTokenExpiresIn =>
      _encryption.obfuscateKey('refresh_token_expires_in$_prefVersion');
  static String get userId => _encryption.obfuscateKey('user_id$_prefVersion');
  static String get loginStatus =>
      _encryption.obfuscateKey('login_status$_prefVersion');
  static String get themeMode =>
      _encryption.obfuscateKey('theme_mode$_prefVersion');
  static String get locale =>
      _encryption.obfuscateKey('app_locale$_prefVersion');
  static String get onboardingCompleted =>
      _encryption.obfuscateKey('onboarding_completed$_prefVersion');
  static String get firstTime =>
      _encryption.obfuscateKey('first_time$_prefVersion');
  static String get profileCompleted =>
      _encryption.obfuscateKey('profile_completed$_prefVersion');
  static String get userLocal =>
      _encryption.obfuscateKey('user_local$_prefVersion');
  static String get encryptionEnabled =>
      _encryption.obfuscateKey('encryption_enabled$_prefVersion');
  static String get encryptionKey =>
      _encryption.obfuscateKey('encryption_key$_prefVersion');
  static String get encryptionIV =>
      _encryption.obfuscateKey('encryption_iv$_prefVersion');
  static String get fcmToken =>
      _encryption.obfuscateKey('fcm_token$_prefVersion');
  static String get fcmTokenSentToBackend =>
      _encryption.obfuscateKey('fcm_token_sent$_prefVersion');
  static String get labTestSelectedCity =>
      _encryption.obfuscateKey('lab_test_selected_city$_prefVersion');
  static String get surgerySelectedCity =>
      _encryption.obfuscateKey('surgery_selected_city$_prefVersion');
  /// Pharmacy delivery city `{ id, name, partner }` — kept across logout.
  static String get pharmacyCity =>
      _encryption.obfuscateKey('pharmacy_city$_prefVersion');
  static String get supportSettings =>
      _encryption.obfuscateKey('support_settings$_prefVersion');

  /// Apna Clinic AI (Care Companion) SDK session — cleared on logout.
  static String get apnaClinicAiApiKey =>
      _encryption.obfuscateKey('apna_clinic_ai_api_key$_prefVersion');
  static String get apnaClinicAiSessionId =>
      _encryption.obfuscateKey('apna_clinic_ai_session_id$_prefVersion');
  static String get apnaClinicAiUserId =>
      _encryption.obfuscateKey('apna_clinic_ai_user_id$_prefVersion');
  static String get apnaClinicAiAccessToken =>
      _encryption.obfuscateKey('apna_clinic_ai_access_token$_prefVersion');
  static String get apnaClinicAiTokenExpiresAt =>
      _encryption.obfuscateKey('apna_clinic_ai_token_expires_at$_prefVersion');
  static String get apnaClinicAiAuthMode =>
      _encryption.obfuscateKey('apna_clinic_ai_auth_mode$_prefVersion');
  static String get apnaClinicAiConversationId =>
      _encryption.obfuscateKey('apna_clinic_ai_conversation_id$_prefVersion');

  /// Last thread the user actually sent on. Continue / Resume reads this.
  /// A new window's unused id must not overwrite it.
  static String get apnaClinicAiHistoryConversationId =>
      _encryption.obfuscateKey(
        'apna_clinic_ai_history_conversation_id$_prefVersion',
      );
}
