/// Firebase event / param keys for Care Companion (`ApnaClinicAiScreen`).
/// Separate from [AnalyticsEventKeys.aiChatStarted] (AI screening WebView).
class ApnaClinicAiAnalyticsEventKeys {
  ApnaClinicAiAnalyticsEventKeys._();

  static const opened = 'apna_clinic_ai_opened';
  static const closed = 'apna_clinic_ai_closed';
  static const messageSent = 'apna_clinic_ai_message_sent';
  static const messageReceived = 'apna_clinic_ai_message_received';
  static const voiceStarted = 'apna_clinic_ai_voice_started';
  static const voiceSent = 'apna_clinic_ai_voice_sent';
  static const voiceCancelled = 'apna_clinic_ai_voice_cancelled';
}

class ApnaClinicAiAnalyticsParamKeys {
  ApnaClinicAiAnalyticsParamKeys._();

  static const source = 'source';
  static const channel = 'channel';
  static const guest = 'guest';
  static const intent = 'intent';
  static const conversationId = 'conversation_id';
  static const turnId = 'turn_id';
}

class ApnaClinicAiAnalyticsSourceKeys {
  ApnaClinicAiAnalyticsSourceKeys._();

  static const homeFab = 'home_fab';
  static const dashboardMenu = 'dashboard_menu';
  static const consultationStartNow = 'consultation_start_now';
  static const unknown = 'unknown';
}

class ApnaClinicAiAnalyticsChannelKeys {
  ApnaClinicAiAnalyticsChannelKeys._();

  static const text = 'text';
  static const voice = 'voice';
}
