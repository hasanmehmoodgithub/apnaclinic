/// String extensions for common string operations
extension StringExtensions on String {
  /// Check if string is empty or null
  bool get isNullOrEmpty => isEmpty;

  /// Check if string is not empty
  bool get isNotEmpty => !isEmpty;

  /// Check if string is a valid email
  bool get isValidEmail {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(this);
  }

  /// Check if string is a valid phone number (basic validation)
  /// Supports international format and Pakistani numbers
  bool get isValidPhone {
    final cleaned = replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    // Pakistani phone numbers: 92301453343 (13 digits) or 03013244123 (11 digits)
    if (cleaned.startsWith('92') && cleaned.length == 13) {
      return RegExp(r'^92[0-9]{11}$').hasMatch(cleaned);
    }
    if (cleaned.startsWith('0') && cleaned.length == 11) {
      return RegExp(r'^0[0-9]{10}$').hasMatch(cleaned);
    }
    
    // International format: +1234567890 or 1234567890 (10-15 digits)
    return RegExp(r'^\+?[0-9]{10,15}$').hasMatch(cleaned);
  }

  /// Check if string is a valid Pakistani phone number
  /// Supports both formats: 92301453343 (with country code) or 03013244123 (local)
  bool get isValidPakistaniPhone {
    final cleaned = replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    // Format 1: 13 digits starting with 92 (country code)
    if (cleaned.startsWith('92') && cleaned.length == 13) {
      return RegExp(r'^92[0-9]{11}$').hasMatch(cleaned);
    }
    
    // Format 2: 11 digits starting with 0 (local format)
    if (cleaned.startsWith('0') && cleaned.length == 11) {
      return RegExp(r'^0[0-9]{10}$').hasMatch(cleaned);
    }
    
    return false;
  }

  /// Format Pakistani phone number to standard format (92301453343)
  /// Converts local format (03013244123) to international format (92301453343)
  String get formatPakistaniPhone {
    final cleaned = replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    // If already in international format (92...)
    if (cleaned.startsWith('92') && cleaned.length == 13) {
      return cleaned;
    }
    
    // If in local format (0...), convert to international
    if (cleaned.startsWith('0') && cleaned.length == 11) {
      return '92${cleaned.substring(1)}';
    }
    
    // Return as is if not recognized
    return this;
  }

  /// Check if string is a valid URL
  bool get isValidUrl {
    try {
      Uri.parse(this);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Capitalize first letter of each word
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Remove all whitespace
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Remove special characters (keep only alphanumeric and spaces)
  String get removeSpecialChars => replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '');

  /// Get initials (first letter of each word)
  String get initials {
    if (isEmpty) return '';
    final words = trim().split(' ');
    if (words.length == 1) {
      return words[0].isNotEmpty ? words[0][0].toUpperCase() : '';
    }
    return words
        .where((word) => word.isNotEmpty)
        .take(2)
        .map((word) => word[0].toUpperCase())
        .join();
  }

  /// Truncate string with ellipsis
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }

  /// Mask string (e.g., for credit cards, emails)
  String mask({int start = 0, int end = 0, String maskChar = '*'}) {
    if (length <= start + end) return this;
    final visibleStart = substring(0, start);
    final visibleEnd = substring(length - end);
    final masked = maskChar * (length - start - end);
    return '$visibleStart$masked$visibleEnd';
  }

  /// Extract numbers from string
  String get extractNumbers => replaceAll(RegExp(r'[^0-9]'), '');

  /// Extract letters from string
  String get extractLetters => replaceAll(RegExp(r'[^a-zA-Z]'), '');

  /// Check if string contains only numbers
  bool get isNumeric => RegExp(r'^[0-9]+$').hasMatch(this);

  /// Check if string contains only letters
  bool get isAlphabetic => RegExp(r'^[a-zA-Z]+$').hasMatch(this);

  /// Check if string contains only alphanumeric
  bool get isAlphanumeric => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);

  /// Convert string to int (returns null if invalid)
  int? toIntOrNull() {
    return int.tryParse(this);
  }

  /// Convert string to double (returns null if invalid)
  double? toDoubleOrNull() {
    return double.tryParse(this);
  }

  /// Convert string to bool
  bool toBool() {
    return toLowerCase() == 'true' || this == '1';
  }

  /// Remove HTML tags
  String get removeHtmlTags {
    return replaceAll(RegExp(r'<[^>]*>'), '');
  }

  /// Get word count
  int get wordCount {
    if (trim().isEmpty) return 0;
    return trim().split(RegExp(r'\s+')).length;
  }

  /// Check if string is a valid password (min 8 chars, at least one letter and one number)
  bool get isValidPassword {
    if (length < 8) return false;
    return RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9])').hasMatch(this);
  }

  /// Format as currency (simple)
  String toCurrency({String symbol = '\$', int decimals = 2}) {
    final num = toDoubleOrNull();
    if (num == null) return this;
    return '$symbol${num.toStringAsFixed(decimals)}';
  }

  /// Add padding to string
  String pad({int length = 0, String padChar = ' '}) {
    if (this.length >= length) return this;
    return padLeft((length + this.length) ~/ 2, padChar)
        .padRight(length, padChar);
  }
}
