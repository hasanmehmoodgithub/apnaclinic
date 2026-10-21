import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../../core/preference/app_pref.dart';
import '../../domain/apna_clinic_ai_failure_codes.dart';

class ApnaClinicAiSdkException implements Exception {
  const ApnaClinicAiSdkException(this.code);

  final String code;
}

/// SDK host config. Pass both with `--dart-define`. Do not commit the key.
class ApnaClinicAiConfig {
  const ApnaClinicAiConfig({required this.baseUrl, required this.sdkKey});

  final String baseUrl;
  final String sdkKey;

  bool get isConfigured =>
      baseUrl.trim().isNotEmpty && sdkKey.trim().isNotEmpty;

  factory ApnaClinicAiConfig.fromEnvironment() {
    // Temporary defaults for local/dev. Prefer --dart-define when available.
    const baseUrl = String.fromEnvironment(
      'APNA_CLINIC_AI_BASE_URL',
      defaultValue: 'https://522b-119-160-81-47.ngrok-free.app',
    );
    const sdkKey = String.fromEnvironment(
      'APNA_CLINIC_AI_SDK_KEY',
      defaultValue:
          'sdk_apnaclinic_h2A7VpAjpEMHMEC_OBC4MlOjHrLiyTEPrXRDoIMWlIo',
    );
    return const ApnaClinicAiConfig(baseUrl: baseUrl, sdkKey: sdkKey);
  }
}

/// Dedicated Dio client. Clinic [ApiService] auth and HMAC must not apply here.
class ApnaClinicAiSdkClient {
  ApnaClinicAiSdkClient({
    required ApnaClinicAiConfig config,
    required AppPref appPref,
    Dio? dio,
  }) : _config = config,
       _appPref = appPref,
       _dio =
           dio ??
           Dio(
             BaseOptions(
               connectTimeout: const Duration(seconds: 60),
               receiveTimeout: const Duration(seconds: 90),
               sendTimeout: const Duration(seconds: 60),
               headers: const {
                 'Accept': 'application/json',
                 'ngrok-skip-browser-warning': 'true',
               },
             ),
           );

  final ApnaClinicAiConfig _config;
  final AppPref _appPref;
  final Dio _dio;

  String? apiKey;
  String? accessToken;
  String? userId;
  DateTime expiresAt = DateTime.fromMillisecondsSinceEpoch(0);
  String? sessionId;
  String conversationId = '';
  bool isGuest = true;
  String authMode = 'guest';

  bool get hasSession =>
      apiKey != null &&
      apiKey!.isNotEmpty &&
      sessionId != null &&
      sessionId!.isNotEmpty &&
      accessToken != null &&
      accessToken!.isNotEmpty;

  /// Creates a new chat thread id (New chat / any non-resume start).
  Future<void> newConversation() async {
    conversationId = _newId('ac');
    await _appPref.setApnaClinicAiConversationId(conversationId);
  }

  /// Re-binds a prior thread (Continue / Resume). No-op id → [newConversation].
  Future<void> restoreConversation(String id) async {
    final trimmed = id.trim();
    if (trimmed.isEmpty) {
      await newConversation();
      return;
    }
    conversationId = trimmed;
    await _appPref.setApnaClinicAiConversationId(conversationId);
  }

  /// Drops the in-memory thread without wiping prefs (needed for Continue).
  void detachConversation() {
    conversationId = '';
  }

  /// Last persisted thread id (for Continue / Resume on a new window).
  String peekPersistedConversationId() =>
      _appPref.getApnaClinicAiConversationId().trim();

  /// Stable id for the bound chat — creates one only if nothing is bound yet.
  Future<String> ensureConversationId() async {
    if (conversationId.isNotEmpty) return conversationId;
    await newConversation();
    return conversationId;
  }

  /// Loads cached SDK credentials from [AppPref] into memory.
  /// Does **not** auto-bind [conversationId] — cubit chooses resume vs new.
  void hydrateFromPrefs() {
    final key = _appPref.getApnaClinicAiApiKey();
    final session = _appPref.getApnaClinicAiSessionId();
    final token = _appPref.getApnaClinicAiAccessToken();
    final uid = _appPref.getApnaClinicAiUserId();
    final mode = _appPref.getApnaClinicAiAuthMode();
    final expiresMillis = _appPref.getApnaClinicAiTokenExpiresAt();
    if (key.isEmpty || session.isEmpty || token.isEmpty) return;
    apiKey = key;
    sessionId = session;
    accessToken = token;
    userId = uid.isEmpty ? null : uid;
    authMode = mode.isEmpty ? 'guest' : mode;
    isGuest = authMode != 'signed_in';
    if (expiresMillis > 0) {
      expiresAt = DateTime.fromMillisecondsSinceEpoch(expiresMillis);
    }
  }

  /// Clears SDK auth tokens only. Keeps a bound [conversationId] so a
  /// guest→signed-in re-init mid-chat (cart confirm / resume) stays on the
  /// same thread. If memory was [detachConversation]’d, prefs stay for Continue
  /// but memory stays empty until restore/new.
  Future<void> clearSession({bool clearConversation = false}) async {
    final boundId = conversationId.trim();
    final prefsId = _appPref.getApnaClinicAiConversationId().trim();
    final keepId = boundId.isNotEmpty ? boundId : prefsId;
    apiKey = null;
    accessToken = null;
    userId = null;
    sessionId = null;
    expiresAt = DateTime.fromMillisecondsSinceEpoch(0);
    isGuest = true;
    authMode = 'guest';
    await _appPref.clearApnaClinicAiSession();
    if (clearConversation) {
      conversationId = '';
      return;
    }
    if (keepId.isNotEmpty) {
      await _appPref.setApnaClinicAiConversationId(keepId);
    }
    // Only keep memory bound when it was already bound before clear.
    conversationId = boundId;
  }

  Future<void> ping() async {
    _requireConfig();
    await _send('GET', '/api/v1/sdk/ping');
  }

  /// Guest: `{ mode, device_id }` only.
  /// Signed-in: `{ mode, device_id, msisdn, name?, email? }`.
  Future<Map<String, dynamic>> initSession({
    required String mode,
    required String deviceId,
    String? msisdn,
    String? name,
    String? email,
  }) async {
    _requireConfig();
    final body = <String, dynamic>{
      'mode': mode,
      'device_id': deviceId,
    };
    if (mode == 'signed_in') {
      if (msisdn != null && msisdn.isNotEmpty) body['msisdn'] = msisdn;
      if (name != null && name.isNotEmpty) body['name'] = name;
      if (email != null && email.isNotEmpty) body['email'] = email;
    }

    final data = await _send(
      'POST',
      '/api/v1/sdk/session/init',
      body: body,
    );
    await _applySessionResponse(data, mode: mode);
    return data;
  }

  Future<void> ensureToken() async {
    if (!hasSession) hydrateFromPrefs();
    if (accessToken != null &&
        DateTime.now().isBefore(
          expiresAt.subtract(const Duration(seconds: 30)),
        )) {
      return;
    }
    if (apiKey == null || apiKey!.isEmpty) {
      throw const ApnaClinicAiSdkException(
        ApnaClinicAiFailureCodes.connectFailed,
      );
    }
    final data = await _send(
      'POST',
      '/api/v1/sdk/auth/token',
      body: {'api_key': apiKey},
    );
    final token = data['access_token']?.toString();
    if (token == null || token.isEmpty) {
      throw const ApnaClinicAiSdkException(
        ApnaClinicAiFailureCodes.connectFailed,
      );
    }
    accessToken = token;
    final expiresIn = data['expires_in'];
    final seconds = expiresIn is num ? expiresIn.toInt() : 900;
    expiresAt = DateTime.now().add(Duration(seconds: seconds));
    await _appPref.setApnaClinicAiAccessToken(token);
    await _appPref.setApnaClinicAiTokenExpiresAt(
      expiresAt.millisecondsSinceEpoch,
    );
  }

  Future<Map<String, dynamic>?> fetchApp() async {
    await ensureToken();
    return _send('GET', '/api/v1/sdk/app', authorize: true);
  }

  Future<Map<String, dynamic>> fetchHome() async {
    await ensureToken();
    return _send(
      'POST',
      '/api/v1/sdk/home',
      body: {'api_key': apiKey},
      authorize: true,
    );
  }

  Future<Map<String, dynamic>> postTurn(Map<String, dynamic> body) async {
    await ensureToken();
    return _send(
      'POST',
      '/api/v1/sdk/assistant/turn',
      body: body,
      authorize: true,
    );
  }

  Future<Stream<Uint8List>> postTurnStream(Map<String, dynamic> body) async {
    await ensureToken();
    return _openStream('/api/v1/sdk/assistant/turn/stream', body);
  }

  Future<void> _applySessionResponse(
    Map<String, dynamic> data, {
    required String mode,
  }) async {
    apiKey = data['api_key']?.toString();
    accessToken = data['access_token']?.toString();
    sessionId = data['session_id']?.toString();
    userId = data['user_id']?.toString();
    authMode = mode;
    isGuest = mode != 'signed_in';
    final auth = data['auth'];
    if (auth is Map && auth['guest'] is bool) {
      isGuest = auth['guest'] as bool;
    }
    final expiresIn = data['expires_in'];
    final seconds = expiresIn is num ? expiresIn.toInt() : 900;
    expiresAt = DateTime.now().add(Duration(seconds: seconds));
    if (apiKey == null || accessToken == null || sessionId == null) {
      throw const ApnaClinicAiSdkException(
        ApnaClinicAiFailureCodes.connectFailed,
      );
    }
    await _persistSession();
  }

  Future<void> _persistSession() async {
    await _appPref.setApnaClinicAiApiKey(apiKey ?? '');
    await _appPref.setApnaClinicAiSessionId(sessionId ?? '');
    await _appPref.setApnaClinicAiUserId(userId ?? '');
    await _appPref.setApnaClinicAiAccessToken(accessToken ?? '');
    await _appPref.setApnaClinicAiTokenExpiresAt(
      expiresAt.millisecondsSinceEpoch,
    );
    await _appPref.setApnaClinicAiAuthMode(authMode);
  }

  Future<Map<String, dynamic>> _send(
    String method,
    String path, {
    Map<String, dynamic>? body,
    bool authorize = false,
  }) async {
    try {
      final response = await _dio.request<dynamic>(
        _url(path),
        data: body,
        options: Options(
          method: method,
          headers: _headers(json: body != null, authorize: authorize),
          responseType: ResponseType.json,
        ),
      );
      final data = response.data;
      if (data is Map<String, dynamic>) return data;
      if (data is Map) return Map<String, dynamic>.from(data);
      return const {};
    } on DioException catch (error) {
      throw _mapDio(error);
    }
  }

  Future<Stream<Uint8List>> _openStream(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _dio.post<ResponseBody>(
        _url(path),
        data: body,
        options: Options(
          headers: _headers(json: true, authorize: true, sse: true),
          responseType: ResponseType.stream,
        ),
      );
      final stream = response.data?.stream;
      if (stream == null) {
        throw const ApnaClinicAiSdkException(
          ApnaClinicAiFailureCodes.connectFailed,
        );
      }
      return stream;
    } on DioException catch (error) {
      throw _mapDio(error);
    }
  }

  Map<String, dynamic> _headers({
    required bool json,
    required bool authorize,
    bool sse = false,
  }) {
    final loginToken = _appPref.getToken().trim();
    return {
      'X-SDK-Key': _config.sdkKey.trim(),
      'ngrok-skip-browser-warning': 'true',
      if (json) 'Content-Type': 'application/json',
      'Accept': sse ? 'text/event-stream' : 'application/json',
      if (authorize && accessToken != null)
        'Authorization': 'Bearer $accessToken',
      // Apna Clinic app JWT (signed-in); omitted for guests.
      if (loginToken.isNotEmpty)
        'X-User-Token': loginToken.toLowerCase().startsWith('bearer ')
            ? loginToken
            : 'Bearer $loginToken',
    };
  }

  String _url(String path) {
    final base = _config.baseUrl.trim().replaceAll(RegExp(r'/+$'), '');
    return '$base$path';
  }

  void _requireConfig() {
    if (!_config.isConfigured) {
      throw const ApnaClinicAiSdkException(
        ApnaClinicAiFailureCodes.notConfigured,
      );
    }
  }

  ApnaClinicAiSdkException _mapDio(DioException error) {
    final data = error.response?.data;
    var detail = '';
    if (data is Map) {
      detail = (data['detail'] ?? data['message'] ?? '').toString();
    } else if (data is String) {
      detail = data;
    }
    if (RegExp(r'502|504|upstream', caseSensitive: false).hasMatch(detail)) {
      return const ApnaClinicAiSdkException(ApnaClinicAiFailureCodes.upstream);
    }
    return const ApnaClinicAiSdkException(
      ApnaClinicAiFailureCodes.connectFailed,
    );
  }
}

Stream<Map<String, dynamic>> parseApnaClinicAiSse(
  Stream<Uint8List> bytes,
) async* {
  final pending = StringBuffer();
  await for (final chunk in bytes) {
    pending.write(utf8.decode(chunk, allowMalformed: true));
    var text = pending.toString();
    while (true) {
      final split = text.indexOf('\n\n');
      if (split < 0) break;
      final frame = text.substring(0, split);
      text = text.substring(split + 2);
      String? dataLine;
      for (final line in frame.split('\n')) {
        if (line.startsWith('data: ')) {
          dataLine = line.substring(6);
          break;
        }
      }
      if (dataLine == null || dataLine.isEmpty) continue;
      try {
        final decoded = jsonDecode(dataLine);
        if (decoded is Map<String, dynamic>) {
          yield decoded;
        } else if (decoded is Map) {
          yield Map<String, dynamic>.from(decoded);
        }
      } catch (_) {}
    }
    pending
      ..clear()
      ..write(text);
  }
}

String _newId(String prefix) {
  final random = Random.secure();
  final body = List<int>.generate(12, (_) => random.nextInt(256))
      .map((b) => b.toRadixString(16).padLeft(2, '0'))
      .join();
  return '$prefix-$body';
}
