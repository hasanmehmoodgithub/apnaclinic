import 'package:flutter/material.dart';

/// Color extensions for color operations
extension ColorExtensions on Color {
  /// Check if color is dark
  bool get isDark {
    final luminance = computeLuminance();
    return luminance < 0.5;
  }

  /// Check if color is light
  bool get isLight => !isDark;

  /// Get brightness (0.0 to 1.0)
  double get brightness => computeLuminance();

  /// Get contrast color (black or white)
  Color get contrastColor {
    return isDark ? Colors.white : Colors.black;
  }

  /// Darken color by percentage (0.0 to 1.0)
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  /// Lighten color by percentage (0.0 to 1.0)
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  /// Adjust opacity
  Color withOpacity(double opacity) {
    assert(opacity >= 0 && opacity <= 1);
    return withAlpha((opacity * 255).round());
  }

  /// Get hex string (e.g., #FF0000)
  String get hex {
    final argb = toARGB32();
    return '#${argb.toRadixString(16).substring(2).toUpperCase()}';
  }

  /// Get hex string with alpha (e.g., #FFFF0000)
  String get hexWithAlpha {
    final argb = toARGB32();
    return '#${argb.toRadixString(16).toUpperCase()}';
  }

  /// Create color from hex string
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Saturate color by percentage (0.0 to 1.0)
  Color saturate([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    return hsl.withSaturation((hsl.saturation + amount).clamp(0.0, 1.0)).toColor();
  }

  /// Desaturate color by percentage (0.0 to 1.0)
  Color desaturate([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    return hsl.withSaturation((hsl.saturation - amount).clamp(0.0, 1.0)).toColor();
  }

  /// Get complementary color
  Color get complementary {
    final hsl = HSLColor.fromColor(this);
    return hsl.withHue((hsl.hue + 180) % 360).toColor();
  }

  /// Blend with another color
  Color blend(Color other, double ratio) {
    assert(ratio >= 0 && ratio <= 1);
    return Color.lerp(this, other, ratio)!;
  }
}

/// String extensions for color conversion
extension StringColorExtensions on String {
  /// Convert hex string to Color
  Color get toColor {
    return ColorExtensions.fromHex(this);
  }

  /// Check if string is a valid hex color
  bool get isValidHexColor {
    return RegExp(r'^#?([A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$').hasMatch(this);
  }
}
