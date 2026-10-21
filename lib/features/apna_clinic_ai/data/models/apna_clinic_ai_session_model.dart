import 'apna_clinic_ai_home_tile_model.dart';

export 'apna_clinic_ai_home_tile_model.dart';

class ApnaClinicAiSessionModel {
  const ApnaClinicAiSessionModel({
    required this.sessionId,
    required this.conversationId,
    required this.isGuest,
    required this.assistantName,
    required this.suggestions,
    this.welcomeMessage = '',
    this.voiceEnabled = false,
    this.homeTiles = const [],
  });

  final String sessionId;
  final String conversationId;
  final bool isGuest;
  final String assistantName;
  final List<String> suggestions;
  final String welcomeMessage;
  final bool voiceEnabled;
  final List<ApnaClinicAiHomeTileModel> homeTiles;
}
