import 'package:equatable/equatable.dart';

import 'apna_clinic_ai_home_tile_entity.dart';

class ApnaClinicAiSessionEntity extends Equatable {
  const ApnaClinicAiSessionEntity({
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
  final List<ApnaClinicAiHomeTileEntity> homeTiles;

  @override
  List<Object?> get props => [
    sessionId,
    conversationId,
    isGuest,
    assistantName,
    suggestions,
    welcomeMessage,
    voiceEnabled,
    homeTiles,
  ];
}
