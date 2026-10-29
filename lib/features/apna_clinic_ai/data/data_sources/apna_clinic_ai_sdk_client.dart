import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/preference/app_pref.dart';
import '../../domain/apna_clinic_ai_failure_codes.dart';
import '../apna_clinic_ai_sse.dart';
import '../apna_clinic_ai_urls.dart';

class ApnaClinicAiSdkException implements Exception {
  const ApnaClinicAiSdkException(
    this.code, {
    this.statusCode,
    this.detail,
  });

  final String code;
  final int? statusCode;
  final String? detail;
}

/// Dedicated Dio client for the AI SDK.
/// Clinic [ApiService] auth and HMAC must not apply here.
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

  /// Last thread that received a user turn. Continue / Resume reads this.
  String historyConversationId = '';

  /// New window dropped the in-memory thread. [ensureConversationId] must
  /// mint a new id instead of reusing a stale singleton value.
  bool detached = true;
  var _historyGen = 0;
  bool isGuest = true;
  String authMode = 'guest';

  bool get hasSession =>
      apiKey != null &&
      apiKey!.isNotEmpty &&
      sessionId != null &&
      sessionId!.isNotEmpty &&
      accessToken != null &&
      accessToken!.isNotEmpty;

  // ---------------------------------------------------------------------------
  // Conversation lifecycle
  // ---------------------------------------------------------------------------

  /// Creates a new chat thread id (New chat / any non-resume start).
  Future<void> newConversation() async {
    detached = false;
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
    detached = false;
    conversationId = trimmed;
    await _appPref.setApnaClinicAiConversationId(conversationId);
  }

  /// Drops the in-memory thread without wiping history (needed for Continue).
  void detachConversation() {
    conversationId = '';
    detached = true;
  }

  /// Last sent thread id (for Continue / Resume on a new window).
  String peekPersistedConversationId() {
    final memory = historyConversationId.trim();
    if (memory.isNotEmpty) return memory;
    final stored = _appPref.getApnaClinicAiHistoryConversationId().trim();
    if (stored.isNotEmpty) {
      historyConversationId = stored;
      return stored;
    }
    final active = _appPref.getApnaClinicAiConversationId().trim();
    if (active.isEmpty) return '';
    historyConversationId = active;
    unawaited(_writeHistory(active));
    return active;
  }

  /// Records the bound thread as history after a real user turn.
  Future<void> rememberCurrentAsHistory() async {
    if (detached) return;
    final id = conversationId.trim();
    if (id.isEmpty) return;
    historyConversationId = id;
    await _writeHistory(id);
  }

  Future<void> _writeHistory(String id) async {
    final gen = ++_historyGen;
    await _appPref.setApnaClinicAiHistoryConversationId(id);
    if (gen == _historyGen) return;
    final latest = historyConversationId.trim();
    if (latest.isNotEmpty && latest != id) {
      await _writeHistory(latest);
    }
  }

  /// Stable id for the bound chat. A detached window always mints a new id.
  Future<String> ensureConversationId() async {
    if (detached || conversationId.isEmpty) {
      await newConversation();
    }
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
  /// guest→signed-in re-init mid-chat stays on the same thread.
  Future<void> clearSession({bool clearConversation = false}) async {
    final keepMemoryId =
        (!detached && !clearConversation) ? conversationId.trim() : '';
    final prefsId = _appPref.getApnaClinicAiConversationId().trim();
    final historyId = clearConversation
        ? ''
        : (historyConversationId.trim().isNotEmpty
              ? historyConversationId.trim()
              : _appPref.getApnaClinicAiHistoryConversationId().trim());
    final keepActivePref = clearConversation
        ? ''
        : (keepMemoryId.isNotEmpty ? keepMemoryId : prefsId);
    apiKey = null;
    accessToken = null;
    userId = null;
    sessionId = null;
    expiresAt = DateTime.fromMillisecondsSinceEpoch(0);
    isGuest = true;
    authMode = 'guest';
    conversationId = '';
    if (clearConversation) {
      detached = true;
      historyConversationId = '';
    }
    await _appPref.clearApnaClinicAiSession();
    // Keep `apna_clinic_ai_session_init.json` — greeting/audio replay on home.
    if (historyId.isNotEmpty) {
      historyConversationId = historyId;
      await _writeHistory(historyId);
    }
    if (keepMemoryId.isNotEmpty) {
      detached = false;
      conversationId = keepMemoryId;
      await _appPref.setApnaClinicAiConversationId(keepMemoryId);
      return;
    }
    detached = true;
    if (keepActivePref.isNotEmpty) {
      await _appPref.setApnaClinicAiConversationId(keepActivePref);
    }
  }

  // ---------------------------------------------------------------------------
  // API calls (paths from [ApnaClinicAiUrls])
  // ---------------------------------------------------------------------------

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

    final data = await _post(ApnaClinicAiUrls.sessionInit, body: body);
    await _applySessionResponse(data, mode: mode);
    await saveInitResponse(data);
    return data;
  }

  Future<void> saveInitResponse(Map<String, dynamic> data) async {
    try {
      final file = await _initResponseFile();
      await file.writeAsString(jsonEncode(data));
    } catch (_) {}
  }

  Future<Map<String, dynamic>?> readInitResponse() async {
    try {
      final file = await _initResponseFile();
      if (!await file.exists()) return null;
      final raw = await file.readAsString();
      if (raw.trim().isEmpty) return null;
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
    return null;
  }

  Future<File> _initResponseFile() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/apna_clinic_ai_session_init.json');
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
    final data = await _post(
      ApnaClinicAiUrls.authToken,
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
    return _get(ApnaClinicAiUrls.app, authorize: true);
  }

  Future<Map<String, dynamic>> postTurn(Map<String, dynamic> body) async {
    await ensureToken();
    return _post(
      ApnaClinicAiUrls.assistantTurn,
      body: body,
      authorize: true,
    );
  }

  Future<Stream<Uint8List>> postTurnStream(Map<String, dynamic> body) async {
    await ensureToken();
    return _postStream(ApnaClinicAiUrls.assistantTurnStream, body);
  }

  /// Multipart SSE voice turn. Retries 403 up to 2 times (600ms backoff).
  Future<Stream<Uint8List>> postAudioTurnStream({
    required List<int> audioBytes,
    required String conversationId,
    String language = 'auto',
    bool speak = true,
  }) async {
    await ensureToken();
    final isWav = isApnaClinicAiWav(audioBytes);

    DioException? lastError;
    for (var attempt = 0; attempt < 3; attempt++) {
      try {
        if (attempt > 0) {
          await Future<void>.delayed(const Duration(milliseconds: 600));
          await ensureToken();
        }
        final formData = FormData.fromMap({
          'api_key': apiKey,
          if (sessionId != null && sessionId!.isNotEmpty)
            'session_id': sessionId,
          'conversation_id': conversationId,
          'channel': 'voice',
          'language': language,
          'speak': speak ? 'true' : 'false',
          'client_turn_id':
              'turn_${DateTime.now().millisecondsSinceEpoch}',
          'include_trace': 'false',
          'dry_run': 'false',
          'audio': MultipartFile.fromBytes(
            audioBytes,
            filename: isWav ? 'speech.wav' : 'speech.m4a',
            contentType: isWav
                ? MediaType('audio', 'wav')
                : MediaType('audio', 'mp4'),
          ),
        });
        final response = await _dio.post<ResponseBody>(
          _config.url(ApnaClinicAiUrls.assistantAudioStream),
          data: formData,
          options: Options(
            headers: _headers(json: false, authorize: true, sse: true),
            responseType: ResponseType.stream,
            sendTimeout: const Duration(seconds: 90),
            receiveTimeout: const Duration(seconds: 120),
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
        lastError = error;
        final status = error.response?.statusCode;
        if (status == 403 && attempt < 2) continue;
        throw _mapDio(error, audioTurn: true);
      }
    }
    throw _mapDio(
      lastError ??
          DioException(
            requestOptions: RequestOptions(
              path: ApnaClinicAiUrls.assistantAudioStream,
            ),
          ),
      audioTurn: true,
    );
  }

  // ---------------------------------------------------------------------------
  // Session persistence
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // HTTP helpers
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> _get(
    String path, {
    bool authorize = false,
  }) {
    return _request('GET', path, authorize: authorize);
  }

  Future<Map<String, dynamic>> _post(
    String path, {
    Map<String, dynamic>? body,
    bool authorize = false,
  }) {
    return _request('POST', path, body: body, authorize: authorize);
  }

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    bool authorize = false,
  }) async {
    try {
      final response = await _dio.request<dynamic>(
        _config.url(path),
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

  Future<Stream<Uint8List>> _postStream(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _dio.post<ResponseBody>(
        _config.url(path),
        data: body,
        options: Options(
          headers: _headers(json: true, authorize: true, sse: true),
          responseType: ResponseType.stream,
          // Stay open for delayed `type: audio` after `final`, same as voice.
          sendTimeout: const Duration(seconds: 90),
          receiveTimeout: const Duration(seconds: 120),
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
      if (loginToken.isNotEmpty)
        'X-User-Token': loginToken.toLowerCase().startsWith('bearer ')
            ? loginToken
            : 'Bearer $loginToken',
    };
  }

  void _requireConfig() {
    if (!_config.isConfigured) {
      throw const ApnaClinicAiSdkException(
        ApnaClinicAiFailureCodes.notConfigured,
      );
    }
  }

  ApnaClinicAiSdkException _mapDio(
    DioException error, {
    bool audioTurn = false,
  }) {
    final status = error.response?.statusCode;
    final data = error.response?.data;
    var detail = '';
    if (data is Map) {
      detail = (data['detail'] ?? data['message'] ?? '').toString();
    } else if (data is String) {
      detail = data;
    } else if (data is ResponseBody) {
      detail = error.message ?? '';
    }

    final combined = '$status $detail ${error.message ?? ''}';
    final noSpeech = RegExp(
      r'no speech|not detected|too noisy|empty audio',
      caseSensitive: false,
    ).hasMatch(combined);
    if (noSpeech || (audioTurn && status == 400)) {
      return ApnaClinicAiSdkException(
        ApnaClinicAiFailureCodes.noSpeech,
        statusCode: status,
        detail: detail,
      );
    }
    if (status == 502 ||
        status == 504 ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        RegExp(r'502|504|upstream', caseSensitive: false).hasMatch(combined)) {
      return ApnaClinicAiSdkException(
        ApnaClinicAiFailureCodes.upstream,
        statusCode: status,
        detail: detail,
      );
    }
    return ApnaClinicAiSdkException(
      ApnaClinicAiFailureCodes.connectFailed,
      statusCode: status,
      detail: detail,
    );
  }
}

String _newId(String prefix) {
  final random = Random.secure();
  final body = List<int>.generate(12, (_) => random.nextInt(256))
      .map((b) => b.toRadixString(16).padLeft(2, '0'))
      .join();
  return '$prefix-$body';
}
