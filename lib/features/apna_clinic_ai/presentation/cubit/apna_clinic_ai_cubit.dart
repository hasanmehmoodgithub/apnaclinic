import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/services/speech_to_text_service.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../../../core/utils/microphone_permission_utils.dart';
import '../../data/data_sources/apna_clinic_ai_local_data_source.dart';
import '../../domain/entities/apna_clinic_ai_message_entity.dart';
import '../../domain/entities/apna_clinic_ai_stream_event.dart';
import '../../domain/apna_clinic_ai_failure_codes.dart';
import '../../domain/use_cases/ensure_apna_clinic_ai_session_use_case.dart';
import '../../domain/use_cases/init_apna_clinic_ai_session_params.dart';
import '../../domain/use_cases/send_apna_clinic_ai_message_params.dart';
import '../../domain/use_cases/send_apna_clinic_ai_message_use_case.dart';
import '../../domain/utils/apna_clinic_ai_emergency.dart';
import '../../domain/utils/roman_urdu.dart';
import 'apna_clinic_ai_state.dart';

class ApnaClinicAiCubit extends Cubit<ApnaClinicAiState> {
  ApnaClinicAiCubit({
    required this.ensureSessionUseCase,
    required this.sendMessageUseCase,
    required this.localDataSource,
    required this.appPref,
    required this.speechToText,
  }) : super(const ApnaClinicAiState()) {
    _loadComplaint();
    // New window: stash prior thread for Continue/Resume; bind later.
    unawaited(_openWindow());
  }

  Future<void> _openWindow() async {
    _resumeConversationId =
        sendMessageUseCase.peekPersistedConversationId();
    sendMessageUseCase.detachConversation();
    _conversationBound = false;
    if (isClosed) return;
    await connect();
  }

  final EnsureApnaClinicAiSessionUseCase ensureSessionUseCase;
  final SendApnaClinicAiMessageUseCase sendMessageUseCase;
  final ApnaClinicAiLocalDataSource localDataSource;
  final AppPref appPref;
  final SpeechToTextService speechToText;

  StreamSubscription<ApnaClinicAiStreamEvent>? _turnSub;
  Future<bool>? _connectInFlight;
  var _messageSeq = 0;
  var _connected = false;
  var _liveCaption = '';
  var _startingVoice = false;
  var _voiceStopInFlight = false;
  var _voiceLanguageChosen = false;
  var _voiceGeneration = 0;
  /// Prior prefs thread — used only when the user taps Continue / Resume.
  var _resumeConversationId = '';
  /// True after the first bind (resume or new) in this window.
  var _conversationBound = false;

  void _loadComplaint() {
    final saved = localDataSource.readComplaint();
    if (saved == null) return;
    emit(
      state.copyWith(
        lastComplaint: saved.text,
        lastComplaintAtMillis: saved.savedAtMillis,
      ),
    );
  }

  Future<bool> connect({bool forceRefresh = false}) {
    // Compare against persisted SDK mode — not UI state — so we never
    // rotate session (or conversation) on every turn due to isGuest drift.
    final wantMode = AuthGuard.isLoggedIn(appPref) ? 'signed_in' : 'guest';
    final cachedMode = appPref.getApnaClinicAiAuthMode();
    final modeMismatch =
        cachedMode.isNotEmpty && cachedMode != wantMode;
    if (modeMismatch) {
      _connected = false;
      forceRefresh = true;
    }
    if (_connected && !forceRefresh) return Future.value(true);
    return _connectInFlight ??= _connect(forceRefresh: forceRefresh)
        .whenComplete(() {
          _connectInFlight = null;
        });
  }

  Future<bool> _connect({bool forceRefresh = false}) async {
    if (_connected && !forceRefresh) return true;
    emit(state.copyWith(connecting: true, clearError: true));
    final user = appPref.getUserLocalModel();
    final name = [
      user?.firstName.trim() ?? '',
      user?.lastName.trim() ?? '',
    ].where((part) => part.isNotEmpty).join(' ');
    final displayName = name.isEmpty
        ? ''
        : name.split(RegExp(r'\s+')).first.capitalize;
    final result = await ensureSessionUseCase.call(
      InitApnaClinicAiSessionParams(forceRefresh: forceRefresh),
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(
          state.copyWith(
            connecting: false,
            userDisplayName: displayName,
            errorCode: error,
            errorNonce: state.errorNonce + 1,
          ),
        );
        return false;
      },
      (session) {
        _connected = true;
        emit(
          state.copyWith(
            connecting: false,
            assistantName: session.assistantName,
            suggestions: session.suggestions,
            welcomeMessage: session.welcomeMessage,
            voiceEnabled: session.voiceEnabled,
            homeTiles: session.homeTiles,
            isGuest: session.isGuest,
            userDisplayName: displayName,
            clearError: true,
          ),
        );
        return true;
      },
    );
  }

  void showHome() => emit(state.copyWith(showChat: false));

  void showChat() => emit(state.copyWith(showChat: true));

  /// After app login: re-bind signed-in session and send auth.resume.message
  /// in the **same** conversation_id so cart / triage continues.
  Future<void> resumeAfterSignIn() async {
    final resume = (state.authResumeMessage ?? '').trim();
    emit(
      state.copyWith(
        signInRequired: false,
        clearAuthResume: true,
      ),
    );
    _connected = false;
    final ready = await connect(forceRefresh: true);
    if (!ready || isClosed) return;
    if (resume.isNotEmpty) {
      await sendText(resume);
    }
  }

  void setSpeakReplies(bool enabled) {
    emit(state.copyWith(speakReplies: enabled));
  }

  void addSystemMessage(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    emit(
      state.copyWith(
        showChat: true,
        messages: [
          ...state.messages,
          ApnaClinicAiMessageEntity(
            id: _nextId(),
            role: ApnaClinicAiMessageRole.system,
            text: trimmed,
          ),
        ],
      ),
    );
  }

  /// Clears the transcript and starts a new [conversation_id].
  void newChat() {
    _turnSub?.cancel();
    unawaited(speechToText.cancel());
    _liveCaption = '';
    _startingVoice = false;
    unawaited(_resetConversation());
  }

  Future<void> _resetConversation() async {
    await sendMessageUseCase.newConversation();
    _conversationBound = true;
    _resumeConversationId = '';
    if (isClosed) return;
    emit(
      state.copyWith(
        showChat: true,
        streaming: false,
        recording: false,
        signInRequired: false,
        emergencyVisible: false,
        thinkingStage: 'listening',
        liveCaption: '',
        messages: const [],
        doctors: const [],
        slots: const [],
        slotDays: const [],
        payments: const [],
        quickActions: const [],
        clearAuthResume: true,
        clearTts: true,
        clearError: true,
      ),
    );
  }

  /// Continue previous — reuses the stashed [conversation_id].
  Future<void> resumeLastComplaint() async {
    final text = state.lastComplaint;
    if (text == null || text.isEmpty) {
      showChat();
      return;
    }
    showChat();
    await sendText(text, resumeThread: true);
  }

  /// Binds conversation once per window: resume prior thread or start new.
  Future<void> _ensureThread({required bool resume}) async {
    if (_conversationBound) return;
    if (resume && _resumeConversationId.isNotEmpty) {
      await sendMessageUseCase.restoreConversation(_resumeConversationId);
    } else {
      await sendMessageUseCase.newConversation();
    }
    _conversationBound = true;
  }

  Future<void> sendText(
    String raw, {
    bool isVoice = false,
    bool resumeThread = false,
  }) async {
    final text = raw.trim();
    if (text.isEmpty || state.streaming) return;
    final ready = await connect();
    if (!ready || isClosed) return;
    await _ensureThread(resume: resumeThread);
    if (isClosed) return;

    final critical = ApnaClinicAiEmergency.isCritical(text);
    await localDataSource.saveComplaint(text);
    _loadComplaint();

    final assistantId = _nextId();
    emit(
      state.copyWith(
        showChat: true,
        streaming: true,
        thinkingStage: isVoice ? 'transcribing' : 'listening',
        emergencyVisible: state.emergencyVisible || critical,
        signInRequired: false,
        doctors: const [],
        slots: const [],
        slotDays: const [],
        payments: const [],
        quickActions: const [],
        clearAuthResume: true,
        clearTts: true,
        clearError: true,
        messages: [
          ...state.messages,
          ApnaClinicAiMessageEntity(
            id: _nextId(),
            role: ApnaClinicAiMessageRole.user,
            text: text,
            isVoice: isVoice,
          ),
          ApnaClinicAiMessageEntity(
            id: assistantId,
            role: ApnaClinicAiMessageRole.assistant,
            text: '',
            pending: true,
            showEmergencyNote: critical,
          ),
        ],
      ),
    );

    _turnSub?.cancel();
    _turnSub = sendMessageUseCase
        .call(
          SendApnaClinicAiMessageParams(
            message: text,
            speak: isVoice || state.speakReplies,
          ),
        )
        .listen(
          (event) {
            if (isClosed) return;
            if (event is ApnaClinicAiStreamToken) {
              _onToken(assistantId, event.accumulated);
            } else if (event is ApnaClinicAiStreamStage) {
              emit(state.copyWith(thinkingStage: event.stage));
            } else if (event is ApnaClinicAiStreamFailure) {
              _finishAssistant(assistantId, text: '', failureCode: event.code);
            } else if (event is ApnaClinicAiStreamFinal) {
              final turn = event.turn;
              _finishAssistant(
                assistantId,
                text: turn.reply,
                failureCode: turn.failureCode,
              );
              emit(
                state.copyWith(
                  doctors: turn.doctors,
                  slots: turn.slots,
                  slotDays: turn.slotDays,
                  payments: turn.payments,
                  quickActions: turn.quickActions,
                  signInRequired: turn.signInRequired,
                  authResumeMessage: turn.authResumeMessage,
                  authDeepLink: turn.authDeepLink,
                  clearAuthResume: !turn.signInRequired,
                  ttsBase64: turn.audioBase64,
                  ttsMediaType: turn.audioMediaType,
                  ttsNonce: turn.audioBase64 == null
                      ? state.ttsNonce
                      : state.ttsNonce + 1,
                  clearTts: turn.audioBase64 == null,
                ),
              );
            }
          },
          onError: (_) {
            if (isClosed) return;
            _finishAssistant(
              assistantId,
              text: '',
              failureCode: ApnaClinicAiFailureCodes.connectFailed,
            );
          },
          onDone: () {
            if (isClosed) return;
            if (state.streaming) {
              emit(state.copyWith(streaming: false));
            }
          },
        );
  }

  Future<void> toggleListening({String? languageCode}) async {
    if (state.recording) {
      await stopListeningAndSend();
      return;
    }
    if (_startingVoice) return;
    _applyVoiceLanguageDefault(languageCode);
    await startListening();
  }

  void _applyVoiceLanguageDefault(String? languageCode) {
    if (_voiceLanguageChosen || languageCode == null) return;
    final code = languageCode.toLowerCase().startsWith('ur') ? 'ur' : 'en';
    if (state.voiceLanguageCode == code) return;
    emit(state.copyWith(voiceLanguageCode: code));
  }

  Future<void> setVoiceLanguage(String code) async {
    final normalized = code.toLowerCase().startsWith('ur') ? 'ur' : 'en';
    _voiceLanguageChosen = true;
    final restart = state.recording;
    emit(state.copyWith(voiceLanguageCode: normalized));
    if (!restart) return;
    await speechToText.cancel();
    if (isClosed) return;
    _liveCaption = '';
    emit(state.copyWith(recording: false, liveCaption: ''));
    await startListening();
  }

  Future<void> cancelListening() async {
    _voiceGeneration++;
    _startingVoice = false;
    await speechToText.cancel();
    if (isClosed) return;
    _liveCaption = '';
    emit(state.copyWith(recording: false, liveCaption: ''));
  }

  Future<void> startListening() async {
    if (state.streaming || state.recording || _startingVoice) return;
    final generation = ++_voiceGeneration;
    _startingVoice = true;
    final granted = await ensureMicrophonePermission();
    if (isClosed || generation != _voiceGeneration) {
      _startingVoice = false;
      return;
    }
    if (!granted) {
      _startingVoice = false;
      _setError(ApnaClinicAiFailureCodes.voiceUnavailable);
      return;
    }
    _liveCaption = '';
    emit(
      state.copyWith(
        showChat: true,
        recording: true,
        liveCaption: '',
        clearError: true,
      ),
    );
    final failure = await speechToText.startListening(
      languageCode: state.voiceLanguageCode,
      style: SpeechListenStyle.dictation,
      listenFor: const Duration(seconds: 45),
      pauseFor: const Duration(seconds: 3),
      onResult: (text, _) {
        final words = _inVoiceScript(text);
        if (words.isEmpty || isClosed || !state.recording) return;
        _liveCaption = words;
        emit(state.copyWith(liveCaption: words, recording: true));
      },
      onSessionDone: () {
        if (isClosed || _voiceStopInFlight) return;
        unawaited(stopListeningAndSend());
      },
    );
    if (isClosed || generation != _voiceGeneration) {
      _startingVoice = false;
      if (!_voiceStopInFlight) await speechToText.cancel();
      return;
    }
    _startingVoice = false;
    if (failure != null && state.recording) {
      emit(state.copyWith(recording: false, liveCaption: ''));
      _setError(ApnaClinicAiFailureCodes.voiceUnavailable);
    }
  }

  Future<void> stopListeningAndSend() async {
    if (_voiceStopInFlight) return;
    if (!state.recording && !speechToText.isListening && !_startingVoice) {
      return;
    }
    _voiceStopInFlight = true;
    _startingVoice = false;
    _voiceGeneration++;
    final heardSpeech =
        state.recording || speechToText.isListening || _liveCaption.isNotEmpty;
    try {
      await speechToText.stop();
      if (isClosed) return;
      final spoken = _inVoiceScript(
        _liveCaption.trim().isNotEmpty
            ? _liveCaption.trim()
            : speechToText.lastRecognized.trim(),
      );
      _liveCaption = '';
      emit(state.copyWith(recording: false, liveCaption: ''));
      if (spoken.isEmpty) {
        if (heardSpeech) {
          _setError(ApnaClinicAiFailureCodes.emptyRecording);
        }
        return;
      }
      await sendText(spoken, isVoice: true);
    } finally {
      _voiceStopInFlight = false;
    }
  }

  String _inVoiceScript(String text) {
    final words = text.trim();
    if (words.isEmpty || state.voiceLanguageCode != 'ur') return words;
    return RomanUrdu.toNative(words);
  }

  void _onToken(String assistantId, String accumulated) {
    final showText = accumulated.trim().length > 12;
    final messages = state.messages.map((message) {
      if (message.id != assistantId) return message;
      return message.copyWith(
        text: showText ? accumulated : message.text,
        pending: !showText,
      );
    }).toList();
    emit(
      state.copyWith(
        messages: messages,
        thinkingStage: showText ? 'writing' : state.thinkingStage,
      ),
    );
  }

  void _finishAssistant(
    String assistantId, {
    required String text,
    String? failureCode,
  }) {
    final messages = state.messages.map((message) {
      if (message.id != assistantId) return message;
      return message.copyWith(
        text: text,
        pending: false,
        failureCode: failureCode,
        clearFailureCode: failureCode == null,
      );
    }).toList();
    emit(state.copyWith(streaming: false, messages: messages));
  }

  void _setError(String code) {
    emit(state.copyWith(errorCode: code, errorNonce: state.errorNonce + 1));
  }

  String _nextId() {
    _messageSeq += 1;
    return 'm$_messageSeq';
  }

  @override
  Future<void> close() async {
    await _turnSub?.cancel();
    await speechToText.cancel();
    return super.close();
  }
}
