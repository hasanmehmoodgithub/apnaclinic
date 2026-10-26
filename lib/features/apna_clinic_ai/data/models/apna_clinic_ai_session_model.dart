import 'apna_clinic_ai_home_resume_model.dart';
import 'apna_clinic_ai_home_tile_model.dart';

export 'apna_clinic_ai_home_resume_model.dart';
export 'apna_clinic_ai_home_tile_model.dart';

class ApnaClinicAiSessionModel {
  const ApnaClinicAiSessionModel({
    required this.sessionId,
    required this.conversationId,
    required this.isGuest,
    required this.assistantName,
    required this.suggestions,
    this.welcomeMessage = '',
    this.greetingAudioBase64 = '',
    this.greetingAudioMediaType = '',
    this.composerHint = '',
    this.headerSubtitle = '',
    this.voiceEnabled = false,
    this.voiceOutputEnabled = false,
    this.homeTiles = const [],
    this.homeResume,
  });

  final String sessionId;
  final String conversationId;
  final bool isGuest;
  final String assistantName;
  final List<String> suggestions;
  final String welcomeMessage;

  /// From `POST /session/init` `audio.base64` (spoken greeting).
  final String greetingAudioBase64;
  final String greetingAudioMediaType;
  final String composerHint;
  final String headerSubtitle;
  final bool voiceEnabled;

  /// Server Piper / speak is available (`voice.output.enabled`).
  final bool voiceOutputEnabled;
  final List<ApnaClinicAiHomeTileModel> homeTiles;
  final ApnaClinicAiHomeResumeModel? homeResume;
}
