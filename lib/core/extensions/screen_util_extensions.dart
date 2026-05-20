import 'dart:io' show Platform;

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
  static double _textScaleFactor = 1;
  static bool _useScaleByDefault = true;
  static bool _initialized = false;

  /// Platform-specific clamp on [MediaQueryData.textScaler] for consistent UI text.
  static double clampedTextScale(MediaQueryData mediaQueryData) {
    return Platform.isIOS
        ? mediaQueryData.textScaler.scale(1.0).clamp(1.02, 1.25)
        : mediaQueryData.textScaler.scale(1.0).clamp(0.88, 0.93);
  }

  static void init(
    BuildContext context, {
    double designWidth = 410,
    double designHeight = 720,
    bool useScaleByDefault = true,
  }) {
    final mediaQueryData = MediaQuery.of(context);
    final size = mediaQueryData.size;
    _textScaleFactor = clampedTextScale(mediaQueryData);
    _designWidth = designWidth;
    _designHeight = designHeight;
    _scaleWidth = size.width / _designWidth;
    _scaleHeight = size.height / _designHeight;
    _scaleRadius = _scaleWidth < _scaleHeight ? _scaleWidth : _scaleHeight;
    if (useScaleByDefault) {
      _scaleWidth *= _textScaleFactor;
      _scaleHeight *= _textScaleFactor;
      _scaleRadius *= _textScaleFactor;
    }
    _useScaleByDefault = useScaleByDefault;
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

  /// Width value with optional scaling toggle.
  static double width(num value, {bool fromScale = true}) {
    return fromScale ? scaleWidth(value) : value.toDouble();
  }

  /// Height value with optional scaling toggle.
  static double height(num value, {bool fromScale = true}) {
    return fromScale ? scaleHeight(value) : value.toDouble();
  }

  /// Radius value with optional scaling toggle.
  static double radius(num value, {bool fromScale = true}) {
    return fromScale ? scaleRadius(value) : value.toDouble();
  }

  /// Font value with optional scaling toggle.
  ///
  /// [fromScale] false keeps design px; platform [clampedTextScale] still applies.
  static double font(num value, {bool fromScale = true}) {
    final base = fromScale ? scaleRadius(value) : value.toDouble();
    return base * _textScaleFactor;
  }

  /// Width value respecting app default scale mode.
  static double widthAuto(num value, {bool? fromScale}) {
    final resolved = fromScale ?? _useScaleByDefault;
    return width(value, fromScale: resolved);
  }

  /// Height value respecting app default scale mode.
  static double heightAuto(num value, {bool? fromScale}) {
    final resolved = fromScale ?? _useScaleByDefault;
    return height(value, fromScale: resolved);
  }

  /// Radius value respecting app default scale mode.
  static double radiusAuto(num value, {bool? fromScale}) {
    final resolved = fromScale ?? _useScaleByDefault;
    return radius(value, fromScale: resolved);
  }

  /// Font value respecting app default scale mode.
  static double fontAuto(num value, {bool? fromScale}) {
    final resolved = fromScale ?? _useScaleByDefault;
    return font(value, fromScale: resolved);
  }
}

extension ScreenUtilNumExtension on num {
  /// Responsive width based on design width.
  double get w => ScreenUtilX.widthAuto(this);

  /// Responsive height based on design height.
  double get h => ScreenUtilX.heightAuto(this);

  /// Responsive radius using min(widthScale, heightScale).
  double get r => ScreenUtilX.radiusAuto(this);

  /// Responsive font size (same as [r]).
  double get sp => ScreenUtilX.fontAuto(this);

  /// Width with optional scaling control.
  ///
  /// Example: `16.wv(fromScale: true)` or `16.wv(fromScale: false)`.
  double wv({bool fromScale = true}) {
    return ScreenUtilX.width(this, fromScale: fromScale);
  }

  /// Height with optional scaling control.
  double hv({bool fromScale = true}) {
    return ScreenUtilX.height(this, fromScale: fromScale);
  }

  /// Radius with optional scaling control.
  double rv({bool fromScale = true}) {
    return ScreenUtilX.radius(this, fromScale: fromScale);
  }

  /// Font size with optional scaling control.
  double spv({bool fromScale = true}) {
    return ScreenUtilX.font(this, fromScale: fromScale);
  }
}

