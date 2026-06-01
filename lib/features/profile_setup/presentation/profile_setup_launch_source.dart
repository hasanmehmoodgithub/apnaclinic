/// How the user reached [ProfileSetupScreen]; drives back navigation.
enum ProfileSetupLaunchSource {
  onboarding,
  login,
  menu,
  splash,
  unknown,
}

ProfileSetupLaunchSource profileSetupLaunchSourceFromExtra(Object? extra) {
  if (extra is ProfileSetupLaunchSource) return extra;
  return ProfileSetupLaunchSource.unknown;
}
