class InstantDoctorConsultationArgs {
  const InstantDoctorConsultationArgs({
    required this.url,
    required this.title,
  });

  final String url;
  final String title;
}

InstantDoctorConsultationArgs? instantDoctorConsultationArgsFromExtra(
  Object? extra,
) {
  if (extra is InstantDoctorConsultationArgs) return extra;
  return null;
}
