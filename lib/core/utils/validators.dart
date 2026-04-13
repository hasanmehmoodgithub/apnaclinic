import '../extensions/string_extensions.dart';

/// Validation utilities for form fields
class Validators {
  Validators._(); // Private constructor to prevent instantiation

  /// Required field validation
  /// Returns null if valid, error message if invalid
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  /// Email validation
  /// Returns null if valid, error message if invalid
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.isValidEmail) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Phone validation (supports international and Pakistani numbers)
  /// Returns null if valid, error message if invalid
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!value.isValidPhone) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Pakistani phone validation
  /// Returns null if valid, error message if invalid
  static String? pakistaniPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!value.isValidPakistaniPhone) {
      return 'Please enter a valid Pakistani phone number (e.g., 92301453343 or 03013244123)';
    }
    return null;
  }

  /// Password validation
  /// Returns null if valid, error message if invalid
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.isValidPassword) {
      return 'Password must contain at least one letter and one number';
    }
    return null;
  }

  /// Confirm password validation
  /// Returns null if valid, error message if invalid
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Min length validation
  /// Returns null if valid, error message if invalid
  static String? minLength(String? value, int min) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (value.length < min) {
      return 'Must be at least $min characters';
    }
    return null;
  }

  /// Max length validation
  /// Returns null if valid, error message if invalid
  static String? maxLength(String? value, int max) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    if (value.length > max) {
      return 'Must be at most $max characters';
    }
    return null;
  }

  /// Length range validation
  /// Returns null if valid, error message if invalid
  static String? length(String? value, int min, int max) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (value.length < min || value.length > max) {
      return 'Must be between $min and $max characters';
    }
    return null;
  }

  /// Numeric validation
  /// Returns null if valid, error message if invalid
  static String? numeric(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (!value.isNumeric) {
      return 'Must contain only numbers';
    }
    return null;
  }

  /// Alphabetic validation
  /// Returns null if valid, error message if invalid
  static String? alphabetic(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (!value.isAlphabetic) {
      return 'Must contain only letters';
    }
    return null;
  }

  /// Alphanumeric validation
  /// Returns null if valid, error message if invalid
  static String? alphanumeric(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (!value.isAlphanumeric) {
      return 'Must contain only letters and numbers';
    }
    return null;
  }

  /// Name validation (letters and spaces only)
  /// Returns null if valid, error message if invalid
  static String? name(
    String? value, {
    String? fieldName,
    bool isRequired = true,
  }) {
    final name = fieldName ?? 'Name';

    if (value == null || value.trim().isEmpty) {
      if (isRequired) {
        return '$name is required';
      }
      return null; // Optional field
    }

    // Check if contains only letters, spaces, hyphens, and apostrophes
    if (!RegExp(r"^[a-zA-Z\s'-]+$").hasMatch(value)) {
      return '$name must contain only letters';
    }

    // Check minimum length (at least 2 characters)
    if (value.trim().length < 2) {
      return '$name must be at least 2 characters';
    }

    return null;
  }

  /// URL validation
  /// Returns null if valid, error message if invalid
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }
    if (!value.isValidUrl) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  /// Custom validation
  /// Returns null if valid, error message if invalid
  static String? custom(
    String? value,
    bool Function(String) test,
    String errorMessage,
  ) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (!test(value)) {
      return errorMessage;
    }
    return null;
  }

  /// Combine multiple validators
  /// Returns first error found, or null if all pass
  static String? combine(
    List<String? Function(String?)> validators,
    String? value,
  ) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }

  /// Optional validation (only validates if value is not empty)
  /// Returns null if valid or empty, error message if invalid
  static String? Function(String?) optional(
    String? Function(String?) validator,
  ) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return null; // Optional field, empty is valid
      }
      return validator(value);
    };
  }
}
