/// List extensions for common list operations
extension ListExtensions<T> on List<T> {
  /// Get first element or null if empty
  T? get firstOrNull => isEmpty ? null : first;

  /// Get last element or null if empty
  T? get lastOrNull => isEmpty ? null : last;

  /// Get element at index or null if out of bounds
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// Get element at index or default value if out of bounds
  T elementAtOrDefault(int index, T defaultValue) {
    return elementAtOrNull(index) ?? defaultValue;
  }

  /// Check if list is not empty
  bool get isNotEmpty => !isEmpty;

  /// Add item if not null
  void addIfNotNull(T? item) {
    if (item != null) add(item);
  }

  /// Add all items if not null
  void addAllIfNotNull(Iterable<T>? items) {
    if (items != null) addAll(items);
  }

  /// Remove duplicates (keeps first occurrence)
  List<T> get unique {
    return toSet().toList();
  }

  /// Remove duplicates by key
  List<T> uniqueBy<K>(K Function(T) keySelector) {
    final seen = <K>{};
    return where((item) => seen.add(keySelector(item))).toList();
  }

  /// Chunk list into smaller lists
  List<List<T>> chunk(int size) {
    if (size <= 0) return [this];
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }

  /// Get random element
  T? get random {
    if (isEmpty) return null;
    return this[(DateTime.now().millisecondsSinceEpoch % length)];
  }

  /// Shuffle list and return new list
  List<T> get shuffled {
    final list = List<T>.from(this);
    list.shuffle();
    return list;
  }

  /// Get first N elements
  List<T> takeFirst(int count) {
    if (count <= 0) return [];
    return take(count).toList();
  }

  /// Get last N elements
  List<T> takeLast(int count) {
    if (count <= 0) return [];
    if (count >= length) return this;
    return skip(length - count).toList();
  }

  /// Remove all null values
  List<T> get removeNulls {
    return where((item) => item != null).toList();
  }

  /// Group by key
  Map<K, List<T>> groupBy<K>(K Function(T) keySelector) {
    final map = <K, List<T>>{};
    for (final item in this) {
      final key = keySelector(item);
      map.putIfAbsent(key, () => []).add(item);
    }
    return map;
  }

  /// Partition list into two lists based on condition
  List<List<T>> partition(bool Function(T) test) {
    final trueList = <T>[];
    final falseList = <T>[];
    for (final item in this) {
      if (test(item)) {
        trueList.add(item);
      } else {
        falseList.add(item);
      }
    }
    return [trueList, falseList];
  }

  /// Swap two elements
  void swap(int index1, int index2) {
    if (index1 < 0 ||
        index1 >= length ||
        index2 < 0 ||
        index2 >= length ||
        index1 == index2) {
      return;
    }
    final temp = this[index1];
    this[index1] = this[index2];
    this[index2] = temp;
  }

  /// Insert at index if valid
  void insertIfValid(int index, T element) {
    if (index >= 0 && index <= length) {
      insert(index, element);
    }
  }

  /// Remove first occurrence of element
  bool removeFirst(T element) {
    final index = indexOf(element);
    if (index != -1) {
      removeAt(index);
      return true;
    }
    return false;
  }

  /// Remove all occurrences of element
  int removeAll(T element) {
    var count = 0;
    while (remove(element)) {
      count++;
    }
    return count;
  }

  /// Get sum of numeric values (if T is num)
  num get sum {
    if (isEmpty) return 0;
    if (first is! num) return 0;
    return (this as List<num>).fold(0, (a, b) => a + b);
  }

  /// Get average of numeric values (if T is num)
  double get average {
    if (isEmpty) return 0;
    if (first is! num) return 0;
    return (this as List<num>).sum / length;
  }

  /// Get max value (if T is num)
  num? get max {
    if (isEmpty) return null;
    if (first is! num) return null;
    return (this as List<num>).reduce((a, b) => a > b ? a : b);
  }

  /// Get min value (if T is num)
  num? get min {
    if (isEmpty) return null;
    if (first is! num) return null;
    return (this as List<num>).reduce((a, b) => a < b ? a : b);
  }
}
