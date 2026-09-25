class LogInstantDoctorSessionParams {
  const LogInstantDoctorSessionParams({
    required this.startTime,
    required this.endTime,
    required this.instantDocLog,
    required this.providerName,
  });

  /// ISO-8601 local time when the consultation WebView opened.
  final String startTime;

  /// ISO-8601 local time when the user left the consultation WebView.
  final String endTime;

  /// Latest `instant_doc_log` page JSON text, or `""` when none arrived.
  final String instantDocLog;

  /// Instant Doctor provider name, such as BIMA or MedIQ.
  final String providerName;
}
