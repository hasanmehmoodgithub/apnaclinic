import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Failure codes for voice search; map to l10n in the UI layer.
enum VoiceSearchFailure {
  notAvailable,
  permissionDenied,
  pluginNotLinked,
  failed,
}

/// Thin wrapper around [SpeechToText] for search voice input.
class SpeechToTextService {
  SpeechToTextService({SpeechToText? speech})
    : _speech = speech ?? SpeechToText();

  final SpeechToText _speech;

  bool _sessionActive = false;
  String? _localeId;
  DateTime? _sessionStartedAt;
  void Function(String text, bool isFinal)? _onResult;
  VoidCallback? _onSessionDone;

  static const Duration _defaultListenFor = Duration(seconds: 60);
  static const Duration _defaultPauseFor = Duration(seconds: 3);
  Duration _listenFor = _defaultListenFor;
  Duration _pauseFor = _defaultPauseFor;

  bool get isListening => _sessionActive;

  Future<VoiceSearchFailure?> startListening({
    required void Function(String text, bool isFinal) onResult,
    VoidCallback? onSessionDone,
    String? localeId,
    Duration listenFor = _defaultListenFor,
    Duration pauseFor = _defaultPauseFor,
  }) async {
    _onResult = onResult;
    _onSessionDone = onSessionDone;
    _localeId = localeId;
    _listenFor = listenFor;
    _pauseFor = pauseFor;

    final initFailure = await _initializeSpeech();
    if (initFailure != null) {
      return initFailure;
    }

    if (_speech.isListening) {
      await stop();
    }

    _sessionActive = true;
    _sessionStartedAt = DateTime.now();
    return _beginListen();
  }

  Future<VoiceSearchFailure?> _beginListen() async {
    try {
      // [listen] returns void; do not treat the Future value as a bool.
      await _speech.listen(
        onResult: (SpeechRecognitionResult result) {
          _onResult?.call(result.recognizedWords, result.finalResult);
        },
        listenOptions: SpeechListenOptions(
          cancelOnError: false,
          partialResults: true,
          listenMode: ListenMode.search,
          localeId: _localeId,
          listenFor: _listenFor,
          pauseFor: _pauseFor,
        ),
      );
    } on MissingPluginException {
      _endSession(notify: false);
      return VoiceSearchFailure.pluginNotLinked;
    } on PlatformException catch (error) {
      _endSession(notify: false);
      return _mapPlatformException(error);
    } on Object {
      _endSession(notify: false);
      return VoiceSearchFailure.failed;
    }
    return null;
  }

  Future<VoiceSearchFailure?> _initializeSpeech() async {
    try {
      final initialized = await _speech.initialize(
        onError: _handleError,
        onStatus: _handleStatus,
        debugLogging: kDebugMode,
      );
      if (initialized && _speech.isAvailable) {
        return null;
      }

      final hasMic = await _speech.hasPermission;
      if (!hasMic) {
        return VoiceSearchFailure.permissionDenied;
      }
      return VoiceSearchFailure.notAvailable;
    } on MissingPluginException {
      return VoiceSearchFailure.pluginNotLinked;
    } on PlatformException catch (error) {
      return _mapPlatformException(error);
    } on Object {
      return VoiceSearchFailure.failed;
    }
  }

  void _handleStatus(String status) {
    if (!_sessionActive) return;
    if (status != SpeechToText.doneStatus) return;

    final hasWords = _speech.lastRecognizedWords.trim().isNotEmpty;
    final elapsed = _sessionStartedAt == null
        ? Duration.zero
        : DateTime.now().difference(_sessionStartedAt!);

    if (hasWords || elapsed >= _listenFor) {
      _endSession(notify: true);
      return;
    }

    _restartIfTimeRemains();
  }

  void _handleError(SpeechRecognitionError error) {
    if (!_sessionActive) return;

    switch (error.errorMsg) {
      case 'error_no_match':
      case 'error_speech_timeout':
      case 'error_busy':
        _restartIfTimeRemains();
        return;
      default:
        if (error.permanent) {
          _endSession(notify: true);
        }
    }
  }

  Future<void> _restartIfTimeRemains() async {
    if (!_sessionActive) return;

    final startedAt = _sessionStartedAt;
    if (startedAt != null &&
        DateTime.now().difference(startedAt) >= _listenFor) {
      _endSession(notify: true);
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!_sessionActive || _speech.isListening) return;
    await _beginListen();
  }

  void _endSession({required bool notify}) {
    if (!_sessionActive) return;
    _sessionActive = false;
    if (notify) {
      _onSessionDone?.call();
    }
  }

  VoiceSearchFailure _mapPlatformException(PlatformException error) {
    switch (error.code) {
      case 'recognizerNotAvailable':
        return VoiceSearchFailure.notAvailable;
      case 'error_permission':
      case 'error_permission_denied':
      case 'missingContext':
        return VoiceSearchFailure.permissionDenied;
      default:
        return VoiceSearchFailure.failed;
    }
  }

  Future<void> stop() async {
    _endSession(notify: false);
    try {
      if (_speech.isListening) {
        await _speech.stop();
      }
    } on MissingPluginException {
      // Plugin not linked — no-op.
    }
  }

  Future<void> cancel() async {
    _endSession(notify: false);
    try {
      if (_speech.isListening) {
        await _speech.cancel();
      }
    } on MissingPluginException {
      // Plugin not linked — no-op.
    }
  }
}
