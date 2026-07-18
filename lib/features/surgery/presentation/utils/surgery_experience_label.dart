/// Formats surgery doctor years of experience for display.
/// `1` → `1 year`, `2+` → `N years`. Empty / non-numeric passthrough when already labeled.
String formatSurgeryExperienceLabel(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return '';

  final match = RegExp(r'(\d+)').firstMatch(trimmed);
  if (match != null) {
    final years = int.tryParse(match.group(1)!);
    if (years != null) {
      if (years <= 0) return '';
      return years == 1 ? '1 year' : '$years years';
    }
  }

  return trimmed;
}
