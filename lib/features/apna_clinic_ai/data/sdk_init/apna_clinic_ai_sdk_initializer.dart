import '../../domain/apna_clinic_ai_failure_codes.dart';
import '../apna_clinic_ai_urls.dart';
import '../data_sources/apna_clinic_ai_sdk_client.dart';
import '../models/apna_clinic_ai_session_model.dart';
import 'apna_clinic_ai_sdk_auth_context.dart';
import 'apna_clinic_ai_sdk_auth_resolver.dart';
import 'apna_clinic_ai_sdk_branding.dart';
import 'apna_clinic_ai_sdk_greeting.dart';

export 'apna_clinic_ai_sdk_auth_context.dart';
export 'apna_clinic_ai_sdk_auth_resolver.dart';
export 'apna_clinic_ai_sdk_branding.dart';
export 'apna_clinic_ai_sdk_greeting.dart';

/// Boots the Apna Clinic AI SDK for a feature open.
///
/// ## How to call
///
/// **In this app (preferred):** do not call this from UI. Use the cubit:
/// ```dart
/// await cubit.connect(); // reuse prefs session; token refresh only
/// await cubit.connect(forceRefresh: true); // cold start / login / Retry
/// // → EnsureApnaClinicAiSessionUseCase
/// // → ApnaClinicAiRepository.ensureSession
/// // → ApnaClinicAiSdkInitializer.initialize
/// ```
///
/// **When `POST /sdk/session/init` runs:** cold app start, logout (no prefs),
/// login / guest↔signed-in mismatch, or explicit [forceRefresh]. Opening the
/// feature again in the same process reuses the cached session.
///
/// **Direct / DI (integration / tests):**
/// ```dart
/// final initializer = sl<ApnaClinicAiSdkInitializer>();
/// if (!initializer.isConfigured) { /* show not-configured */ }
/// final session = await initializer.initialize(forceRefresh: false);
/// // session.welcomeMessage / greetingAudioBase64 / suggestions …
/// ```
///
/// **Steps inside [initialize]:**
/// 1. [ensureConfigured] — `AI_*` / `APNA_CLINIC_AI_*` dart-defines
/// 2. [resolveAuth] — guest vs signed-in ([ApnaClinicAiSdkAuthResolver])
/// 3. [ensureSdkSession] — `POST /sdk/session/init` **or** token refresh only
/// 4. [loadGreeting] — cached `apna_clinic_ai_session_init.json` (or fresh init)
/// 5. [loadBranding] — `GET /sdk/app`
/// 6. Assemble [ApnaClinicAiSessionModel]
///
/// Prefer this over calling [ApnaClinicAiSdkClient] init helpers directly.
class ApnaClinicAiSdkInitializer {
  ApnaClinicAiSdkInitializer({
    required ApnaClinicAiConfig config,
    required ApnaClinicAiSdkClient client,
    required ApnaClinicAiSdkAuthResolver authResolver,
  }) : _config = config,
       _client = client,
       _authResolver = authResolver;

  final ApnaClinicAiConfig _config;
  final ApnaClinicAiSdkClient _client;
  final ApnaClinicAiSdkAuthResolver _authResolver;

  bool get isConfigured => _config.isConfigured;

  /// Full SDK session boot. Throws [ApnaClinicAiSdkException] on failure.
  Future<ApnaClinicAiSessionModel> initialize({
    bool forceRefresh = false,
  }) async {
    ensureConfigured();
    final auth = await resolveAuth();
    final initData = await ensureSdkSession(
      auth: auth,
      forceRefresh: forceRefresh,
    );
    final greeting = await loadGreeting(freshInit: initData);
    final branding = await loadBranding(fallbackWelcome: greeting.message);
    return _toSessionModel(greeting: greeting, branding: branding);
  }

  /// Step 1 — dart-defines present.
  void ensureConfigured() {
    if (!isConfigured) {
      throw const ApnaClinicAiSdkException(
        ApnaClinicAiFailureCodes.notConfigured,
      );
    }
  }

  /// Step 2 — guest / signed-in context from [AppPref].
  Future<ApnaClinicAiSdkAuthContext> resolveAuth() => _authResolver.resolve();

  /// Step 3 — clear/hydrate prefs, init or refresh token.
  ///
  /// Returns the fresh init JSON when `session/init` ran; otherwise `null`.
  Future<Map<String, dynamic>?> ensureSdkSession({
    required ApnaClinicAiSdkAuthContext auth,
    bool forceRefresh = false,
  }) async {
    if (forceRefresh) {
      // Keep conversation history for Continue; drop SDK tokens so init runs.
      await _client.clearSession();
    } else {
      _client.hydrateFromPrefs();
    }

    final modeChanged =
        _client.hasSession &&
        _client.authMode.isNotEmpty &&
        _client.authMode != auth.mode;
    if (modeChanged) {
      await _client.clearSession();
    }

    if (forceRefresh || !_client.hasSession) {
      return _client.initSession(
        mode: auth.mode,
        deviceId: auth.deviceId,
        msisdn: auth.msisdn,
        name: auth.name,
        email: auth.email,
      );
    }

    await _client.ensureToken();
    return null;
  }

  /// Step 4 — greeting + audio from init file (preferred) or [freshInit].
  Future<ApnaClinicAiSdkGreeting> loadGreeting({
    Map<String, dynamic>? freshInit,
  }) async {
    final cached = await _client.readInitResponse();
    return ApnaClinicAiSdkGreeting.fromInitMap(cached ?? freshInit);
  }

  /// Step 5 — assistant name, chips, voice flags from `/sdk/app`.
  Future<ApnaClinicAiSdkBranding> loadBranding({
    String fallbackWelcome = '',
  }) async {
    try {
      final app = await _client.fetchApp() ?? const <String, dynamic>{};
      return ApnaClinicAiSdkBranding.fromAppMap(
        app,
        fallbackWelcome: fallbackWelcome,
      );
    } catch (_) {
      return ApnaClinicAiSdkBranding(welcomeMessage: fallbackWelcome);
    }
  }

  ApnaClinicAiSessionModel _toSessionModel({
    required ApnaClinicAiSdkGreeting greeting,
    required ApnaClinicAiSdkBranding branding,
  }) {
    final sessionId = _client.sessionId;
    if (sessionId == null || sessionId.isEmpty) {
      throw const ApnaClinicAiSdkException(
        ApnaClinicAiFailureCodes.connectFailed,
      );
    }

    return ApnaClinicAiSessionModel(
      sessionId: sessionId,
      conversationId: _client.conversationId,
      isGuest: _client.isGuest,
      assistantName: branding.assistantName,
      suggestions: branding.suggestions,
      welcomeMessage: branding.welcomeMessage.isNotEmpty
          ? branding.welcomeMessage
          : greeting.message,
      greetingAudioBase64: greeting.audioBase64,
      greetingAudioMediaType: greeting.audioMediaType,
      composerHint: branding.composerHint,
      headerSubtitle: branding.headerSubtitle,
      voiceEnabled: branding.voiceEnabled,
      voiceOutputEnabled: branding.voiceOutputEnabled,
    );
  }
}
