/// Number extensions for formatting and calculations
extension NumExtensions on num {
  /// Format number as currency
  String toCurrency({
    String symbol = '\$',
    int decimals = 2,
    String? locale,
  }) {
    return '$symbol${toStringAsFixed(decimals)}';
  }

  /// Format number with thousand separator
  String toFormattedString({String separator = ','}) {
    final parts = toStringAsFixed(0).split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';
    
    String result = '';
    for (int i = integerPart.length - 1, count = 0; i >= 0; i--, count++) {
      if (count > 0 && count % 3 == 0) {
        result = separator + result;
      }
      result = integerPart[i] + result;
    }
    
    return result + decimalPart;
  }

  /// Format as percentage
  String toPercentage({int decimals = 0}) {
    return '${toStringAsFixed(decimals)}%';
  }

  /// Format as file size (bytes to KB, MB, GB, etc.)
  String toFileSize({int decimals = 2}) {
    if (this < 1024) return '${toStringAsFixed(0)} B';
    if (this < 1024 * 1024) {
      return '${(this / 1024).toStringAsFixed(decimals)} KB';
    }
    if (this < 1024 * 1024 * 1024) {
      return '${(this / (1024 * 1024)).toStringAsFixed(decimals)} MB';
    }
    return '${(this / (1024 * 1024 * 1024)).toStringAsFixed(decimals)} GB';
  }

  /// Format as duration (milliseconds to readable format)
  String toDuration() {
    final seconds = (this / 1000).floor();
    final minutes = (seconds / 60).floor();
    final hours = (minutes / 60).floor();
    final days = (hours / 24).floor();

    if (days > 0) {
      return '${days}d ${hours % 24}h ${minutes % 60}m';
    } else if (hours > 0) {
      return '${hours}h ${minutes % 60}m ${seconds % 60}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds % 60}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Clamp number between min and max
  num clampBetween(num min, num max) {
    assert(min <= max);
    return this < min ? min : (this > max ? max : this);
  }

  /// Check if number is between min and max (inclusive)
  bool isBetween(num min, num max) {
    return this >= min && this <= max;
  }

  /// Check if number is positive
  bool get isPositive => this > 0;

  /// Check if number is negative
  bool get isNegative => this < 0;

  /// Check if number is zero
  bool get isZero => this == 0;

  /// Get absolute value
  num get abs => this < 0 ? -this : this;

  /// Round to nearest integer
  int get roundToInt => round();

  /// Floor to integer
  int get floorToInt => floor();

  /// Ceil to integer
  int get ceilToInt => ceil();

  /// Convert to int (safe)
  int? toIntOrNull() {
    try {
      return toInt();
    } catch (_) {
      return null;
    }
  }

  /// Convert to double (safe)
  double? toDoubleOrNull() {
    try {
      return toDouble();
    } catch (_) {
      return null;
    }
  }

  /// Format as time (HH:mm:ss)
  String toTimeString() {
    final totalSeconds = toInt();
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// Format as compact number (1K, 1M, etc.)
  String toCompactString({int decimals = 1}) {
    if (this < 1000) return toStringAsFixed(0);
    if (this < 1000000) {
      return '${(this / 1000).toStringAsFixed(decimals)}K';
    }
    if (this < 1000000000) {
      return '${(this / 1000000).toStringAsFixed(decimals)}M';
    }
    return '${(this / 1000000000).toStringAsFixed(decimals)}B';
  }
}
