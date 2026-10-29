/// Greeting text + optional spoken clip from session/init JSON.
class ApnaClinicAiSdkGreeting {
  const ApnaClinicAiSdkGreeting({
    this.message = '',
    this.audioBase64 = '',
    this.audioMediaType = '',
  });

  final String message;
  final String audioBase64;
  final String audioMediaType;

  bool get hasAudio => audioBase64.trim().isNotEmpty;

  /// Parses `greeting` + `audio` from init response / cached init file.
  factory ApnaClinicAiSdkGreeting.fromInitMap(Map<String, dynamic>? source) {
    if (source == null) return const ApnaClinicAiSdkGreeting();
    final nested = source['data'];
    final nestedMap = nested is Map
        ? Map<String, dynamic>.from(nested)
        : const <String, dynamic>{};
    final message = (source['greeting'] ?? nestedMap['greeting'] ?? '')
        .toString()
        .trim();
    var audioBase64 = '';
    var audioMediaType = '';
    final audio =
        source['audio'] ??
        source['tts'] ??
        source['speech'] ??
        nestedMap['audio'] ??
        nestedMap['tts'] ??
        nestedMap['speech'];
    if (audio is Map) {
      final raw = audio['base64'] ?? audio['audio_base64'] ?? audio['data'];
      if (raw is String) audioBase64 = raw.trim();
      audioMediaType =
          (audio['media_type'] ?? audio['format'] ?? '').toString().trim();
    } else if (audio is String) {
      audioBase64 = audio.trim();
    }
    if (audioBase64.isEmpty) {
      final top = source['audio_base64'] ?? nestedMap['audio_base64'];
      if (top is String) audioBase64 = top.trim();
    }
    if (audioBase64.isNotEmpty && audioMediaType.isEmpty) {
      audioMediaType = 'audio/wav';
    }
    return ApnaClinicAiSdkGreeting(
      message: message,
      audioBase64: audioBase64,
      audioMediaType: audioMediaType,
    );
  }
}
