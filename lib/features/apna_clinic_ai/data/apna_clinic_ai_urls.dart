/// All Apna Clinic AI SDK base config + relative paths.
///
/// Override with dart-defines (`AI_*` preferred, else `APNA_CLINIC_AI_*`).
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

  // ---------------------------------------------------------------------------
  // SDK paths (relative to base URL)
  // ---------------------------------------------------------------------------

  static const sessionInit = '/api/v1/sdk/session/init';
  static const authToken = '/api/v1/sdk/auth/token';
  static const app = '/api/v1/sdk/app';
  static const assistantTurn = '/api/v1/sdk/assistant/turn';
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
class ApnaClinicAiConfig {
  const ApnaClinicAiConfig({
    required this.baseUrl,
    required this.sdkKey,
    this.tenant = 'apnaclinic',
  });

  final String baseUrl;
  final String sdkKey;
  final String tenant;

  bool get isConfigured =>
      baseUrl.trim().isNotEmpty && sdkKey.trim().isNotEmpty;

  String url(String path) => ApnaClinicAiUrls.resolve(baseUrl, path);

  factory ApnaClinicAiConfig.fromEnvironment() {
    return ApnaClinicAiConfig(
      baseUrl: ApnaClinicAiUrls.defaultBaseUrl,
      sdkKey: ApnaClinicAiUrls.defaultSdkKey,
      tenant: ApnaClinicAiUrls.defaultTenant,
    );
  }
}
