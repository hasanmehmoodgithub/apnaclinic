import 'dart:typed_data';

import '../../domain/apna_clinic_ai_failure_codes.dart';
import '../apna_clinic_ai_sse.dart';
import '../mappers/apna_clinic_ai_turn_parser.dart';
import '../models/apna_clinic_ai_remote_event.dart';
import '../models/apna_clinic_ai_turn_model.dart';
import 'apna_clinic_ai_sdk_client.dart';

abstract class ApnaClinicAiRemoteDataSource {
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
      }

      // Same SSE listen as voice: `final` may set `audio_pending`, then
      // `type: audio` arrives with the clip.
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
      } else if (type == 'audio' || type == 'tts' || type == 'speech') {
        final audio = event['audio'] ?? event['tts'] ?? event['speech'];
        final base64 =
            _clipBase64(audio) ?? _clipBase64(event, clipKeysOnly: true);
        if (base64 != null) {
          final format = audio is Map
              ? (audio['format'] ?? '').toString().toLowerCase()
              : '';
          final mediaType = audio is Map
              ? (audio['media_type'] ?? '').toString().trim()
              : '';
          final turnId = (event['turn_id'] ?? '').toString().trim();
          yield ApnaClinicAiRemoteEvent.audio(
            base64: base64,
            mediaType: mediaType.isNotEmpty
                ? mediaType
                : (format == 'opus' ? 'audio/ogg' : 'audio/wav'),
            turnId: turnId.isEmpty ? null : turnId,
          );
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

  /// Pulls a spoken clip out of a turn/audio payload.
  String? _clipBase64(dynamic audio, {bool clipKeysOnly = false}) {
    if (audio is String) {
      final value = audio.trim();
      return value.isEmpty ? null : value;
    }
    if (audio is Map) {
      final keys = clipKeysOnly
          ? const ['base64', 'audio_base64']
          : const ['base64', 'audio_base64', 'data', 'content'];
      for (final key in keys) {
        final value = audio[key];
        if (value is String && value.trim().isNotEmpty) return value.trim();
      }
    }
    return null;
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
      sectionTitles: source.sectionTitles,
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
