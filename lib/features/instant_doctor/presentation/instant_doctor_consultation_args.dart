class InstantDoctorConsultationArgs {
  const InstantDoctorConsultationArgs({
    required this.url,
    required this.title,
    this.providerName = '',
  });

  final String url;
  final String title;
  final String providerName;
}

InstantDoctorConsultationArgs? instantDoctorConsultationArgsFromExtra(
  Object? extra,
) {
  if (extra is InstantDoctorConsultationArgs) return extra;
  return null;
}
