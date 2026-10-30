import 'package:shared_preferences/shared_preferences.dart';

/// All Apna Clinic AI SDK base config + relative paths.
///
/// Override with dart-defines (`AI_*` preferred, else `APNA_CLINIC_AI_*`).
/// Runtime testing can also override via [ApnaClinicAiConfig.applyOverrides].
class ApnaClinicAiUrls {
  ApnaClinicAiUrls._();

  // ---------------------------------------------------------------------------
  // Environment (read once via [ApnaClinicAiConfig.fromEnvironment])
  // ---------------------------------------------------------------------------

  static const _aiBase = String.fromEnvironment('AI_BASE_URL');
  static const _apnaBase = String.fromEnvironment(
    'APNA_CLINIC_AI_BASE_URL',
    defaultValue: 'https://jazzred-msa-stg.jazz.com.pk/ai-services/jimi',
  );
  static const _aiKey = String.fromEnvironment('AI_SDK_KEY');
  static const _apnaKey = String.fromEnvironment(
    'APNA_CLINIC_AI_SDK_KEY',
    defaultValue:
        'sdk_apnaclinic_icZZE-CHR5lm91Pyo8Rnfpe5iqrzBt7UIi_MRzvpTiU',
  );
  static const _tenantDefine = String.fromEnvironment(
    'AI_TENANT',
    defaultValue: 'apnaclinic',
  );

  static String get defaultBaseUrl {
    final ai = _aiBase.trim();
    return ai.isNotEmpty ? ai : _apnaBase;
  }

  static String get defaultSdkKey {
    final ai = _aiKey.trim();
    return ai.isNotEmpty ? ai : _apnaKey;
  }

  static String get defaultTenant {
    final tenant = _tenantDefine.trim();
    return tenant.isEmpty ? 'apnaclinic' : tenant;
  }

  /// Compile-time `AI_BASE_URL` (may be empty).
  static String get aiBaseDefine => _aiBase.trim();

  /// Compile-time `APNA_CLINIC_AI_BASE_URL` (has default).
  static String get apnaBaseDefine => _apnaBase.trim();

  /// Compile-time `AI_SDK_KEY` (may be empty).
  static String get aiKeyDefine => _aiKey.trim();

  /// Compile-time `APNA_CLINIC_AI_SDK_KEY` (has default).
  static String get apnaKeyDefine => _apnaKey.trim();

  // ---------------------------------------------------------------------------
  // SDK paths (relative to base URL)
  // ---------------------------------------------------------------------------

  static const sessionInit = '/api/v1/sdk/session/init';
  static const authToken = '/api/v1/sdk/auth/token';
  static const app = '/api/v1/sdk/app';
  static const assistantTurn = '/api/v1/sdk/assistant/turn/stream';
  static const assistantTurnStream = '/api/v1/sdk/assistant/turn/stream';
  static const assistantAudioStream = '/api/v1/sdk/assistant/turn/audio/stream';

  /// Joins [baseUrl] + [path], trimming trailing slashes on the base.
  static String resolve(String baseUrl, String path) {
    final base = baseUrl.trim().replaceAll(RegExp(r'/+$'), '');
    final normalized = path.startsWith('/') ? path : '/$path';
    return '$base$normalized';
  }
}

/// Injectable host + credentials for the AI SDK Dio client.
///
/// Mutable so a testing dialog can swap base URL / SDK key without a rebuild.
class ApnaClinicAiConfig {
  ApnaClinicAiConfig({
    required String baseUrl,
    required String sdkKey,
    this.tenant = 'apnaclinic',
  }) : _baseUrl = baseUrl.trim(),
       _sdkKey = sdkKey.trim();

  static const overrideBaseUrlKey = 'apna_clinic_ai.override_base_url';
  static const overrideSdkKeyKey = 'apna_clinic_ai.override_sdk_key';

  String _baseUrl;
  String _sdkKey;
  final String tenant;

  String get baseUrl => _baseUrl;
  String get sdkKey => _sdkKey;

  bool get isConfigured =>
      baseUrl.trim().isNotEmpty && sdkKey.trim().isNotEmpty;

  bool get hasRuntimeOverride =>
      _baseUrl != ApnaClinicAiUrls.defaultBaseUrl ||
      _sdkKey != ApnaClinicAiUrls.defaultSdkKey;

  String url(String path) => ApnaClinicAiUrls.resolve(baseUrl, path);

  void applyOverrides({required String baseUrl, required String sdkKey}) {
    _baseUrl = baseUrl.trim();
    _sdkKey = sdkKey.trim();
  }

  void resetToEnvironment() {
    _baseUrl = ApnaClinicAiUrls.defaultBaseUrl;
    _sdkKey = ApnaClinicAiUrls.defaultSdkKey;
  }

  Future<void> persistOverrides(SharedPreferences preferences) async {
    await preferences.setString(overrideBaseUrlKey, _baseUrl);
    await preferences.setString(overrideSdkKeyKey, _sdkKey);
  }

  Future<void> clearPersistedOverrides(SharedPreferences preferences) async {
    await preferences.remove(overrideBaseUrlKey);
    await preferences.remove(overrideSdkKeyKey);
  }

  void loadPersistedOverrides(SharedPreferences preferences) {
    final base = preferences.getString(overrideBaseUrlKey)?.trim() ?? '';
    final key = preferences.getString(overrideSdkKeyKey)?.trim() ?? '';
    if (base.isNotEmpty) _baseUrl = base;
    if (key.isNotEmpty) _sdkKey = key;
  }

  factory ApnaClinicAiConfig.fromEnvironment({
    SharedPreferences? preferences,
  }) {
    final config = ApnaClinicAiConfig(
      baseUrl: ApnaClinicAiUrls.defaultBaseUrl,
      sdkKey: ApnaClinicAiUrls.defaultSdkKey,
      tenant: ApnaClinicAiUrls.defaultTenant,
    );
    if (preferences != null) {
      config.loadPersistedOverrides(preferences);
    }
    return config;
  }
}
