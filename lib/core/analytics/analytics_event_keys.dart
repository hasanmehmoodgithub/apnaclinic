/// Event and parameter names. snake_case, ≤40 chars, no `firebase_`/`google_`/`ga_` prefix.
class AnalyticsEventKeys {
  AnalyticsEventKeys._();

  static String onboardingStep(int step) => 'onboarding_step_$step';
  static const onboardingSkipped = 'onboarding_skipped';
}

class AnalyticsParamKeys {
  AnalyticsParamKeys._();

  static const stepNumber = 'step_number';
}
