import 'package:flutter/widgets.dart';

/// Lightweight ScreenUtil-style helper.
///
/// Initialize once at app root with [ScreenUtilX.init], then use:
/// `16.w`, `24.h`, `14.sp`, `12.r`.
class ScreenUtilX {
  ScreenUtilX._();

  static double _designWidth = 430;
  static double _designHeight = 932;
  static double _scaleWidth = 1;
  static double _scaleHeight = 1;
  static double _scaleRadius = 1;
  static bool _initialized = false;

  static void init(
    BuildContext context, {
    double designWidth = 430,
    double designHeight = 932,
  }) {
    final size = MediaQuery.sizeOf(context);
    _designWidth = designWidth;
    _designHeight = designHeight;
    _scaleWidth = size.width / _designWidth;
    _scaleHeight = size.height / _designHeight;
    _scaleRadius = _scaleWidth < _scaleHeight ? _scaleWidth : _scaleHeight;
    _initialized = true;
  }

  static double scaleWidth(num value) => _initialized
      ? value.toDouble() * _scaleWidth
      : value.toDouble();

  static double scaleHeight(num value) => _initialized
      ? value.toDouble() * _scaleHeight
      : value.toDouble();

  static double scaleRadius(num value) => _initialized
      ? value.toDouble() * _scaleRadius
      : value.toDouble();

  static double scaleFont(num value) => scaleRadius(value);
}

extension ScreenUtilNumExtension on num {
  /// Responsive width based on design width.
  double get w => ScreenUtilX.scaleWidth(this);

  /// Responsive height based on design height.
  double get h => ScreenUtilX.scaleHeight(this);

  /// Responsive radius using min(widthScale, heightScale).
  double get r => ScreenUtilX.scaleRadius(this);

  /// Responsive font size (same as [r]).
  double get sp => ScreenUtilX.scaleFont(this);
}

