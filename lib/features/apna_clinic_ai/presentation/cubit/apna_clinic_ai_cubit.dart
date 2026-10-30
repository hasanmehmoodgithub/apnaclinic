import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/preference/app_pref.dart';
import '../../../../core/services/speech_to_text_service.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../../../core/utils/microphone_permission_utils.dart';
import '../../data/apna_clinic_ai_urls.dart';
import '../../data/data_sources/apna_clinic_ai_local_data_source.dart';
import '../../data/apna_clinic_ai_sse.dart';
import '../../data/services/apna_clinic_ai_audio_recorder_service.dart';
import '../../domain/entities/apna_clinic_ai_message_entity.dart';
import '../../domain/entities/apna_clinic_ai_stream_event.dart';
import '../../domain/entities/apna_clinic_ai_turn_entity.dart';
import '../../domain/apna_clinic_ai_failure_codes.dart';
import '../../domain/use_cases/ensure_apna_clinic_ai_session_use_case.dart';
import '../../domain/use_cases/init_apna_clinic_ai_session_params.dart';
import '../../domain/use_cases/send_apna_clinic_ai_audio_params.dart';
import '../../domain/use_cases/send_apna_clinic_ai_audio_use_case.dart';
import '../../domain/use_cases/send_apna_clinic_ai_message_params.dart';
import '../../domain/use_cases/send_apna_clinic_ai_message_use_case.dart';
import '../../domain/utils/apna_clinic_ai_emergency.dart';
import '../../domain/utils/roman_urdu.dart';
import '../apna_clinic_ai_analytics.dart';
import '../apna_clinic_ai_copy.dart';
import '../../../../core/analytics/apna_clinic_ai_analytics_event_keys.dart';
import 'apna_clinic_ai_state.dart';

class ApnaClinicAiCubit extends Cubit<ApnaClinicAiState> {
  ApnaClinicAiCubit({
    required this.ensureSessionUseCase,
    required this.sendMessageUseCase,
    required this.sendAudioUseCase,
    required this.localDataSource,
    required this.config,
    required this.preferences,
    required this.appPref,
    required this.speechToText,
    required this.audioRecorder,
  }) : super(_bootState(appPref)) {
    _loadComplaint();
    // New window: stash prior thread for Continue/Resume; bind later.
    unawaited(_openWindow());
  }

  /// One `session/init` per app process. Cleared only by process death.
  /// Logout clears prefs → next connect inits even if this is still true.
  /// Login / guest↔signed-in mismatch still forces refresh in [connect].
  static var _sessionInitDoneThisProcess = false;

  /// Prefill header from prefs so loading never flashes “Guest” for signed-in users.
  static ApnaClinicAiState _bootState(AppPref appPref) {
    final user = appPref.getUserLocalModel();
    final displayName = [
      user?.firstName.trim() ?? '',
      user?.lastName.trim() ?? '',
    ].where((part) => part.isNotEmpty).join(' ');
    return ApnaClinicAiState(
      showChat: true,
      connecting: true,
      isGuest: !AuthGuard.isLoggedIn(appPref),
      userDisplayName: displayName,
      userImageUrl: (user?.imageUrl ?? '').trim(),
    );
  }

  Future<void> _openWindow() async {
    _resumeConversationId =
        sendMessageUseCase.peekPersistedConversationId();
    sendMessageUseCase.detachConversation();
    _conversationBound = false;
    if (isClosed) return;
    // session/init only on cold app start, logout (empty prefs), or
    // login/mode change — not every time the user opens Care Companion.
    final coldStart = !_sessionInitDoneThisProcess;
    final ready = await connect(forceRefresh: coldStart);
    if (ready) _sessionInitDoneThisProcess = true;
  }

  final EnsureApnaClinicAiSessionUseCase ensureSessionUseCase;
  final SendApnaClinicAiMessageUseCase sendMessageUseCase;
  final SendApnaClinicAiAudioUseCase sendAudioUseCase;
  final ApnaClinicAiLocalDataSource localDataSource;
  final ApnaClinicAiConfig config;
  final SharedPreferences preferences;
  final AppPref appPref;
  final SpeechToTextService speechToText;
  final ApnaClinicAiAudioRecorderService audioRecorder;

  /// One SSE listen per in-flight turn. A newer voice note must not cancel
  /// the previous turn before its delayed `type: audio` arrives.
  final Map<String, StreamSubscription<ApnaClinicAiStreamEvent>> _turnSubs =
      {};
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
  /// Home voice can mint a new thread; in-chat voice stays on the bound one.
  var _voiceResumesThread = false;
  var _voiceForceNewThread = false;
  Timer? _maxVoiceTimer;
  /// Last session/init greeting clip — played once on the first empty chat.
  var _greetingAudioBase64 = '';
  var _greetingAudioMediaType = '';
  var _greetingAudioPlayed = false;
  static const _greetingMessageId = 'sdk_greeting';

  /// ChatGPT-style slow text: SSE fills [_revealTarget], ticker grows [_revealShown].
  Timer? _revealTimer;
  var _revealAssistantId = '';
  var _revealTarget = '';
  var _revealShown = '';
  var _revealFinalized = false;
  ApnaClinicAiTurnEntity? _revealPendingTurn;
  var _revealKeepChips = false;
  /// Last outbound channel for pairing with [ApnaClinicAiAnalytics.logMessageReceived].
  var _lastSendChannel = ApnaClinicAiAnalyticsChannelKeys.text;

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
    final user = appPref.getUserLocalModel();
    final displayName = [
      user?.firstName.trim() ?? '',
      user?.lastName.trim() ?? '',
    ].where((part) => part.isNotEmpty).join(' ');
    final imageUrl = (user?.imageUrl ?? '').trim();
    // Show signed-in name/photo immediately — don't wait for session/app.
    emit(
      state.copyWith(
        connecting: true,
        clearError: true,
        userDisplayName: displayName,
        userImageUrl: imageUrl,
        isGuest: !AuthGuard.isLoggedIn(appPref),
      ),
    );
    final result = await ensureSessionUseCase.call(
      InitApnaClinicAiSessionParams(forceRefresh: forceRefresh),
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        _connected = false;
        emit(
          state.copyWith(
            connecting: false,
            userDisplayName: displayName,
            userImageUrl: imageUrl,
            suggestions: const [],
            errorCode: error,
            errorNonce: state.errorNonce + 1,
          ),
        );
        return false;
      },
      (session) {
        _connected = true;
        _greetingAudioBase64 = session.greetingAudioBase64.trim();
        _greetingAudioMediaType = session.greetingAudioMediaType.trim();
        emit(
          state.copyWith(
            connecting: false,
            assistantName: apnaClinicAiBrandName(session.assistantName),
            suggestions: session.suggestions,
            welcomeMessage: session.welcomeMessage.trim(),
            composerHint: session.composerHint,
            headerSubtitle: session.headerSubtitle,
            voiceEnabled: session.voiceEnabled,
            voiceOutputEnabled: session.voiceOutputEnabled,
            isGuest: session.isGuest,
            userDisplayName: displayName,
            userImageUrl: imageUrl,
            clearError: true,
            showChat: true,
          ),
        );
        _seedSdkGreeting();
        return true;
      },
    );
  }

  /// Puts the session/init greeting in the thread the first time it is empty,
  /// and plays its clip once for this cubit.
  void _seedSdkGreeting({bool playAudio = true}) {
    if (isClosed) return;
    final text = state.welcomeMessage.trim();
    final clip = _greetingAudioBase64.trim();
    final media = _greetingAudioMediaType.trim();
    if (state.messages.isEmpty && text.isNotEmpty) {
      emit(
        state.copyWith(
          showChat: true,
          messages: [
            ApnaClinicAiMessageEntity(
              id: _greetingMessageId,
              role: ApnaClinicAiMessageRole.assistant,
              text: text,
              audioBase64: clip.isEmpty ? null : clip,
              audioMediaType: clip.isEmpty || media.isEmpty ? null : media,
              audioPending: false,
              sentAt: DateTime.now(),
            ),
          ],
        ),
      );
    } else if (state.messages.any((m) => m.id == _greetingMessageId)) {
      final messages = [
        for (final message in state.messages)
          if (message.id != _greetingMessageId)
            message
          else if (clip.isEmpty)
            message.copyWith(audioPending: false)
          else
            message.copyWith(
              audioBase64: message.hasAudio ? message.audioBase64 : clip,
              audioMediaType: message.hasAudio
                  ? message.audioMediaType
                  : (media.isEmpty ? null : media),
              audioPending: false,
            ),
      ];
      emit(state.copyWith(messages: messages));
    }
    if (playAudio) playHomeGreeting();
  }

  /// Plays session/init greeting audio at most once for this cubit lifetime.
  void playHomeGreeting() {
    if (isClosed || _greetingAudioPlayed) return;
    final clip = _greetingAudioBase64.trim();
    if (clip.isEmpty) return;
    _greetingAudioPlayed = true;
    emit(
      state.copyWith(
        clearTts: true,
        ttsBase64: clip,
        ttsMediaType: _greetingAudioMediaType,
        ttsSpeakText: null,
        ttsNonce: state.ttsNonce + 1,
      ),
    );
  }

  void showHome() {
    emit(state.copyWith(showChat: false));
  }

  void showChat() => emit(state.copyWith(showChat: true));

  /// Chat back / system back from chat → AI home with a cleared thread.
  Future<void> leaveChatToHome() async {
    _voiceGeneration++;
    _startingVoice = false;
    _voiceStopInFlight = false;
    _voiceResumesThread = false;
    _voiceForceNewThread = false;
    _cancelMaxVoiceTimer();
    _resetReveal();
    _liveCaption = '';
    _conversationBound = false;
    _cancelTurnSubs();
    await speechToText.cancel();
    await audioRecorder.cancel();
    sendMessageUseCase.detachConversation();
    if (isClosed) return;
    emit(
      state.copyWith(
        showChat: false,
        streaming: false,
        recording: false,
        liveCaption: '',
        messages: const [],
        doctors: const [],
        sectionTitles: const {},
        slots: const [],
        slotDays: const [],
        selectedSlotDayIndex: 0,
        payments: const [],
        quickActions: const [],
        clearAuthResume: true,
        clearTts: true,
        clearError: true,
      ),
    );
  }

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
            sentAt: DateTime.now(),
          ),
        ],
      ),
    );
  }

  /// Slot calendar day chip selection (presentation-only UI index).
  void selectSlotDay(int index) {
    if (index == state.selectedSlotDayIndex) return;
    if (index < 0 || index >= state.slotDays.length) return;
    emit(state.copyWith(selectedSlotDayIndex: index));
  }

  /// Clears the transcript and starts a new [conversation_id].
  void newChat() {
    _cancelTurnSubs();
    _resetReveal();
    unawaited(speechToText.cancel());
    unawaited(audioRecorder.cancel());
    _liveCaption = '';
    _startingVoice = false;
    unawaited(_resetConversation());
  }

  /// Testing: swap SDK host / key, clear the session, and reconnect.
  Future<void> applySdkEndpoint({
    required String baseUrl,
    required String sdkKey,
  }) async {
    final nextBase = baseUrl.trim();
    final nextKey = sdkKey.trim();
    if (nextBase.isEmpty || nextKey.isEmpty) return;

    config.applyOverrides(baseUrl: nextBase, sdkKey: nextKey);
    await config.persistOverrides(preferences);

    _connected = false;
    _sessionInitDoneThisProcess = false;
    _greetingAudioPlayed = false;
    _greetingAudioBase64 = '';
    _greetingAudioMediaType = '';
    _cancelTurnSubs();
    _resetReveal();
    unawaited(speechToText.cancel());
    unawaited(audioRecorder.cancel());
    _liveCaption = '';
    _startingVoice = false;

    final ready = await connect(forceRefresh: true);
    if (ready) _sessionInitDoneThisProcess = true;
    if (isClosed) return;
    await _resetConversation();
  }

  /// Testing: clear runtime overrides and reconnect with dart-define defaults.
  Future<void> resetSdkEndpointToEnvironment() async {
    config.resetToEnvironment();
    await config.clearPersistedOverrides(preferences);

    _connected = false;
    _sessionInitDoneThisProcess = false;
    _greetingAudioPlayed = false;
    _greetingAudioBase64 = '';
    _greetingAudioMediaType = '';
    _cancelTurnSubs();
    _resetReveal();
    unawaited(speechToText.cancel());
    unawaited(audioRecorder.cancel());
    _liveCaption = '';
    _startingVoice = false;

    final ready = await connect(forceRefresh: true);
    if (ready) _sessionInitDoneThisProcess = true;
    if (isClosed) return;
    await _resetConversation();
  }

  Future<void> _resetConversation() async {
    await sendMessageUseCase.newConversation();
    _conversationBound = true;
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
        sectionTitles: const {},
        slots: const [],
        slotDays: const [],
        selectedSlotDayIndex: 0,
        payments: const [],
        quickActions: const [],
        clearAuthResume: true,
        clearTts: true,
        clearError: true,
      ),
    );
    _seedSdkGreeting(playAudio: false);
  }

  /// Continue previous — reuses the stashed history thread, even if this
  /// window already minted a different id.
  Future<void> resumeLastComplaint() async {
    final text = state.lastComplaint?.trim() ?? '';
    if (text.isEmpty) {
      showChat();
      return;
    }
    _cancelTurnSubs();
    unawaited(speechToText.cancel());
    unawaited(audioRecorder.cancel());
    if (_resumeConversationId.isEmpty) {
      _resumeConversationId = sendMessageUseCase.peekPersistedConversationId();
    }
    _conversationBound = false;
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
        sectionTitles: const {},
        slots: const [],
        slotDays: const [],
        selectedSlotDayIndex: 0,
        payments: const [],
        quickActions: const [],
        clearAuthResume: true,
        clearTts: true,
        clearError: true,
      ),
    );
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

  /// Common concerns and What I can do always leave the previous thread.
  Future<void> _beginNewThread() async {
    _cancelTurnSubs();
    _conversationBound = false;
    if (isClosed) return;
    emit(
      state.copyWith(
        streaming: false,
        recording: false,
        emergencyVisible: false,
        thinkingStage: 'listening',
        liveCaption: '',
        messages: const [],
        doctors: const [],
        sectionTitles: const {},
        slots: const [],
        slotDays: const [],
        selectedSlotDayIndex: 0,
        payments: const [],
        quickActions: const [],
        clearAuthResume: true,
        clearTts: true,
        clearError: true,
      ),
    );
  }

  /// History follows the thread that just received a turn.
  Future<void> _rememberThread() async {
    await sendMessageUseCase.rememberCurrentAsHistory();
    final id = sendMessageUseCase.peekPersistedConversationId();
    if (id.isNotEmpty) _resumeConversationId = id;
  }

  Future<void> sendText(
    String raw, {
    bool isVoice = false,
    bool resumeThread = false,
    bool forceNewThread = false,
    String? displayText,
    bool persistComplaint = true,
  }) async {
    final text = raw.trim();
    if (text.isEmpty) return;
    final shown = (displayText ?? text).trim();
    if (forceNewThread) {
      await _beginNewThread();
    } else if (state.streaming) {
      return;
    }
    if (isClosed) return;
    final ready = await connect();
    if (!ready || isClosed) return;
    await _ensureThread(resume: forceNewThread ? false : resumeThread);
    if (isClosed) return;
    await _rememberThread();

    _lastSendChannel = isVoice
        ? ApnaClinicAiAnalyticsChannelKeys.voice
        : ApnaClinicAiAnalyticsChannelKeys.text;
    ApnaClinicAiAnalytics.logMessageSent(
      channel: _lastSendChannel,
      isGuest: state.isGuest,
      conversationId: sendMessageUseCase.peekPersistedConversationId(),
    );

    final critical = ApnaClinicAiEmergency.isCritical(shown);
    if (persistComplaint) {
      await localDataSource.saveComplaint(shown);
      _loadComplaint();
    }

    final assistantId = _nextId();
    _beginReveal(assistantId);
    emit(
      state.copyWith(
        showChat: true,
        streaming: true,
        thinkingStage: isVoice ? 'transcribing' : 'listening',
        emergencyVisible: state.emergencyVisible || critical,
        signInRequired: false,
        doctors: const [],
        sectionTitles: const {},
        slots: const [],
        slotDays: const [],
        selectedSlotDayIndex: 0,
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
            text: shown.isEmpty ? text : shown,
            isVoice: isVoice,
            sentAt: DateTime.now(),
          ),
          ApnaClinicAiMessageEntity(
            id: assistantId,
            role: ApnaClinicAiMessageRole.assistant,
            text: '',
            isVoice: isVoice,
            pending: true,
            showEmergencyNote: critical,
            sentAt: DateTime.now(),
          ),
        ],
      ),
    );

    // Request server TTS only when voice.output.enabled; Play shows after clip.
    // Keep earlier turns listening so their delayed audio can still attach.
    _turnSubs[assistantId] = sendMessageUseCase
        .call(
          SendApnaClinicAiMessageParams(
            message: text,
            speak: state.voiceOutputEnabled,
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
              // No local TTS / autoplay — reply first; play only after server clip.
              _completeTurn(assistantId: assistantId, turn: event.turn);
            } else if (event is ApnaClinicAiStreamAudio) {
              _attachDelayedAudio(
                assistantId: assistantId,
                turnId: event.turnId,
                audioBase64: event.audioBase64,
                audioMediaType: event.audioMediaType,
              );
            }
          },
          onError: (_) {
            _turnSubs.remove(assistantId);
            if (isClosed) return;
            _finishAssistant(
              assistantId,
              text: '',
              failureCode: ApnaClinicAiFailureCodes.connectFailed,
            );
          },
          onDone: () => _onTurnClosed(assistantId),
        );
  }

  Future<void> toggleListening({
    String? languageCode,
    bool resumeThread = false,
    bool forceNewThread = false,
  }) async {
    if (state.recording) {
      await stopListeningAndSend();
      return;
    }
    if (_startingVoice) return;
    _voiceForceNewThread = forceNewThread;
    _voiceResumesThread = forceNewThread ? false : resumeThread;
    _applyVoiceLanguageDefault(languageCode);
    // Clear any previous chat before the chat UI opens for home voice.
    if (forceNewThread) {
      await _beginNewThread();
      if (isClosed) return;
    }
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
    await audioRecorder.cancel();
    if (isClosed) return;
    _liveCaption = '';
    emit(state.copyWith(recording: false, liveCaption: ''));
    await startListening();
  }

  void _cancelMaxVoiceTimer() {
    _maxVoiceTimer?.cancel();
    _maxVoiceTimer = null;
  }

  void _armMaxVoiceTimer(int generation) {
    _cancelMaxVoiceTimer();
    _maxVoiceTimer = Timer(
      ApnaClinicAiAudioRecorderService.maxDuration,
      () {
        if (isClosed || generation != _voiceGeneration) return;
        if (!state.recording) return;
        unawaited(stopListeningAndSend());
      },
    );
  }

  Future<void> cancelListening() async {
    _voiceGeneration++;
    _startingVoice = false;
    _voiceResumesThread = false;
    _cancelMaxVoiceTimer();
    final leaveEmptyChat = _voiceForceNewThread || state.messages.isEmpty;
    _voiceForceNewThread = false;
    ApnaClinicAiAnalytics.logVoiceCancelled(isGuest: state.isGuest);
    await speechToText.cancel();
    await audioRecorder.cancel();
    if (isClosed) return;
    _liveCaption = '';
    emit(
      state.copyWith(
        recording: false,
        liveCaption: '',
        showChat: leaveEmptyChat ? false : state.showChat,
        messages: leaveEmptyChat ? const [] : state.messages,
        clearTts: leaveEmptyChat,
        clearError: true,
      ),
    );
  }

  Future<void> startListening() async {
    if (state.recording || _startingVoice) return;
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

    final recordingStarted = await audioRecorder.start();
    if (isClosed || generation != _voiceGeneration) {
      _startingVoice = false;
      await audioRecorder.cancel();
      return;
    }
    if (!recordingStarted) {
      _startingVoice = false;
      _setError(ApnaClinicAiFailureCodes.voiceUnavailable);
      return;
    }

    _liveCaption = '';
    // Do not start speech-to-text here. It takes the mic and the WAV
    // ends up a few KB, which the server rejects as no speech.
    await speechToText.cancel();
    emit(
      state.copyWith(
        showChat: true,
        recording: true,
        liveCaption: '',
        clearError: true,
      ),
    );
    ApnaClinicAiAnalytics.logVoiceStarted(isGuest: state.isGuest);
    _armMaxVoiceTimer(generation);

    if (isClosed || generation != _voiceGeneration) {
      _startingVoice = false;
      _cancelMaxVoiceTimer();
      if (!_voiceStopInFlight) {
        await speechToText.cancel();
        await audioRecorder.cancel();
      }
      return;
    }
    _startingVoice = false;
  }

  Future<void> stopListeningAndSend() async {
    if (_voiceStopInFlight) return;
    if (!state.recording &&
        !speechToText.isListening &&
        !audioRecorder.isRecording &&
        !_startingVoice) {
      return;
    }
    _voiceStopInFlight = true;
    _startingVoice = false;
    _cancelMaxVoiceTimer();
    _voiceGeneration++;
    final heardSpeech =
        state.recording ||
        speechToText.isListening ||
        audioRecorder.isRecording ||
        _liveCaption.isNotEmpty;
    try {
      final audioFuture = audioRecorder.stop();
      await speechToText.stop();
      if (isClosed) return;
      final spoken = _inVoiceScript(
        _liveCaption.trim().isNotEmpty
            ? _liveCaption.trim()
            : speechToText.lastRecognized.trim(),
      );
      final audioBytes = await audioFuture;
      _liveCaption = '';
      emit(state.copyWith(recording: false, liveCaption: ''));

      if (audioBytes == null || audioBytes.isEmpty) {
        if (heardSpeech) {
          _setError(ApnaClinicAiFailureCodes.emptyRecording);
        }
        return;
      }

      await sendAudio(
        audioBytes,
        fallbackMessage: spoken.isEmpty ? null : spoken,
      );
    } finally {
      _voiceStopInFlight = false;
    }
  }

  Future<void> sendAudio(
    List<int> audioBytes, {
    String? fallbackMessage,
  }) async {
    if (audioBytes.isEmpty) return;
    final ready = await connect();
    if (!ready || isClosed) return;
    final forceNew = _voiceForceNewThread;
    final resumeVoice = _voiceResumesThread;
    _voiceForceNewThread = false;
    _voiceResumesThread = false;
    if (forceNew) {
      await _beginNewThread();
      if (isClosed) return;
    }
    await _ensureThread(resume: forceNew ? false : resumeVoice);
    if (isClosed) return;
    await _rememberThread();

    _lastSendChannel = ApnaClinicAiAnalyticsChannelKeys.voice;
    ApnaClinicAiAnalytics.logVoiceSent(isGuest: state.isGuest);
    ApnaClinicAiAnalytics.logMessageSent(
      channel: ApnaClinicAiAnalyticsChannelKeys.voice,
      isGuest: state.isGuest,
      conversationId: sendMessageUseCase.peekPersistedConversationId(),
    );

    final spoken = fallbackMessage?.trim() ?? '';
    final critical = spoken.isNotEmpty && ApnaClinicAiEmergency.isCritical(spoken);
    if (spoken.isNotEmpty) {
      await localDataSource.saveComplaint(spoken);
      _loadComplaint();
    }

    final userId = _nextId();
    final assistantId = _nextId();
    final clipBase64 = base64Encode(audioBytes);
    final clipType = isApnaClinicAiWav(audioBytes) ? 'audio/wav' : 'audio/mp4';
    emit(
      state.copyWith(
        showChat: true,
        streaming: true,
        thinkingStage: 'transcribing',
        emergencyVisible: state.emergencyVisible || critical,
        signInRequired: false,
        doctors: const [],
        sectionTitles: const {},
        slots: const [],
        slotDays: const [],
        selectedSlotDayIndex: 0,
        payments: const [],
        quickActions: const [],
        clearAuthResume: true,
        clearTts: true,
        clearError: true,
        messages: [
          ...state.messages,
          ApnaClinicAiMessageEntity(
            id: userId,
            role: ApnaClinicAiMessageRole.user,
            text: '',
            isVoice: true,
            audioBase64: clipBase64,
            audioMediaType: clipType,
            sentAt: DateTime.now(),
          ),
          ApnaClinicAiMessageEntity(
            id: assistantId,
            role: ApnaClinicAiMessageRole.assistant,
            text: '',
            isVoice: true,
            pending: true,
            showEmergencyNote: critical,
            sentAt: DateTime.now(),
          ),
        ],
      ),
    );
    _beginReveal(assistantId);

    final language = state.voiceLanguageCode == 'ur' ? 'ur' : 'auto';
    _turnSubs[assistantId] = sendAudioUseCase
        .call(
          SendApnaClinicAiAudioParams(
            audioBytes: audioBytes,
            fallbackMessage: fallbackMessage,
            speak: state.voiceOutputEnabled,
            language: language,
          ),
        )
        .listen(
          (event) {
            if (isClosed) return;
            if (event is ApnaClinicAiStreamTranscription) {
              final words = event.text.trim();
              if (words.isEmpty) return;
              unawaited(localDataSource.saveComplaint(words));
              final messages = state.messages.map((message) {
                if (message.id != userId) return message;
                return message.copyWith(text: words);
              }).toList();
              emit(state.copyWith(messages: messages));
            } else if (event is ApnaClinicAiStreamToken) {
              _onToken(assistantId, event.accumulated);
            } else if (event is ApnaClinicAiStreamStage) {
              emit(state.copyWith(thinkingStage: event.stage));
            } else if (event is ApnaClinicAiStreamFailure) {
              _finishAssistant(assistantId, text: '', failureCode: event.code);
            } else if (event is ApnaClinicAiStreamFinal) {
              // Show reply now; play button appears when delayed audio maps by turn_id.
              _completeTurn(assistantId: assistantId, turn: event.turn);
            } else if (event is ApnaClinicAiStreamAudio) {
              _attachDelayedAudio(
                assistantId: assistantId,
                turnId: event.turnId,
                audioBase64: event.audioBase64,
                audioMediaType: event.audioMediaType,
              );
            }
          },
          onError: (_) {
            _turnSubs.remove(assistantId);
            if (isClosed) return;
            _finishAssistant(
              assistantId,
              text: '',
              failureCode: ApnaClinicAiFailureCodes.connectFailed,
            );
          },
          onDone: () => _onTurnClosed(assistantId),
        );
  }

  String _inVoiceScript(String text) {
    final words = text.trim();
    if (words.isEmpty || state.voiceLanguageCode != 'ur') return words;
    return RomanUrdu.toNative(words);
  }

  void _cancelTurnSubs() {
    for (final sub in _turnSubs.values) {
      unawaited(sub.cancel());
    }
    _turnSubs.clear();
  }

  /// Drops a finished listen. Does not clear [streaming] while a newer turn
  /// is still open — that was wiping the second voice and the first clip.
  void _onTurnClosed(String assistantId) {
    _turnSubs.remove(assistantId);
    if (isClosed) return;
    if (_newerTurnOpen(assistantId)) return;
    if (state.streaming && _revealTimer == null && !_revealFinalized) {
      emit(state.copyWith(streaming: false));
    }
  }

  bool _newerTurnOpen(String assistantId) {
    final mine = _messageOrder(assistantId);
    for (final id in _turnSubs.keys) {
      if (id != assistantId && _messageOrder(id) > mine) return true;
    }
    return false;
  }

  int _messageOrder(String id) {
    if (!id.startsWith('m')) return 0;
    return int.tryParse(id.substring(1)) ?? 0;
  }

  /// True when [assistantId] is an earlier bubble than the one now revealing.
  bool _isOlderThanActive(String assistantId) {
    if (_revealAssistantId.isEmpty || _revealAssistantId == assistantId) {
      return false;
    }
    return _messageOrder(assistantId) < _messageOrder(_revealAssistantId);
  }

  void _beginReveal(String assistantId) {
    if (_revealAssistantId.isNotEmpty && _revealAssistantId != assistantId) {
      final previous = _revealAssistantId;
      final pending = _revealPendingTurn;
      final text = _revealTarget.isNotEmpty ? _revealTarget : _revealShown;
      _resetReveal();
      if (text.trim().isNotEmpty) _snapAssistantText(previous, text);
      if (pending != null) _applySettledTurn(previous, pending);
    } else {
      _resetReveal();
    }
    _revealAssistantId = assistantId;
  }

  void _resetReveal() {
    _revealTimer?.cancel();
    _revealTimer = null;
    _revealAssistantId = '';
    _revealTarget = '';
    _revealShown = '';
    _revealFinalized = false;
    _revealPendingTurn = null;
    _revealKeepChips = false;
  }

  void _ensureRevealTimer() {
    if (_revealTimer != null) return;
    _revealTimer = Timer.periodic(
      const Duration(milliseconds: 42),
      (_) => _tickReveal(),
    );
  }

  void _onToken(String assistantId, String accumulated) {
    if (_isOlderThanActive(assistantId)) {
      _snapAssistantText(assistantId, accumulated);
      return;
    }
    if (_revealAssistantId != assistantId) _beginReveal(assistantId);
    _revealTarget = accumulated;
    _ensureRevealTimer();
    _tickReveal();
  }

  void _tickReveal() {
    if (isClosed) {
      _resetReveal();
      return;
    }
    if (_revealAssistantId.isEmpty) return;

    final behind = _revealTarget.length - _revealShown.length;
    if (behind <= 0) {
      if (_revealFinalized) _finishReveal();
      return;
    }

    // Slow while streaming; mild catch-up after final so we don't lag forever.
    final step = _revealFinalized
        ? (behind > 100
              ? 5
              : behind > 40
              ? 3
              : behind > 12
              ? 2
              : 1)
        : (behind > 60
              ? 2
              : 1);
    final nextLen = (_revealShown.length + step).clamp(0, _revealTarget.length);
    _revealShown = _revealTarget.substring(0, nextLen);
    _emitRevealText();
    if (_revealFinalized && _revealShown.length >= _revealTarget.length) {
      _finishReveal();
    }
  }

  void _emitRevealText() {
    final assistantId = _revealAssistantId;
    if (assistantId.isEmpty || isClosed) return;
    final showText = _revealShown.trim().isNotEmpty;
    final messages = state.messages.map((message) {
      if (message.id != assistantId) return message;
      return message.copyWith(
        text: showText ? _revealShown : message.text,
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

  /// Applies chips / cards / streaming:false after typewriter catches the final.
  void _finishReveal() {
    final turn = _revealPendingTurn;
    final assistantId = _revealAssistantId;
    final shown = _revealShown;
    final keepChips = _revealKeepChips;
    _revealTimer?.cancel();
    _revealTimer = null;
    _revealFinalized = false;
    _revealPendingTurn = null;

    if (isClosed || assistantId.isEmpty) {
      _resetReveal();
      return;
    }

    if (turn == null) {
      final messages = state.messages.map((message) {
        if (message.id != assistantId) return message;
        return message.copyWith(text: shown, pending: false);
      }).toList();
      emit(state.copyWith(streaming: false, messages: messages));
      _resetReveal();
      return;
    }

    final clip = (turn.audioBase64 ?? '').trim();
    final reply = turn.reply.trim();
    final turnId = (turn.turnId ?? '').trim();
    final waitingForAudio = turn.audioPending && clip.isEmpty;
    final messages = state.messages.map((message) {
      if (message.id != assistantId) return message;
      final keepText = reply.isEmpty && message.text.trim().isNotEmpty;
      final keepAudio = clip.isEmpty && message.hasAudio;
      final text = keepText
          ? message.text
          : (shown.isNotEmpty ? shown : turn.reply);
      return message.copyWith(
        text: text,
        pending: false,
        failureCode: keepText ? message.failureCode : turn.failureCode,
        clearFailureCode: !keepText && turn.failureCode == null,
        audioBase64: keepAudio
            ? message.audioBase64
            : (clip.isEmpty ? null : clip),
        audioMediaType:
            keepAudio ? message.audioMediaType : turn.audioMediaType,
        clearAudio: !keepAudio && clip.isEmpty,
        audioPending: keepAudio
            ? false
            : (waitingForAudio || (clip.isEmpty && message.audioPending)),
        turnId: turnId.isEmpty ? message.turnId : turnId,
      );
    }).toList();
    emit(
      state.copyWith(
        streaming: false,
        messages: messages,
        doctors: turn.doctors,
        slots: turn.slots,
        slotDays: turn.slotDays,
        selectedSlotDayIndex: 0,
        payments: turn.payments,
        quickActions: keepChips ? state.quickActions : turn.quickActions,
        sectionTitles: keepChips
            ? {
                ...turn.sectionTitles,
                if ((turn.sectionTitles['chips'] ?? '').isEmpty &&
                    (state.sectionTitles['chips'] ?? '').isNotEmpty)
                  'chips': state.sectionTitles['chips']!,
              }
            : turn.sectionTitles,
        signInRequired: turn.signInRequired,
        authResumeMessage: turn.authResumeMessage,
        authDeepLink: turn.authDeepLink,
        clearAuthResume: !turn.signInRequired,
        clearTts: true,
      ),
    );
    _resetReveal();
  }

  /// Finishes the assistant bubble with reply/chips. Never queues local TTS
  /// or auto-play — the Play control appears only after a server clip is
  /// attached (inline on final, or later via [ApnaClinicAiStreamAudio]).
  ///
  /// Reply text keeps typing out slowly (ChatGPT-style) until it catches the
  /// final; chips / cards land when the typewriter finishes.
  ///
  /// When [ApnaClinicAiTurnEntity.audioPending] is true, audio control waits
  /// until delayed audio maps in by [turn.turnId].
  ///
  /// Empty reply / chips never overwrite a non-empty bubble already shown
  /// (guards against a late empty final after delayed `type: audio`).
  void _completeTurn({
    required String assistantId,
    required ApnaClinicAiTurnEntity turn,
  }) {
    if (_isOlderThanActive(assistantId)) {
      _applySettledTurn(assistantId, turn);
      return;
    }
    final reply = turn.reply.trim();
    ApnaClinicAiAnalytics.logMessageReceived(
      channel: _lastSendChannel,
      isGuest: state.isGuest,
      intent: turn.intent,
      turnId: turn.turnId,
      conversationId: sendMessageUseCase.peekPersistedConversationId(),
    );
    final keepChips =
        reply.isEmpty &&
        turn.quickActions.isEmpty &&
        state.quickActions.isNotEmpty;

    if (_revealAssistantId != assistantId) _beginReveal(assistantId);

    ApnaClinicAiMessageEntity? current;
    for (final message in state.messages) {
      if (message.id == assistantId) {
        current = message;
        break;
      }
    }
    final keepText = reply.isEmpty && (current?.text.trim().isNotEmpty ?? false);
    final nextTarget = keepText ? (current?.text ?? _revealShown) : turn.reply;

    // Never shrink already-shown typewriter text.
    if (nextTarget.length >= _revealShown.length ||
        nextTarget.startsWith(_revealShown) ||
        _revealShown.isEmpty) {
      _revealTarget = nextTarget;
    } else if (nextTarget.isNotEmpty) {
      _revealTarget = nextTarget;
      _revealShown = '';
    }

    _revealPendingTurn = turn;
    _revealKeepChips = keepChips;
    _revealFinalized = true;

    // Attach clip metadata early so Play can appear while text still types.
    final clip = (turn.audioBase64 ?? '').trim();
    final turnId = (turn.turnId ?? '').trim();
    final waitingForAudio = turn.audioPending && clip.isEmpty;
    if (clip.isNotEmpty || waitingForAudio || turnId.isNotEmpty) {
      final messages = state.messages.map((message) {
        if (message.id != assistantId) return message;
        final keepAudio = clip.isEmpty && message.hasAudio;
        return message.copyWith(
          audioBase64: keepAudio
              ? message.audioBase64
              : (clip.isEmpty ? null : clip),
          audioMediaType:
              keepAudio ? message.audioMediaType : turn.audioMediaType,
          clearAudio: !keepAudio && clip.isEmpty,
          audioPending: keepAudio
              ? false
              : (waitingForAudio || (clip.isEmpty && message.audioPending)),
          turnId: turnId.isEmpty ? message.turnId : turnId,
        );
      }).toList();
      emit(state.copyWith(messages: messages, clearTts: true));
    }

    if (_revealTarget.isEmpty ||
        _revealShown.length >= _revealTarget.length) {
      _finishReveal();
      return;
    }
    _ensureRevealTimer();
    _tickReveal();
  }

  /// Attaches delayed SSE `type: audio` by [turnId] (fallback: [assistantId]).
  /// Shows the play button only — does not auto-play or speak on-device.
  void _attachDelayedAudio({
    required String assistantId,
    String? turnId,
    required String audioBase64,
    String? audioMediaType,
  }) {
    final clip = audioBase64.trim();
    if (clip.isEmpty) return;
    final tid = (turnId ?? '').trim();
    var matched = false;
    final messages = state.messages.map((message) {
      final byTurn =
          tid.isNotEmpty && (message.turnId ?? '').trim() == tid;
      final byId = tid.isEmpty && message.id == assistantId;
      if (!byTurn && !byId) return message;
      matched = true;
      return message.copyWith(
        pending: false,
        audioPending: false,
        audioBase64: clip,
        audioMediaType: audioMediaType,
        turnId: tid.isEmpty ? message.turnId : tid,
      );
    }).toList();
    // If turn_id arrived before we stored it on the bubble, fall back to id.
    final resolved = matched
        ? messages
        : messages.map((message) {
            if (message.id != assistantId) return message;
            return message.copyWith(
              pending: false,
              audioPending: false,
              audioBase64: clip,
              audioMediaType: audioMediaType,
              turnId: tid.isEmpty ? message.turnId : tid,
            );
          }).toList();
    emit(state.copyWith(messages: resolved));
  }

  void _snapAssistantText(String assistantId, String text) {
    final shown = text.trim();
    if (shown.isEmpty || isClosed) return;
    var changed = false;
    final messages = state.messages.map((message) {
      if (message.id != assistantId) return message;
      if (message.text == shown && !message.pending) return message;
      changed = true;
      return message.copyWith(text: shown, pending: false);
    }).toList();
    if (changed) emit(state.copyWith(messages: messages));
  }

  /// Writes a finished turn onto its own bubble without touching a newer
  /// turn's cards or the streaming flag.
  void _applySettledTurn(String assistantId, ApnaClinicAiTurnEntity turn) {
    if (isClosed) return;
    final clip = (turn.audioBase64 ?? '').trim();
    final reply = turn.reply.trim();
    final turnId = (turn.turnId ?? '').trim();
    final waitingForAudio = turn.audioPending && clip.isEmpty;
    final messages = state.messages.map((message) {
      if (message.id != assistantId) return message;
      final keepText = reply.isEmpty && message.text.trim().isNotEmpty;
      final keepAudio = clip.isEmpty && message.hasAudio;
      return message.copyWith(
        text: keepText ? message.text : (reply.isNotEmpty ? reply : message.text),
        pending: false,
        failureCode: keepText ? message.failureCode : turn.failureCode,
        clearFailureCode: !keepText && turn.failureCode == null,
        audioBase64: keepAudio
            ? message.audioBase64
            : (clip.isEmpty ? null : clip),
        audioMediaType:
            keepAudio ? message.audioMediaType : turn.audioMediaType,
        clearAudio: !keepAudio && clip.isEmpty,
        audioPending: keepAudio
            ? false
            : (waitingForAudio || (clip.isEmpty && message.audioPending)),
        turnId: turnId.isEmpty ? message.turnId : turnId,
      );
    }).toList();
    emit(state.copyWith(messages: messages));
  }

  void _finishAssistant(
    String assistantId, {
    required String text,
    String? failureCode,
    String? audioBase64,
    String? audioMediaType,
  }) {
    // Failures / stream errors: snap text (no typewriter) on this bubble only.
    if (_revealAssistantId == assistantId) _resetReveal();
    final clip = (audioBase64 ?? '').trim();
    final incoming = text.trim();
    final messages = state.messages.map((message) {
      if (message.id != assistantId) return message;
      // After a good final (+ delayed audio), stream teardown / late failure
      // must not blank the bubble or strip the clip already playing.
      final keepText = incoming.isEmpty && message.text.trim().isNotEmpty;
      final keepAudio = clip.isEmpty && message.hasAudio;
      return message.copyWith(
        text: keepText ? message.text : text,
        pending: false,
        failureCode: keepText ? message.failureCode : failureCode,
        clearFailureCode: !keepText && failureCode == null,
        audioBase64: keepAudio
            ? message.audioBase64
            : (clip.isEmpty ? null : clip),
        audioMediaType:
            keepAudio ? message.audioMediaType : audioMediaType,
        clearAudio: !keepAudio && clip.isEmpty,
        audioPending: keepAudio
            ? false
            : (clip.isNotEmpty ? false : (keepText && message.audioPending)),
      );
    }).toList();
    emit(
      state.copyWith(
        streaming: _newerTurnOpen(assistantId) ? state.streaming : false,
        messages: messages,
      ),
    );
  }

  void _setError(String code) {
    emit(state.copyWith(errorCode: code, errorNonce: state.errorNonce + 1));
  }

  String _nextId() {
    _messageSeq += 1;
    return 'm$_messageSeq';
  }

  /// Stops mic / STT / in-flight turn when the screen is popped.
  /// Also clears chat so the next open does not reuse the previous thread UI.
  Future<void> stopVoiceOnExit() async {
    _voiceGeneration++;
    _startingVoice = false;
    _voiceStopInFlight = false;
    _voiceResumesThread = false;
    _voiceForceNewThread = false;
    _cancelMaxVoiceTimer();
    _resetReveal();
    _liveCaption = '';
    _conversationBound = false;
    _cancelTurnSubs();
    await speechToText.cancel();
    await audioRecorder.cancel();
    sendMessageUseCase.detachConversation();
    if (isClosed) return;
    emit(
      state.copyWith(
        showChat: false,
        streaming: false,
        recording: false,
        liveCaption: '',
        messages: const [],
        doctors: const [],
        sectionTitles: const {},
        slots: const [],
        slotDays: const [],
        selectedSlotDayIndex: 0,
        payments: const [],
        quickActions: const [],
        clearAuthResume: true,
        clearTts: true,
        clearError: true,
      ),
    );
  }

  @override
  Future<void> close() async {
    await stopVoiceOnExit();
    await audioRecorder.dispose();
    return super.close();
  }
}
