/// Normalizes Pakistan mobile numbers to `923…` for SDK `signed_in` mode.
String? normalizeApnaClinicAiMsisdn(String? raw) {
  if (raw == null) return null;
  final digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) return null;
  if (digits.startsWith('92') && digits.length >= 12) return digits;
  if (digits.startsWith('0') && digits.length >= 11) {
    return '92${digits.substring(1)}';
  }
  if (digits.length == 10) return '92$digits';
  return digits;
}
