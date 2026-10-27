import 'package:equatable/equatable.dart';

class ApnaClinicAiSessionEntity extends Equatable {
  const ApnaClinicAiSessionEntity({
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
  });

  final String sessionId;
  final String conversationId;
  final bool isGuest;
  final String assistantName;
  final List<String> suggestions;
  final String welcomeMessage;
  final String greetingAudioBase64;
  final String greetingAudioMediaType;
  final String composerHint;
  final String headerSubtitle;
  final bool voiceEnabled;
  final bool voiceOutputEnabled;

  @override
  List<Object?> get props => [
    sessionId,
    conversationId,
    isGuest,
    assistantName,
    suggestions,
    welcomeMessage,
    greetingAudioBase64,
    greetingAudioMediaType,
    composerHint,
    headerSubtitle,
    voiceEnabled,
    voiceOutputEnabled,
  ];
}
