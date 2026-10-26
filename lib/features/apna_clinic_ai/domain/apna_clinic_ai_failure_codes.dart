/// Stable error codes mapped to localized copy in the UI.
class ApnaClinicAiFailureCodes {
  ApnaClinicAiFailureCodes._();

  static const String notConfigured = 'not_configured';
  static const String connectFailed = 'connect_failed';
  static const String upstream = 'upstream';
  static const String booking = 'booking';
  static const String voiceUnavailable = 'voice_unavailable';
  static const String emptyRecording = 'empty_recording';
  /// Server STT found no usable speech in the uploaded clip.
  static const String noSpeech = 'no_speech';

  /// Graceful assistant reply when the audio turn reports no speech (400).
  static const String noSpeechReply =
      "I couldn’t hear any speech clearly. Please tap the mic and try speaking again.";
}
