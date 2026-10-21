/// Short catalog search text from a prescription medicine line.
String prescriptionCatalogQuery(String raw) {
  final original = raw.trim();
  if (original.isEmpty) return '';

  var text = original.replaceAll(RegExp(r'[^A-Za-z0-9\s\-]'), ' ');
  text = text.replaceAll(
    RegExp(
      r'\b(tab|tabs|tablet|cap|caps|capsule|syp|syrup|inj|injection|mg|ml|mcg)\b',
      caseSensitive: false,
    ),
    ' ',
  );
  text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  final words = text.split(' ').where((word) => word.length > 1).take(3);
  final query = words.join(' ');
  return query.isEmpty ? original : query;
}
