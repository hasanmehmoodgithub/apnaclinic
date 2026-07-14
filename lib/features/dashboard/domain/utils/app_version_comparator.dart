/// Semantic-ish version compare for `1.2.3` / `1.2.3+4` style strings.
class AppVersionComparator {
  AppVersionComparator._();

  static int compare(String a, String b) {
    final left = _parts(a);
    final right = _parts(b);
    final length = left.length > right.length ? left.length : right.length;
    for (var i = 0; i < length; i++) {
      final ai = i < left.length ? left[i] : 0;
      final bi = i < right.length ? right[i] : 0;
      if (ai != bi) return ai.compareTo(bi);
    }
    return 0;
  }

  static bool isOlderThan(String current, String target) =>
      compare(current, target) < 0;

  static List<int> _parts(String version) {
    final cleaned = version.split('+').first.split('-').first.trim();
    if (cleaned.isEmpty) return const [0];
    return cleaned
        .split('.')
        .map((segment) {
          final digits = segment.replaceAll(RegExp(r'[^0-9]'), '');
          return int.tryParse(digits) ?? 0;
        })
        .toList(growable: false);
  }
}
