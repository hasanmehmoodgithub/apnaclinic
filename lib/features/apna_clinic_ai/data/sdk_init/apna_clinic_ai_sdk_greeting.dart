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
    final message = (source['greeting'] ?? '').toString().trim();
    var audioBase64 = '';
    var audioMediaType = '';
    final audio = source['audio'];
    if (audio is Map) {
      audioBase64 = (audio['base64'] ?? '').toString().trim();
      audioMediaType =
          (audio['media_type'] ?? audio['format'] ?? '').toString().trim();
    }
    return ApnaClinicAiSdkGreeting(
      message: message,
      audioBase64: audioBase64,
      audioMediaType: audioMediaType,
    );
  }
}
