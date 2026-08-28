class SearchUiConfig {
  SearchUiConfig._();

  /// Max characters for the global search field, voice transcript, and submit.
  static const int queryMaxLength = 100;

  static String clampQuery(String value) {
    if (value.length <= queryMaxLength) return value;
    return value.substring(0, queryMaxLength);
  }
}
