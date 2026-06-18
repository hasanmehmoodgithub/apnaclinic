import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
  SpeechToTextService({SpeechToText? speech}) : _speech = speech ?? SpeechToText();

  final SpeechToText _speech;

  bool get isListening => _speech.isListening;

  Future<VoiceSearchFailure?> startListening({
    required void Function(String text, bool isFinal) onResult,
    String? localeId,
    Duration listenFor = const Duration(seconds: 30),
    Duration pauseFor = const Duration(seconds: 3),
  }) async {
    final initFailure = await _initializeSpeech();
    if (initFailure != null) {
      return initFailure;
    }

    if (_speech.isListening) {
      await stop();
    }

    var started = false;
    try {
      started = await _speech.listen(
        onResult: (SpeechRecognitionResult result) {
          onResult(result.recognizedWords, result.finalResult);
        },
        listenOptions: SpeechListenOptions(
          cancelOnError: true,
          partialResults: true,
          localeId: localeId,
          listenFor: listenFor,
          pauseFor: pauseFor,
        ),
      );
    } on MissingPluginException {
      return VoiceSearchFailure.pluginNotLinked;
    } on PlatformException catch (error) {
      return _mapPlatformException(error);
    } on Object {
      return VoiceSearchFailure.failed;
    }

    if (!started) {
      return _mapListenFailure();
    }
    return null;
  }

  Future<VoiceSearchFailure?> _initializeSpeech() async {
    if (_speech.isAvailable) return null;

    try {
      final initialized = await _speech.initialize(
        onError: (_) {},
        onStatus: (_) {},
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

  VoiceSearchFailure _mapListenFailure() {
    final lastError = _speech.lastError;
    if (lastError == null) return VoiceSearchFailure.failed;

    switch (lastError.errorMsg) {
      case 'error_audio':
      case 'error_permission':
      case 'error_permission_denied':
        return VoiceSearchFailure.permissionDenied;
      case 'recognizerNotAvailable':
        return VoiceSearchFailure.notAvailable;
      default:
        if (lastError.permanent) {
          return VoiceSearchFailure.notAvailable;
        }
        return VoiceSearchFailure.failed;
    }
  }

  Future<void> stop() async {
    try {
      if (_speech.isListening) {
        await _speech.stop();
      }
    } on MissingPluginException {
      // Plugin not linked — no-op.
    }
  }

  Future<void> cancel() async {
    try {
      if (_speech.isListening) {
        await _speech.cancel();
      }
    } on MissingPluginException {
      // Plugin not linked — no-op.
    }
  }
}
