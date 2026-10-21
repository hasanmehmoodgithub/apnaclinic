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

/// Search uses short queries. Care Companion uses longer dictation.
enum SpeechListenStyle { search, dictation }

/// Thin wrapper around [SpeechToText] for search and Care Companion.
class SpeechToTextService {
  SpeechToTextService({SpeechToText? speech})
    : _speech = speech ?? SpeechToText();

  final SpeechToText _speech;

  bool _sessionActive = false;
  bool _stopping = false;
  String _lastWords = '';
  String? _localeId;
  void Function(String text, bool isFinal)? _onResult;
  VoidCallback? _onSessionDone;

  static const Duration _defaultListenFor = Duration(seconds: 60);
  static const Duration _defaultPauseFor = Duration(seconds: 3);
  Duration _listenFor = _defaultListenFor;
  Duration _pauseFor = _defaultPauseFor;
  SpeechListenStyle _style = SpeechListenStyle.search;

  bool get isListening => _sessionActive;

  /// Latest non-empty transcript from the active or just-finished session.
  String get lastRecognized => _lastWords;

  Future<VoiceSearchFailure?> startListening({
    required void Function(String text, bool isFinal) onResult,
    VoidCallback? onSessionDone,
    String? localeId,
    String? languageCode,
    SpeechListenStyle style = SpeechListenStyle.search,
    Duration listenFor = _defaultListenFor,
    Duration pauseFor = _defaultPauseFor,
  }) async {
    _lastWords = '';
    _listenFor = listenFor;
    _pauseFor = pauseFor;
    _style = style;

    final initFailure = await _initializeSpeech();
    if (initFailure != null) {
      return initFailure;
    }

    if (_speech.isListening) {
      await stop();
    }

    _localeId = languageCode == null
        ? localeId
        : await _matchLocale(languageCode) ?? localeId;
    _onResult = onResult;
    _onSessionDone = onSessionDone;
    _sessionActive = true;
    return _beginListen();
  }

  Future<VoiceSearchFailure?> _beginListen() async {
    try {
      // [listen] returns void; do not treat the Future value as a bool.
      await _speech.listen(
        onResult: (SpeechRecognitionResult result) {
          final words = result.recognizedWords.trim();
          if (words.isNotEmpty) _lastWords = words;
          _onResult?.call(result.recognizedWords, result.finalResult);
        },
        listenOptions: SpeechListenOptions(
          cancelOnError: true,
          partialResults: true,
          listenMode: _style == SpeechListenStyle.dictation
              ? ListenMode.dictation
              : ListenMode.search,
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
    if (!_sessionActive || _stopping) return;
    if (status != SpeechToText.doneStatus) return;
    _endSession(notify: true);
  }

  void _handleError(SpeechRecognitionError error) {
    if (!_sessionActive || _stopping) return;

    switch (error.errorMsg) {
      case 'error_no_match':
      case 'error_speech_timeout':
        _endSession(notify: true);
        return;
      case 'error_busy':
        // Native recognizer still tearing down — do not listen() again.
        return;
      default:
        if (error.permanent) {
          _endSession(notify: true);
        }
    }
  }

  void _endSession({required bool notify}) {
    if (!_sessionActive) return;
    _sessionActive = false;
    if (!notify) return;
    final onDone = _onSessionDone;
    _onResult = null;
    _onSessionDone = null;
    onDone?.call();
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
    if (!_sessionActive && !_speech.isListening) return;
    // Keep the result callback until the recognizer delivers its final words.
    _stopping = true;
    try {
      if (_speech.isListening) {
        await _speech.stop();
        await Future<void>.delayed(const Duration(milliseconds: 320));
      }
    } on Object {
      // Native already stopped / destroyed.
    }
    _stopping = false;
    _endSession(notify: false);
  }

  /// Picks an installed recognizer locale for [languageCode] (`en` or `ur`).
  Future<String?> _matchLocale(String languageCode) async {
    final urdu = languageCode.toLowerCase().startsWith('ur');
    try {
      final available = await _speech.locales();
      final ids = available.map((locale) => locale.localeId).toList();
      final wanted = languageCode.toLowerCase().startsWith('ur')
          ? const ['ur_PK', 'ur_IN', 'ur']
          : const ['en_PK', 'en_US', 'en_GB', 'en'];
      for (final candidate in wanted) {
        for (final id in ids) {
          if (_localeKey(id) == _localeKey(candidate)) return id;
        }
      }
      final prefix = languageCode.toLowerCase().startsWith('ur') ? 'ur' : 'en';
      for (final id in ids) {
        if (_localeKey(id).startsWith(prefix)) return id;
      }
    } on Object {
      return urdu ? 'ur_PK' : null;
    }
    // Urdu must stay ur-PK so the recognizer returns native script, not Roman.
    return urdu ? 'ur_PK' : null;
  }

  String _localeKey(String localeId) =>
      localeId.toLowerCase().replaceAll('-', '_');

  Future<void> cancel() async {
    _stopping = false;
    _lastWords = '';
    _endSession(notify: false);
    try {
      if (_speech.isListening) {
        await _speech.cancel();
      }
    } on Object {
      // Native already stopped / destroyed.
    }
  }
}
