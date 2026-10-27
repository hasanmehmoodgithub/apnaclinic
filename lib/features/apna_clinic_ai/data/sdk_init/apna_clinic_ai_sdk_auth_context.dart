/// Guest or signed-in payload used for `POST /sdk/session/init`.
class ApnaClinicAiSdkAuthContext {
  const ApnaClinicAiSdkAuthContext({
    required this.mode,
    required this.deviceId,
    this.msisdn,
    this.name,
    this.email,
  });

  /// `guest` or `signed_in`.
  final String mode;
  final String deviceId;
  final String? msisdn;
  final String? name;
  final String? email;

  bool get isGuest => mode == 'guest';
  bool get isSignedIn => mode == 'signed_in';
}
