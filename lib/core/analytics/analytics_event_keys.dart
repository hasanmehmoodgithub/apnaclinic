/// Event and parameter names. snake_case, ≤40 chars, no `firebase_`/`google_`/`ga_` prefix.
class AnalyticsEventKeys {
  AnalyticsEventKeys._();

  static String onboardingStep(int step) => 'onboarding_step_$step';
  static const onboardingSkipped = 'onboarding_skipped';

  static const aiChatStarted = 'ai_chat_started';
  static const aiChatEnded = 'ai_chat_ended';

  static const searchScreen = 'search_screen';
  static const searchPerformed = 'search_performed';
  static const searchResultClicked = 'search_result_clicked';

  static const instantDocSubscribeClicked = 'instant_doc_subscribe_clicked';
  static const fbMobileSubscribe = 'fb_mobile_subscribe';
  static const startConsultationClicked = 'start_consultation_clicked';
  static const instantDoctorModule = 'instant_doctor_module';
}

class AnalyticsParamKeys {
  AnalyticsParamKeys._();

  static const stepNumber = 'step_number';
  static const callDuration = 'call_duration';
  static const keyword = 'keyword';
  static const medium = 'medium';
  static const type = 'type';
  static const partner = 'partner';
  static const msisdn = 'msisdn';
  static const sourceScreen = 'source_screen';
}

class AnalyticsSearchMediumKeys {
  AnalyticsSearchMediumKeys._();

  static const type = 'Type';
  static const voice = 'Voice';
  static const recent = 'Recent';
  static const popular = 'Popular';
}

class AnalyticsInstantDoctorSourceKeys {
  AnalyticsInstantDoctorSourceKeys._();

  static const banner = 'banner';
  static const bottomTab = 'bottom_tab';
}

class AnalyticsSearchResultTypeKeys {
  AnalyticsSearchResultTypeKeys._();

  static const medicineName = 'medicine_name';
  static const doctor = 'doctor';
  static const lab = 'lab';
  static const surgeryDoctor = 'surgery_doctor';
}
