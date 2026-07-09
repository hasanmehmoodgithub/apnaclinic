enum InstantDoctorOtpAction {
  subscribe('subscribe'),
  unsubscribe('unsubscribe');

  const InstantDoctorOtpAction(this.apiValue);

  final String apiValue;
}
