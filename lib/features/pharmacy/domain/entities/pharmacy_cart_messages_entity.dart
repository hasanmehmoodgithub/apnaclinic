class PharmacyCartMessagesEntity {
  const PharmacyCartMessagesEntity({
    this.disclaimer,
    this.prescriptionNotice,
    this.deliveryNotice,
    this.deliveryChargesNotice,
  });

  final String? disclaimer;
  final String? prescriptionNotice;
  final String? deliveryNotice;
  final String? deliveryChargesNotice;

  bool get hasAny =>
      _hasText(disclaimer) ||
      _hasText(prescriptionNotice) ||
      _hasText(deliveryNotice) ||
      _hasText(deliveryChargesNotice);

  /// First line of API `disclaimer` (e.g. "Disclaimer").
  String? get disclaimerTitle {
    final raw = disclaimer?.trim();
    if (raw == null || raw.isEmpty) return null;
    final breakAt = raw.indexOf('\n');
    if (breakAt < 0) return null;
    final title = raw.substring(0, breakAt).trim();
    return title.isEmpty ? null : title;
  }

  /// Body after the first line of API `disclaimer`.
  String? get disclaimerBody {
    final raw = disclaimer?.trim();
    if (raw == null || raw.isEmpty) return null;
    final breakAt = raw.indexOf('\n');
    if (breakAt < 0) return raw;
    final body = raw.substring(breakAt + 1).trim();
    return body.isEmpty ? raw : body;
  }

  static bool _hasText(String? value) =>
      value != null && value.trim().isNotEmpty;
}
