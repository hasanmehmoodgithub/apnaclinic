import 'package:flutter/material.dart';

/// Context extensions for easy access to common properties
extension ContextExtensions on BuildContext {
  /// Get MediaQuery data
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get screen width
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Get screen height
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Get screen size
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Get screen orientation
  Orientation get orientation => mediaQuery.orientation;

  /// Check if device is in landscape mode
  bool get isLandscape => orientation == Orientation.landscape;

  /// Check if device is in portrait mode
  bool get isPortrait => orientation == Orientation.portrait;

  /// Get device pixel ratio
  double get devicePixelRatio => mediaQuery.devicePixelRatio;

  /// Get padding (safe area)
  EdgeInsets get padding => mediaQuery.padding;

  /// Get view padding
  EdgeInsets get viewPadding => mediaQuery.viewPadding;

  /// Get view insets
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  /// Get status bar height
  double get statusBarHeight => padding.top;

  /// Get bottom safe area height
  double get bottomSafeArea => padding.bottom;

  /// Get app bar height (default: 56)
  double get appBarHeight => AppBar().preferredSize.height;

  /// Get keyboard height
  double get keyboardHeight => viewInsets.bottom;

  /// Check if keyboard is visible
  bool get isKeyboardVisible => viewInsets.bottom > 0;

  /// Get responsive width (percentage of screen width)
  double widthPercent(double percent) => screenWidth * (percent / 100);

  /// Get responsive height (percentage of screen height)
  double heightPercent(double percent) => screenHeight * (percent / 100);

  /// Get responsive size based on screen width
  double responsiveWidth(double width) {
    final designWidth = 375.0; // iPhone design width
    return (screenWidth / designWidth) * width;
  }

  /// Get responsive size based on screen height
  double responsiveHeight(double height) {
    final designHeight = 812.0; // iPhone design height
    return (screenHeight / designHeight) * height;
  }

  /// Check if screen is small (width < 600)
  bool get isSmallScreen => screenWidth < 600;

  /// Check if screen is medium (600 <= width < 1200)
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 1200;

  /// Check if screen is large (width >= 1200)
  bool get isLargeScreen => screenWidth >= 1200;

  /// Check if screen is tablet (width >= 600)
  bool get isTablet => screenWidth >= 600;

  /// Check if screen is phone (width < 600)
  bool get isPhone => screenWidth < 600;
}
