/// Session init input. Auth mode and user fields are resolved in the repository
/// from [AppPref] when omitted (same pattern as Care Companion / Jimi signed-in vs guest).
class InitApnaClinicAiSessionParams {
  const InitApnaClinicAiSessionParams({
    this.forceRefresh = false,
  });

  /// When true, clears cached SDK credentials and re-calls `session/init`.
  final bool forceRefresh;
}
