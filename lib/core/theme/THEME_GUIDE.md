# 🎨 Theme Guide

Simple guide for adding and using themes in your Flutter app.

---

## 📖 Quick Overview

- **Theme**: Defines colors, styles, and appearance for your app
- **Theme Extension**: Custom colors that work with Material 3
- **Usage**: Access via `Theme.of(context)` or extensions

---

## ➕ Adding Custom Colors

### Step 1: Edit Theme Extension

Edit: `lib/core/theme/app_theme_colors.dart`

```dart
@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color primary;
  final Color secondary;
  final Color background;
  final Color yourCustomColorName;  // Add your color here
  
  const AppThemeColors({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.yourCustomColorName,  // Add here
  });

  // Light theme
  static const AppThemeColors light = AppThemeColors(
    primary: Color(0xFF6750A4),
    secondary: Color(0xFF625B71),
    background: Color(0xFFFFFBFE),
    yourCustomColorName: Color(0xFF4CAF50),  // Light color
  );

  // Dark theme
  static const AppThemeColors dark = AppThemeColors(
    primary: Color(0xFFD0BCFF),
    secondary: Color(0xFFCCC2DC),
    background: Color(0xFF1C1B1F),
    yourCustomColorName: Color(0xFF690005),  // Dark color
  );

  @override
  AppThemeColors copyWith({
    Color? primary,
    Color? secondary,
    Color? background,
    Color? yourCustomColorName,  // Add here
  }) {
    return AppThemeColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      background: background ?? this.background,
      yourCustomColorName: yourCustomColorName ?? this.yourCustomColorName,  // Add here
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      background: Color.lerp(background, other.background, t)!,
      yourCustomColorName: Color.lerp(yourCustomColorName, other.yourCustomColorName, t)!,  // Add here
    );
  }
}
```

### Step 2: Use in Widgets

```dart
// Get theme extension
final themeColors = Theme.of(context).extension<AppThemeColors>();

// Use custom color
Container(
  color: themeColors?.yourCustomColorName ?? Colors.grey,
  child: Text('Hello'),
)
```

---

## 💻 Using Theme in Code

### Method 1: Using Theme Extension (Recommended)

```dart
// Get theme extension
final themeColors = Theme.of(context).extension<AppThemeColors>();

// Use colors
Container(
  color: themeColors?.primary ?? Colors.blue,
  child: Text(
    'Hello',
    style: TextStyle(color: themeColors?.secondary),
  ),
)
```

### Method 2: Using ThemeData

```dart
// Get theme
final theme = Theme.of(context);

// Use theme colors
Container(
  color: theme.colorScheme.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: theme.colorScheme.onPrimary),
  ),
)
```

### Method 3: Using AppColors (Constants)

```dart
import 'core/constants/app_colors.dart';

Container(
  color: AppColors.primaryColor,
  child: Text('Hello'),
)
```

---

## 🎯 Complete Example

```dart
import 'package:flutter/material.dart';
import 'core/theme/app_theme_colors.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get theme extension
    final themeColors = Theme.of(context).extension<AppThemeColors>();
    
    return Scaffold(
      backgroundColor: themeColors?.background,
      body: Center(
        child: Column(
          children: [
            // Use primary color
            Container(
              padding: EdgeInsets.all(20),
              color: themeColors?.primary,
              child: Text(
                'Primary Color',
                style: TextStyle(color: Colors.white),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Use custom color
            Container(
              padding: EdgeInsets.all(20),
              color: themeColors?.yourCustomColorName,
              child: Text(
                'Custom Color',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## ✅ Best Practices

1. **Use Theme Extensions** for custom colors
   ```dart
   // ✅ Good
   final colors = Theme.of(context).extension<AppThemeColors>();
   color: colors?.primary
   
   // ❌ Bad - Hardcoded
   color: Color(0xFF6750A4)
   ```

2. **Always Provide Fallback**
   ```dart
   // ✅ Good
   color: themeColors?.primary ?? Colors.blue
   
   // ❌ Bad - Can be null
   color: themeColors!.primary
   ```

3. **Use Material 3 Colors When Possible**
   ```dart
   // ✅ Good
   color: Theme.of(context).colorScheme.primary
   
   // ❌ Bad - Custom when Material 3 has it
   color: AppColors.primaryColor
   ```

---

## 📋 Quick Reference

### Get Theme Extension
```dart
final themeColors = Theme.of(context).extension<AppThemeColors>();
```

### Use Colors
```dart
// Custom colors
themeColors?.primary
themeColors?.secondary
themeColors?.yourCustomColorName

// Material 3 colors
Theme.of(context).colorScheme.primary
Theme.of(context).colorScheme.secondary
Theme.of(context).colorScheme.surface
```

### Files
- **Theme**: `lib/core/theme/app_theme.dart`
- **Theme Colors**: `lib/core/theme/app_theme_colors.dart`
- **App Colors**: `lib/core/constants/app_colors.dart`

---

That's it! Simple and easy. 🎨
