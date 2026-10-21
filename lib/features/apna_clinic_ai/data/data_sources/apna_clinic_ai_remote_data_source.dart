import '../../domain/apna_clinic_ai_failure_codes.dart';
import '../mappers/apna_clinic_ai_turn_parser.dart';
import '../models/apna_clinic_ai_remote_event.dart';
import '../models/apna_clinic_ai_session_model.dart';
import '../models/apna_clinic_ai_turn_model.dart';
import 'apna_clinic_ai_sdk_client.dart';

abstract class ApnaClinicAiRemoteDataSource {
  Future<ApnaClinicAiSessionModel> ensureSession({
    required String mode,
    required String deviceId,
    String? msisdn,
    String? name,
    String? email,
    bool forceRefresh = false,
  });

  Stream<ApnaClinicAiRemoteEvent> sendMessage({
    required String message,
    required bool speak,
    String? voiceId,
  });

  Future<void> newConversation();

  Future<void> restoreConversation(String id);

  void detachConversation();

  String peekPersistedConversationId();

  Future<void> clearSession();
}

class ApnaClinicAiRemoteDataSourceImpl implements ApnaClinicAiRemoteDataSource {
  ApnaClinicAiRemoteDataSourceImpl({required ApnaClinicAiSdkClient client})
    : _client = client;

  final ApnaClinicAiSdkClient _client;

  @override
  Future<ApnaClinicAiSessionModel> ensureSession({
    required String mode,
    required String deviceId,
    String? msisdn,
    String? name,
    String? email,
    bool forceRefresh = false,
  }) async {
    if (forceRefresh) {
      await _client.clearSession();
    } else {
      _client.hydrateFromPrefs();
    }

    final modeChanged =
        _client.hasSession &&
        _client.authMode.isNotEmpty &&
        _client.authMode != mode;
    if (modeChanged) {
      await _client.clearSession();
    }

    // conversation_id is bound later (Continue → restore, else → new).

    if (!_client.hasSession) {
      await _client.ping();
      await _client.initSession(
        mode: mode,
        deviceId: deviceId,
        msisdn: msisdn,
        name: name,
        email: email,
      );
    } else {
      await _client.ensureToken();
    }

    var assistantName = 'ApnaClinic';
    var suggestions = const <String>[];
    var welcomeMessage = '';
    var voiceEnabled = false;
    var homeTiles = const <ApnaClinicAiHomeTileModel>[];
    try {
      final app = await _client.fetchApp() ?? const <String, dynamic>{};
      final branding = app['branding'];
      final source = branding is Map ? branding : app;
      final nameFromApi = (source['assistant_name'] ?? app['assistant_name'])
          ?.toString()
          .trim();
      if (nameFromApi != null && nameFromApi.isNotEmpty) {
        assistantName = nameFromApi;
      }
      welcomeMessage =
          (source['welcome_message'] ?? app['welcome_message'] ?? '')
              .toString()
              .trim();
      final raw = source['suggestions'] ?? app['suggestions'];
      if (raw is List) {
        suggestions = raw
            .map((item) => item.toString().trim())
            .where((item) => item.isNotEmpty)
            .toList();
      }
      final voice = source['voice'] ?? app['voice'];
      if (voice is Map) {
        final input = voice['input'];
        if (input is Map) voiceEnabled = input['enabled'] == true;
      }
    } catch (_) {}

    try {
      final home = await _client.fetchHome();
      welcomeMessage = welcomeMessage.isNotEmpty
          ? welcomeMessage
          : (home['prompt'] ?? '').toString().trim();
      final cards = home['cards'];
      if (cards is List) {
        homeTiles = cards
            .whereType<Map>()
            .map(
              (card) => ApnaClinicAiHomeTileModel(
                id: (card['id'] ?? '').toString(),
                title: (card['title'] ?? '').toString(),
                subtitle: card['subtitle']?.toString(),
                send: (card['send'] ?? card['title'] ?? '').toString(),
              ),
            )
            .where((tile) => tile.title.isNotEmpty && tile.send.isNotEmpty)
            .toList();
      }
    } catch (_) {}

    return ApnaClinicAiSessionModel(
      sessionId: _client.sessionId!,
      conversationId: _client.conversationId,
      isGuest: _client.isGuest,
      assistantName: assistantName,
      suggestions: suggestions,
      welcomeMessage: welcomeMessage,
      voiceEnabled: voiceEnabled,
      homeTiles: homeTiles,
    );
  }

  @override
  Stream<ApnaClinicAiRemoteEvent> sendMessage({
    required String message,
    required bool speak,
    String? voiceId,
  }) async* {
    try {
      if (!_client.hasSession) {
        _client.hydrateFromPrefs();
      }
      if (!_client.hasSession) {
        yield const ApnaClinicAiRemoteEvent.failure(
          ApnaClinicAiFailureCodes.connectFailed,
        );
        return;
      }

      final conversationId = await _client.ensureConversationId();
      final body = <String, dynamic>{
        'api_key': _client.apiKey,
        'session_id': _client.sessionId,
        'conversation_id': conversationId,
        'message': message,
        'include_trace': false,
        'dry_run': false,
        'channel': 'app',
        'language': 'auto',
      };
      if (speak) {
        body['speak'] = true;
        if (voiceId != null && voiceId.isNotEmpty) body['voice'] = voiceId;
        final data = await _client.postTurn(body);
        yield ApnaClinicAiRemoteEvent.finalTurn(
          ApnaClinicAiTurnParser.parse(data),
        );
        return;
      }

      final bytes = await _client.postTurnStream(body);
      var accumulated = '';
      var sawFinal = false;
      await for (final event in parseApnaClinicAiSse(bytes)) {
        final type = event['type']?.toString();
        if (type == 'final' || event['done'] == true) {
          sawFinal = true;
          final parsed = ApnaClinicAiTurnParser.parse(event);
          final reply =
              parsed.reply.trim().isEmpty ? accumulated : parsed.reply;
          yield ApnaClinicAiRemoteEvent.finalTurn(
            _withReply(parsed, reply),
          );
        } else if (type == 'error') {
          final error = event['error'];
          final messageText = error is Map
              ? (error['message'] ?? '').toString()
              : '';
          yield ApnaClinicAiRemoteEvent.failure(_failureCode(messageText));
        } else if (type == 'token' || type == 'delta') {
          accumulated += (event['text'] ?? event['delta'] ?? '').toString();
          yield ApnaClinicAiRemoteEvent.token(accumulated);
        } else if (type == 'status' && event['status'] == 'transcribing') {
          yield const ApnaClinicAiRemoteEvent.stage('transcribing');
        } else if (type == 'stage') {
          yield ApnaClinicAiRemoteEvent.stage(
            (event['name'] ?? 'tool').toString(),
          );
        }
      }
      if (!sawFinal && accumulated.trim().isNotEmpty) {
        yield ApnaClinicAiRemoteEvent.finalTurn(
          ApnaClinicAiTurnParser.parse({'reply': accumulated}),
        );
      }
    } on ApnaClinicAiSdkException catch (error) {
      yield ApnaClinicAiRemoteEvent.failure(error.code);
    } catch (_) {
      yield const ApnaClinicAiRemoteEvent.failure(
        ApnaClinicAiFailureCodes.connectFailed,
      );
    }
  }

  @override
  Future<void> newConversation() => _client.newConversation();

  @override
  Future<void> restoreConversation(String id) =>
      _client.restoreConversation(id);

  @override
  void detachConversation() => _client.detachConversation();

  @override
  String peekPersistedConversationId() =>
      _client.peekPersistedConversationId();

  @override
  Future<void> clearSession() => _client.clearSession();

  ApnaClinicAiTurnModel _withReply(ApnaClinicAiTurnModel source, String reply) {
    return ApnaClinicAiTurnModel(
      reply: reply,
      status: source.status,
      intent: source.intent,
      failureCode: source.failureCode,
      quickActions: source.quickActions,
      doctors: source.doctors,
      slots: source.slots,
      slotDays: source.slotDays,
      payments: source.payments,
      audioBase64: source.audioBase64,
      audioMediaType: source.audioMediaType,
      signInRequired: source.signInRequired,
      authResumeMessage: source.authResumeMessage,
      authDeepLink: source.authDeepLink,
    );
  }

  String _failureCode(String text) {
    if (RegExp(r'502|504|upstream', caseSensitive: false).hasMatch(text)) {
      return ApnaClinicAiFailureCodes.upstream;
    }
    if (RegExp(r'request_id|"message"', caseSensitive: false).hasMatch(text)) {
      return ApnaClinicAiFailureCodes.booking;
    }
    return ApnaClinicAiFailureCodes.connectFailed;
  }
}
