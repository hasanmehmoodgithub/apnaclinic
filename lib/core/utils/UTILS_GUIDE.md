# 🛠️ Utils Guide

Simple guide for understanding and using utility files in your Flutter app.

---

## 📖 What are Utils?

**Utils (Utilities)** are helper classes and functions that provide reusable functionality across your app. They contain:
- **Pure functions** - No side effects, same input = same output
- **Static methods** - Don't need instances, call directly
- **Reusable logic** - Used by multiple features/components
- **Business logic helpers** - Not tied to UI or specific features

---

## 🎯 When to Use Utils?

### ✅ Use Utils For:

1. **Validation Logic**
   - Email, phone, password validation
   - Form field validation rules
   - Input sanitization

2. **Formatting Functions**
   - Date/time formatting
   - Number/currency formatting
   - Text formatting (capitalize, truncate, etc.)

3. **Error Handling**
   - Error message extraction
   - Error type checking
   - Error logging

4. **Data Transformation**
   - Converting between formats
   - Data parsing
   - Data cleaning

5. **Common Calculations**
   - Math operations
   - Date calculations
   - String manipulations

6. **Helper Functions**
   - File operations
   - Network helpers
   - Platform checks

### ❌ Don't Use Utils For:

1. **UI Components** → Use `components/widgets/`
2. **Services** → Use `core/services/`
3. **Extensions** → Use `core/extensions/`
4. **Feature-specific logic** → Put in feature folder
5. **State management** → Use cubits/blocs/repositories

---

## 📁 Common Utils Files

### 1. **validators.dart** - Input Validation

```dart
class Validators {
  /// Required field validation
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  /// Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.isValidEmail) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Phone validation
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone is required';
    }
    if (!value.isValidPhone) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.isValidPassword) {
      return 'Password must contain letters and numbers';
    }
    return null;
  }

  /// Min length validation
  static String? minLength(String? value, int min) {
    if (value == null || value.length < min) {
      return 'Must be at least $min characters';
    }
    return null;
  }

  /// Max length validation
  static String? maxLength(String? value, int max) {
    if (value == null || value.length > max) {
      return 'Must be at most $max characters';
    }
    return null;
  }

  /// Combine multiple validators
  static String? combine(List<String? Function(String?)> validators, String? value) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }
}
```

**Usage:**
```dart
TextFormField(
  validator: Validators.email,
  // or
  validator: (value) => Validators.combine([
    Validators.required,
    Validators.email,
  ], value),
)
```

---

### 2. **error_handler.dart** - Error Handling

```dart
class ErrorHandler {
  /// Get user-friendly error message
  static String getErrorMessage(dynamic error) {
    if (error is ApiException) {
      return error.message;
    } else if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    } else if (error is String) {
      return error;
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Check error types
  static bool isNetworkError(dynamic error) { }
  static bool isAuthError(dynamic error) { }
  static bool isServerError(dynamic error) { }
}
```

**Usage:**
```dart
try {
  await apiCall();
} catch (e) {
  final message = ErrorHandler.getErrorMessage(e);
  context.showErrorSnackBar(message);
}
```

---

### 3. **formatters.dart** - Data Formatting

```dart
class Formatters {
  /// Format currency
  static String currency(double amount, {String symbol = '\$'}) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  /// Format phone number
  static String phone(String phone) {
    // Format: (123) 456-7890
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.length == 10) {
      return '(${cleaned.substring(0, 3)}) ${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
    }
    return phone;
  }

  /// Format date
  static String date(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Format file size
  static String fileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}
```

**Usage:**
```dart
Text(Formatters.currency(1234.56))  // "$1234.56"
Text(Formatters.phone('1234567890'))  // "(123) 456-7890"
```

---

### 4. **date_utils.dart** - Date Helpers

```dart
class DateUtils {
  /// Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day;
  }

  /// Get days between dates
  static int daysBetween(DateTime start, DateTime end) {
    return end.difference(start).inDays;
  }

  /// Format relative time
  static String relativeTime(DateTime date) {
    return date.timeAgo();
  }
}
```

---

### 5. **string_utils.dart** - String Helpers

```dart
class StringUtils {
  /// Truncate with ellipsis
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  /// Extract initials
  static String initials(String name) {
    return name.split(' ').map((w) => w[0]).take(2).join().toUpperCase();
  }

  /// Mask sensitive data
  static String mask(String text, {int visibleStart = 0, int visibleEnd = 0}) {
    if (text.length <= visibleStart + visibleEnd) return text;
    final start = text.substring(0, visibleStart);
    final end = text.substring(text.length - visibleEnd);
    final masked = '*' * (text.length - visibleStart - visibleEnd);
    return '$start$masked$end';
  }
}
```

---

### 6. **file_utils.dart** - File Operations

```dart
class FileUtils {
  /// Get file extension
  static String getExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }

  /// Check if file is image
  static bool isImage(String fileName) {
    final ext = getExtension(fileName);
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext);
  }

  /// Check if file is video
  static bool isVideo(String fileName) {
    final ext = getExtension(fileName);
    return ['mp4', 'avi', 'mov', 'mkv'].contains(ext);
  }

  /// Get file size string
  static String getFileSizeString(int bytes) {
    return bytes.toFileSize();
  }
}
```

---

### 7. **platform_utils.dart** - Platform Checks

```dart
import 'dart:io';

class PlatformUtils {
  /// Check if Android
  static bool get isAndroid => Platform.isAndroid;

  /// Check if iOS
  static bool get isIOS => Platform.isIOS;

  /// Check if Web
  static bool get isWeb => kIsWeb;

  /// Get platform name
  static String get platformName {
    if (isAndroid) return 'Android';
    if (isIOS) return 'iOS';
    if (isWeb) return 'Web';
    return 'Unknown';
  }
}
```

---

## 📂 Utils Folder Structure

```
lib/core/utils/
├── validators.dart          # Input validation
├── error_handler.dart       # Error handling
├── formatters.dart          # Data formatting
├── date_utils.dart          # Date helpers
├── string_utils.dart        # String helpers
├── file_utils.dart          # File operations
├── platform_utils.dart      # Platform checks
└── utils_export.dart        # Export all utils
```

---

## 🎨 Utils vs Extensions

### When to Use Utils:
- Complex logic with multiple steps
- Need to pass parameters
- Static utility functions
- Not tied to a specific type

```dart
// Utils - Complex logic
StringUtils.truncate(text, 50);
Formatters.currency(amount, symbol: '€');
Validators.combine([validator1, validator2], value);
```

### When to Use Extensions:
- Simple operations on a type
- Method chaining
- Type-specific helpers
- More readable code

```dart
// Extensions - Simple operations
text.capitalize;
date.timeAgo();
list.firstOrNull;
color.darken(0.2);
```

---

## ✅ Best Practices

### 1. Keep Utils Pure

```dart
// ✅ Good - Pure function
static String formatPhone(String phone) {
  return phone.replaceAll(' ', '');
}

// ❌ Bad - Side effects
static String formatPhone(String phone) {
  print('Formatting phone');  // Side effect
  return phone.replaceAll(' ', '');
}
```

### 2. Use Static Methods

```dart
// ✅ Good
class Validators {
  static String? email(String? value) { }
}

// ❌ Bad - Unnecessary instance
class Validators {
  String? email(String? value) { }
}
```

### 3. Provide Clear Names

```dart
// ✅ Good
Validators.email(value)
Formatters.currency(amount)
DateUtils.isToday(date)

// ❌ Bad
Validators.check(value)
Formatters.format(amount)
DateUtils.check(date)
```

### 4. Document Your Utils

```dart
/// Validates email format
/// Returns null if valid, error message if invalid
static String? email(String? value) {
  // ...
}
```

### 5. Export All Utils

```dart
// utils_export.dart
export 'validators.dart';
export 'error_handler.dart';
export 'formatters.dart';
export 'date_utils.dart';
export 'string_utils.dart';
```

---

## 📋 Quick Reference

### Current Utils in Project

- ✅ **error_handler.dart** - Error handling utilities

### Recommended Utils to Add

- 📝 **validators.dart** - Form validation (referenced but may need creation)
- 🎨 **formatters.dart** - Data formatting
- 📅 **date_utils.dart** - Date helpers
- 🔤 **string_utils.dart** - String helpers
- 📁 **file_utils.dart** - File operations
- 📱 **platform_utils.dart** - Platform checks

---

## 🎯 Summary

1. ✅ **Utils** = Reusable helper functions
2. ✅ **Use for** = Validation, formatting, error handling
3. ✅ **Keep pure** = No side effects
4. ✅ **Use static** = No instances needed
5. ✅ **Clear names** = Easy to understand
6. ✅ **Document** = Add comments

---

That's it! Utils make your code cleaner and more reusable. 🛠️
