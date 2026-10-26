import 'package:equatable/equatable.dart';

import '../../domain/entities/apna_clinic_ai_card_entity.dart';
import '../../domain/entities/apna_clinic_ai_home_resume_entity.dart';
import '../../domain/entities/apna_clinic_ai_home_tile_entity.dart';
import '../../domain/entities/apna_clinic_ai_message_entity.dart';
import '../apna_clinic_ai_copy.dart';

class ApnaClinicAiState extends Equatable {
  const ApnaClinicAiState({
    this.showChat = false,
    this.streaming = false,
    this.recording = false,
    this.connecting = true,
    this.signInRequired = false,
    this.emergencyVisible = false,
    this.voiceEnabled = false,
    this.voiceOutputEnabled = false,
    this.voiceLanguageCode = 'en',
    this.isGuest = true,
    this.thinkingStage = 'listening',
    this.liveCaption = '',
    this.assistantName = apnaClinicAiDisplayName,
    this.userDisplayName = '',
    this.userImageUrl = '',
    this.welcomeMessage = '',
    this.composerHint = '',
    this.headerSubtitle = '',
    this.suggestions = const [],
    this.homeTiles = const [],
    this.homeResume,
    this.lastComplaint,
    this.lastComplaintAtMillis,
    this.errorCode,
    this.errorNonce = 0,
    this.messages = const [],
    this.doctors = const [],
    this.slots = const [],
    this.slotDays = const [],
    this.payments = const [],
    this.quickActions = const [],
    this.authResumeMessage,
    this.authDeepLink,
    this.ttsBase64,
    this.ttsMediaType,
    this.ttsSpeakText,
    this.ttsNonce = 0,
  });

  final bool showChat;
  final bool streaming;
  final bool recording;
  final bool connecting;
  final bool signInRequired;
  final bool emergencyVisible;
  final bool voiceEnabled;
  final bool voiceOutputEnabled;
  final String voiceLanguageCode;
  final bool isGuest;
  final String thinkingStage;
  final String liveCaption;
  final String assistantName;
  final String userDisplayName;
  final String userImageUrl;
  final String welcomeMessage;
  final String composerHint;
  final String headerSubtitle;
  final List<String> suggestions;
  final List<ApnaClinicAiHomeTileEntity> homeTiles;
  final ApnaClinicAiHomeResumeEntity? homeResume;
  final String? lastComplaint;
  final int? lastComplaintAtMillis;
  final String? errorCode;
  final int errorNonce;
  final List<ApnaClinicAiMessageEntity> messages;
  final List<ApnaClinicAiDoctorCardEntity> doctors;
  final List<ApnaClinicAiSlotEntity> slots;
  final List<ApnaClinicAiSlotDayEntity> slotDays;
  final List<ApnaClinicAiPaymentEntity> payments;
  final List<ApnaClinicAiQuickActionEntity> quickActions;
  final String? authResumeMessage;
  final String? authDeepLink;
  final String? ttsBase64;
  final String? ttsMediaType;
  final String? ttsSpeakText;
  final int ttsNonce;

  bool get hasThread => messages.isNotEmpty;

  ApnaClinicAiState copyWith({
    bool? showChat,
    bool? streaming,
    bool? recording,
    bool? connecting,
    bool? signInRequired,
    bool? emergencyVisible,
    bool? voiceEnabled,
    bool? voiceOutputEnabled,
    String? voiceLanguageCode,
    bool? isGuest,
    String? thinkingStage,
    String? liveCaption,
    String? assistantName,
    String? userDisplayName,
    String? userImageUrl,
    String? welcomeMessage,
    String? composerHint,
    String? headerSubtitle,
    List<String>? suggestions,
    List<ApnaClinicAiHomeTileEntity>? homeTiles,
    ApnaClinicAiHomeResumeEntity? homeResume,
    bool setHomeResume = false,
    String? lastComplaint,
    int? lastComplaintAtMillis,
    String? errorCode,
    int? errorNonce,
    List<ApnaClinicAiMessageEntity>? messages,
    List<ApnaClinicAiDoctorCardEntity>? doctors,
    List<ApnaClinicAiSlotEntity>? slots,
    List<ApnaClinicAiSlotDayEntity>? slotDays,
    List<ApnaClinicAiPaymentEntity>? payments,
    List<ApnaClinicAiQuickActionEntity>? quickActions,
    String? authResumeMessage,
    String? authDeepLink,
    String? ttsBase64,
    String? ttsMediaType,
    String? ttsSpeakText,
    int? ttsNonce,
    bool clearError = false,
    bool clearComplaint = false,
    bool clearTts = false,
    bool clearAuthResume = false,
  }) {
    return ApnaClinicAiState(
      showChat: showChat ?? this.showChat,
      streaming: streaming ?? this.streaming,
      recording: recording ?? this.recording,
      connecting: connecting ?? this.connecting,
      signInRequired: signInRequired ?? this.signInRequired,
      emergencyVisible: emergencyVisible ?? this.emergencyVisible,
      voiceEnabled: voiceEnabled ?? this.voiceEnabled,
      voiceOutputEnabled: voiceOutputEnabled ?? this.voiceOutputEnabled,
      voiceLanguageCode: voiceLanguageCode ?? this.voiceLanguageCode,
      isGuest: isGuest ?? this.isGuest,
      thinkingStage: thinkingStage ?? this.thinkingStage,
      liveCaption: liveCaption ?? this.liveCaption,
      assistantName: assistantName ?? this.assistantName,
      userDisplayName: userDisplayName ?? this.userDisplayName,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      welcomeMessage: welcomeMessage ?? this.welcomeMessage,
      composerHint: composerHint ?? this.composerHint,
      headerSubtitle: headerSubtitle ?? this.headerSubtitle,
      suggestions: suggestions ?? this.suggestions,
      homeTiles: homeTiles ?? this.homeTiles,
      homeResume: setHomeResume ? homeResume : this.homeResume,
      lastComplaint: clearComplaint
          ? null
          : (lastComplaint ?? this.lastComplaint),
      lastComplaintAtMillis: clearComplaint
          ? null
          : (lastComplaintAtMillis ?? this.lastComplaintAtMillis),
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
      errorNonce: errorNonce ?? this.errorNonce,
      messages: messages ?? this.messages,
      doctors: doctors ?? this.doctors,
      slots: slots ?? this.slots,
      slotDays: slotDays ?? this.slotDays,
      payments: payments ?? this.payments,
      quickActions: quickActions ?? this.quickActions,
      authResumeMessage: clearAuthResume
          ? null
          : (authResumeMessage ?? this.authResumeMessage),
      authDeepLink: clearAuthResume
          ? null
          : (authDeepLink ?? this.authDeepLink),
      ttsBase64: clearTts ? ttsBase64 : (ttsBase64 ?? this.ttsBase64),
      ttsMediaType: clearTts
          ? ttsMediaType
          : (ttsMediaType ?? this.ttsMediaType),
      ttsSpeakText: clearTts
          ? ttsSpeakText
          : (ttsSpeakText ?? this.ttsSpeakText),
      ttsNonce: ttsNonce ?? this.ttsNonce,
    );
  }

  @override
  List<Object?> get props => [
    showChat,
    streaming,
    recording,
    connecting,
    signInRequired,
    emergencyVisible,
    voiceEnabled,
    voiceOutputEnabled,
    voiceLanguageCode,
    isGuest,
    thinkingStage,
    liveCaption,
    assistantName,
    userDisplayName,
    userImageUrl,
    welcomeMessage,
    composerHint,
    headerSubtitle,
    suggestions,
    homeTiles,
    homeResume,
    lastComplaint,
    lastComplaintAtMillis,
    errorCode,
    errorNonce,
    messages,
    doctors,
    slots,
    slotDays,
    payments,
    quickActions,
    authResumeMessage,
    authDeepLink,
    ttsBase64,
    ttsMediaType,
    ttsSpeakText,
    ttsNonce,
  ];
}
