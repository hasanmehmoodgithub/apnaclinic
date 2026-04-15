import 'package:flutter/material.dart';
import '../extensions/screen_util_extensions.dart';
import 'app_theme_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppThemeColors.light.primary,
        brightness: Brightness.light,
      ),

      extensions: <ThemeExtension<dynamic>>[
        AppThemeColors.light,
      ],
      scaffoldBackgroundColor: AppThemeColors.light.background,
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        filled: true,
      ),
      textTheme: const TextTheme(),

    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppThemeColors.dark.primary,
        brightness: Brightness.dark,
      ),
      extensions: <ThemeExtension<dynamic>>[
        AppThemeColors.dark,
      ],
      scaffoldBackgroundColor: AppThemeColors.dark.background,
    );
  }

}

