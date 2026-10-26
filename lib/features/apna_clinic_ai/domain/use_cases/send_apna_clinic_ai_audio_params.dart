/// Params for multipart audio SSE turn (`/assistant/turn/audio/stream`).
class SendApnaClinicAiAudioParams {
  const SendApnaClinicAiAudioParams({
    required this.audioBytes,
    this.fallbackMessage,
    this.speak = true,
    this.language = 'auto',
    this.voiceId,
  });

  final List<int> audioBytes;

  /// Local device STT text used when audio stream fails (502 / timeout).
  final String? fallbackMessage;
  final bool speak;
  final String language;
  final String? voiceId;
}
