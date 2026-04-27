import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/search_entity.dart';


/// Simple local store for recent searches.
///
/// Persists the latest searches to SharedPreferences so they survive
/// app restarts. Newest entry is always at index 0; duplicates are
/// deduped (case-insensitive) and the list is capped.
class RecentSearchesStore {
  RecentSearchesStore(this._prefs);

  static const String _key = 'search.recent_searches.v1';
  static const int _maxEntries = 12;

  final SharedPreferences _prefs;

  List<SearchRecentEntity> load() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = json.decode(raw);
      if (decoded is! List) return const [];
      return decoded
          .whereType<Map>()
          .map(
            (m) => SearchRecentEntity(
          title: (m['title'] ?? '').toString(),
          subtitle: (m['subtitle'] ?? '').toString(),
        ),
      )
          .where((e) => e.title.isNotEmpty)
          .toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  Future<List<SearchRecentEntity>> add(
      String term, {
        String subtitle = 'Recent search',
      }) async {
    final trimmed = term.trim();
    if (trimmed.isEmpty) return load();

    final current = load().toList();
    current.removeWhere(
          (e) => e.title.toLowerCase() == trimmed.toLowerCase(),
    );
    current.insert(
      0,
      SearchRecentEntity(title: trimmed, subtitle: subtitle),
    );
    final capped = current.take(_maxEntries).toList(growable: false);
    await _persist(capped);
    return capped;
  }

  Future<List<SearchRecentEntity>> remove(String term) async {
    final current = load().toList()
      ..removeWhere(
            (e) => e.title.toLowerCase() == term.toLowerCase(),
      );
    await _persist(current);
    return current;
  }

  Future<void> clear() async {
    await _prefs.remove(_key);
  }

  Future<void> _persist(List<SearchRecentEntity> items) async {
    final encoded = json.encode(
      items
          .map((e) => {'title': e.title, 'subtitle': e.subtitle})
          .toList(growable: false),
    );
    await _prefs.setString(_key, encoded);
  }
}