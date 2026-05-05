import '../../../../core/preference/app_pref.dart';

/// Marks onboarding completed in local preferences.
class CompleteOnboardingUseCase {
  const CompleteOnboardingUseCase(this._appPref);

  final AppPref _appPref;

  Future<void> call() {
    return _appPref.setOnboardingCompleted(true);
  }
}
