import 'dart:typed_data';

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

  /// Multipart audio SSE. Falls back to text stream on upstream/timeout when
  /// [fallbackMessage] is present.
  Stream<ApnaClinicAiRemoteEvent> sendAudio({
    required List<int> audioBytes,
    String? fallbackMessage,
    bool speak = true,
    String language = 'auto',
    String? voiceId,
  });

  Future<void> newConversation();

  Future<void> restoreConversation(String id);

  void detachConversation();

  String peekPersistedConversationId();

  Future<void> rememberCurrentAsHistory();

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

    Map<String, dynamic>? initData;
    if (!_client.hasSession) {
      await _client.ping();
      initData = await _client.initSession(
        mode: mode,
        deviceId: deviceId,
        msisdn: msisdn,
        name: name,
        email: email,
      );
    } else {
      await _client.ensureToken();
    }

    // Greeting/audio always from saved init file when present (not cleared
    // with session). Falls back to this call's init body after a fresh init.
    final cachedInit = await _client.readInitResponse();
    final greetingSource = cachedInit ?? initData;

    var welcomeMessage = (greetingSource?['greeting'] ?? '').toString().trim();
    var greetingAudioBase64 = '';
    var greetingAudioMediaType = '';
    final initAudio = greetingSource?['audio'];
    if (initAudio is Map) {
      greetingAudioBase64 = (initAudio['base64'] ?? '').toString().trim();
      greetingAudioMediaType =
          (initAudio['media_type'] ?? initAudio['format'] ?? '')
              .toString()
              .trim();
    }

    var assistantName = 'Apna Clinic Ai Noor';
    var suggestions = const <String>[];
    var composerHint = '';
    var headerSubtitle = '';
    var voiceEnabled = false;
    var voiceOutputEnabled = false;
    var homeTiles = const <ApnaClinicAiHomeTileModel>[];
    ApnaClinicAiHomeResumeModel? homeResume;
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
      if (welcomeMessage.isEmpty) {
        welcomeMessage =
            (source['welcome_message'] ?? app['welcome_message'] ?? '')
                .toString()
                .trim();
      }
      final theme = app['theme'];
      if (theme is Map) {
        headerSubtitle = (theme['header_subtitle'] ?? '').toString().trim();
        final placeholder = (theme['input_placeholder'] ?? '').toString().trim();
        if (placeholder.isNotEmpty) composerHint = placeholder;
      }
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
        final output = voice['output'];
        if (output is Map) voiceOutputEnabled = output['enabled'] == true;
      }
    } catch (_) {}

    try {
      final home = await _client.fetchHome();
      final homeName = (home['assistant_name'] ?? '').toString().trim();
      if (homeName.isNotEmpty) assistantName = homeName;
      if (welcomeMessage.isEmpty) {
        final homeWelcome = (home['welcome_message'] ?? home['welcome'] ?? '')
            .toString()
            .trim();
        if (homeWelcome.isNotEmpty) welcomeMessage = homeWelcome;
      }
      composerHint = (home['prompt'] ?? '').toString().trim();
      homeResume = _homeResumeFrom(home);
      final homeSuggestions =
          home['suggestions'] ?? home['concerns'] ?? home['chips'];
      if (homeSuggestions is List) {
        final parsed = homeSuggestions
            .map((item) {
              if (item is Map) {
                return (item['label'] ?? item['title'] ?? item['send'] ?? '')
                    .toString()
                    .trim();
              }
              return item.toString().trim();
            })
            .where((item) => item.isNotEmpty)
            .toList();
        if (parsed.isNotEmpty) suggestions = parsed;
      }
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
            .where(
              (tile) =>
                  tile.title.isNotEmpty &&
                  tile.send.isNotEmpty &&
                  !_isHomeResumeTile(tile.id, tile.send),
            )
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
      greetingAudioBase64: greetingAudioBase64,
      greetingAudioMediaType: greetingAudioMediaType,
      composerHint: composerHint,
      headerSubtitle: headerSubtitle,
      voiceEnabled: voiceEnabled,
      voiceOutputEnabled: voiceOutputEnabled,
      homeTiles: homeTiles,
      homeResume: homeResume,
    );
  }

  @override
  Stream<ApnaClinicAiRemoteEvent> sendMessage({
    required String message,
    required bool speak,
    String? voiceId,
  }) async* {
    try {
      if (!_ensureSessionReady()) {
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

      yield* _consumeSse(await _client.postTurnStream(body));
    } on ApnaClinicAiSdkException catch (error) {
      yield ApnaClinicAiRemoteEvent.failure(error.code);
    } catch (_) {
      yield const ApnaClinicAiRemoteEvent.failure(
        ApnaClinicAiFailureCodes.connectFailed,
      );
    }
  }

  @override
  Stream<ApnaClinicAiRemoteEvent> sendAudio({
    required List<int> audioBytes,
    String? fallbackMessage,
    bool speak = true,
    String language = 'auto',
    String? voiceId,
  }) async* {
    try {
      if (!_ensureSessionReady()) {
        yield const ApnaClinicAiRemoteEvent.failure(
          ApnaClinicAiFailureCodes.connectFailed,
        );
        return;
      }
      if (audioBytes.isEmpty) {
        yield ApnaClinicAiRemoteEvent.finalTurn(
          ApnaClinicAiTurnParser.parse({
            'reply': ApnaClinicAiFailureCodes.noSpeechReply,
            'status': 'completed',
          }),
        );
        return;
      }

      final conversationId = await _client.ensureConversationId();
      try {
        final bytes = await _client.postAudioTurnStream(
          audioBytes: audioBytes,
          conversationId: conversationId,
          language: language,
          speak: speak,
        );
        yield* _consumeSse(bytes);
        return;
      } on ApnaClinicAiSdkException catch (error) {
        if (error.code == ApnaClinicAiFailureCodes.noSpeech) {
          yield ApnaClinicAiRemoteEvent.finalTurn(
            ApnaClinicAiTurnParser.parse({
              'reply': ApnaClinicAiFailureCodes.noSpeechReply,
              'status': 'completed',
            }),
          );
          return;
        }
        final fallback = fallbackMessage?.trim() ?? '';
        final canFallback =
            fallback.isNotEmpty &&
            (error.code == ApnaClinicAiFailureCodes.upstream ||
                error.statusCode == 502 ||
                error.statusCode == 504);
        if (!canFallback) {
          yield ApnaClinicAiRemoteEvent.failure(error.code);
          return;
        }
      }

      // 502 / timeout → text stream with local STT fallback.
      yield* sendMessage(
        message: fallbackMessage!.trim(),
        speak: speak,
        voiceId: voiceId,
      );
    } on ApnaClinicAiSdkException catch (error) {
      yield ApnaClinicAiRemoteEvent.failure(error.code);
    } catch (_) {
      yield const ApnaClinicAiRemoteEvent.failure(
        ApnaClinicAiFailureCodes.connectFailed,
      );
    }
  }

  bool _ensureSessionReady() {
    if (!_client.hasSession) {
      _client.hydrateFromPrefs();
    }
    return _client.hasSession;
  }

  Stream<ApnaClinicAiRemoteEvent> _consumeSse(Stream<Uint8List> bytes) async* {
    var accumulated = '';
    var sawFinal = false;
    await for (final event in parseApnaClinicAiSse(bytes)) {
      final type = event['type']?.toString();
      // Only `final` / `done` end the turn. Do not use raw `done: true` —
      // delayed `type: audio` events also send `done: true` and would clear
      // the reply/chips if treated as a second empty final.
      if (type == 'final' || type == 'done') {
        sawFinal = true;
        final parsed = ApnaClinicAiTurnParser.parse(event);
        final reply = _heardReply(
          parsed.reply.trim().isEmpty ? accumulated : parsed.reply,
        );
        yield ApnaClinicAiRemoteEvent.finalTurn(_withReply(parsed, reply));
      } else if (type == 'audio') {
        final audio = event['audio'];
        if (audio is Map) {
          final base64 = (audio['base64'] ?? '').toString().trim();
          if (base64.isNotEmpty) {
            final format = (audio['format'] ?? '').toString().toLowerCase();
            final mediaType = (audio['media_type'] ?? '').toString().trim();
            final turnId = (event['turn_id'] ?? '').toString().trim();
            yield ApnaClinicAiRemoteEvent.audio(
              base64: base64,
              mediaType: mediaType.isNotEmpty
                  ? mediaType
                  : (format == 'opus' ? 'audio/ogg' : 'audio/wav'),
              turnId: turnId.isEmpty ? null : turnId,
            );
          }
        }
      } else if (type == 'error') {
        // After `final` + delayed `audio`, stream teardown errors must not
        // wipe the reply/chips the UI already showed.
        if (sawFinal) continue;
        final error = event['error'];
        final messageText = error is Map
            ? (error['message'] ?? error['detail'] ?? '').toString()
            : (event['message'] ?? '').toString();
        if (_isNoSpeech(messageText)) {
          yield ApnaClinicAiRemoteEvent.finalTurn(
            ApnaClinicAiTurnParser.parse({
              'reply': ApnaClinicAiFailureCodes.noSpeechReply,
              'status': 'completed',
            }),
          );
        } else {
          yield ApnaClinicAiRemoteEvent.failure(_failureCode(messageText));
        }
      } else if (type == 'token' || type == 'delta' || type == 'chunk') {
        accumulated += (event['text'] ?? event['delta'] ?? '').toString();
        yield ApnaClinicAiRemoteEvent.token(accumulated);
      } else if (type == 'status' && event['status'] == 'transcribing') {
        yield const ApnaClinicAiRemoteEvent.stage('transcribing');
        final transcription = event['transcription'];
        final text = transcription is Map
            ? (transcription['text'] ?? '').toString().trim()
            : '';
        if (text.isNotEmpty) {
          yield ApnaClinicAiRemoteEvent.transcription(text);
        }
      } else if (type == 'stage') {
        yield ApnaClinicAiRemoteEvent.stage(
          (event['name'] ?? 'tool').toString(),
        );
      }
    }
    if (!sawFinal && accumulated.trim().isNotEmpty) {
      yield ApnaClinicAiRemoteEvent.finalTurn(
        ApnaClinicAiTurnParser.parse({'reply': _heardReply(accumulated)}),
      );
    }
  }

  bool _isHomeResumeTile(String id, String send) {
    final key = id.trim().toLowerCase();
    if (key == 'resume_open_request' || key.startsWith('resume_')) return true;
    return send.trim() == '__resume__';
  }

  ApnaClinicAiHomeResumeModel? _homeResumeFrom(Map<String, dynamic> home) {
    final raw = home['resume'];
    if (raw is! Map) return null;
    final expires = _resumeExpiresAt(raw['expires_at']);
    if (expires != null && !expires.isAfter(DateTime.now().toUtc())) {
      return null;
    }
    final card = raw['card'];
    final cardMap = card is Map ? card : const <String, dynamic>{};
    final conversationId =
        (raw['conversation_id'] ?? cardMap['conversation_id'] ?? '')
            .toString()
            .trim();
    if (conversationId.isEmpty) return null;
    final title = (cardMap['title'] ?? '').toString().trim();
    final subtitle = _resumeLine(
      (raw['prompt'] ?? cardMap['subtitle'] ?? '').toString(),
    );
    final badge = _resumeBadge(home, cardMap);
    final send = (cardMap['send'] ?? '').toString().trim();
    return ApnaClinicAiHomeResumeModel(
      conversationId: conversationId,
      title: title.isEmpty ? 'Resume' : title,
      subtitle: subtitle,
      send: send.isEmpty ? '__resume__' : send,
      badge: badge.isEmpty ? null : badge,
    );
  }

  DateTime? _resumeExpiresAt(Object? raw) {
    if (raw is! num) return null;
    final ms = raw > 100000000000 ? raw.round() : (raw * 1000).round();
    return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
  }

  String _resumeBadge(Map<String, dynamic> home, Map card) {
    final direct = (card['badge'] ?? '').toString().trim();
    if (direct.isNotEmpty) return direct;
    final id = (card['id'] ?? 'resume_open_request').toString();
    final cards = home['cards'];
    if (cards is! List) return '';
    for (final item in cards.whereType<Map>()) {
      if ((item['id'] ?? '').toString() == id) {
        return (item['badge'] ?? '').toString().trim();
      }
    }
    return '';
  }

  String _resumeLine(String raw) {
    final first = raw.split(RegExp(r'\r?\n')).first;
    return first.replaceAll('**', '').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  bool _isNoSpeech(String text) {
    return RegExp(
      r'no speech|not detected|too noisy|hold to talk',
      caseSensitive: false,
    ).hasMatch(text);
  }

  String _heardReply(String reply) {
    if (_isNoSpeech(reply)) return ApnaClinicAiFailureCodes.noSpeechReply;
    return reply;
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
  Future<void> rememberCurrentAsHistory() =>
      _client.rememberCurrentAsHistory();

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
      audioPending: source.audioPending,
      turnId: source.turnId,
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
