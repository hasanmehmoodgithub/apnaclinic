import 'package:flutter/material.dart';

/// Text style extensions for responsive text sizing
extension TextStyleExtensions on TextStyle {
  /// Get responsive font size based on screen width
  ///
  /// [baseSize] - Base font size for design width (default: 375)
  /// [minSize] - Minimum font size (optional)
  /// [maxSize] - Maximum font size (optional)
  TextStyle responsive({
    required BuildContext context,
    double? baseSize,
    double? minSize,
    double? maxSize,
  }) {
    final designWidth = 375.0; // iPhone design width
    final screenWidth = MediaQuery.sizeOf(context).width;
    final scaleFactor = screenWidth / designWidth;

    double fontSize = (baseSize ?? this.fontSize ?? 14) * scaleFactor;

    // Apply min/max constraints
    if (minSize != null && fontSize < minSize) fontSize = minSize;
    if (maxSize != null && fontSize > maxSize) fontSize = maxSize;

    return copyWith(fontSize: fontSize);
  }

  /// Scale font size by factor
  TextStyle scale(double factor) {
    return copyWith(fontSize: fontSize != null ? fontSize! * factor : null);
  }
}

/// Context extensions for responsive text styles
extension ResponsiveTextExtensions on BuildContext {
  /// Get responsive text style
  ///
  /// [baseSize] - Base font size for design width (default: 375)
  /// [minSize] - Minimum font size (optional)
  /// [maxSize] - Maximum font size (optional)
  TextStyle responsiveTextStyle({
    required double baseSize,
    double? minSize,
    double? maxSize,
    Color? color,
    FontWeight? fontWeight,
  }) {
    final designWidth = 375.0;
    final screenWidth = MediaQuery.sizeOf(this).width;
    final scaleFactor = screenWidth / designWidth;

    double fontSize = baseSize * scaleFactor;

    // Apply min/max constraints
    if (minSize != null && fontSize < minSize) fontSize = minSize;
    if (maxSize != null && fontSize > maxSize) fontSize = maxSize;

    return TextStyle(fontSize: fontSize, color: color, fontWeight: fontWeight);
  }

  /// Get responsive font size
  double responsiveFontSize(
    double baseSize, {
    double? minSize,
    double? maxSize,
  }) {
    final designWidth = 375.0;
    final screenWidth = MediaQuery.sizeOf(this).width;
    final scaleFactor = screenWidth / designWidth;

    double fontSize = baseSize * scaleFactor;

    if (minSize != null && fontSize < minSize) fontSize = minSize;
    if (maxSize != null && fontSize > maxSize) fontSize = maxSize;

    return fontSize;
  }

  /// Get text style for small screens
  TextStyle get smallTextStyle => TextStyle(fontSize: responsiveFontSize(12));

  /// Get text style for medium screens
  TextStyle get mediumTextStyle => TextStyle(fontSize: responsiveFontSize(14));

  /// Get text style for large screens
  TextStyle get largeTextStyle => TextStyle(fontSize: responsiveFontSize(16));

  /// Get text style for extra large screens
  TextStyle get extraLargeTextStyle =>
      TextStyle(fontSize: responsiveFontSize(18));
}
