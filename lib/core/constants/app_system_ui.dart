import 'package:flutter/services.dart';

/// Global status bar / system navigation styling for the app.
abstract final class AppSystemUi {
  static const Color statusBarColor = Color(0xFF0FAA9A);

  /// Teal status bar, light status icons, light nav bar.
  static const SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
    statusBarColor: statusBarColor,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Color(0xFFF8FAF9),
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static void apply() {
    SystemChrome.setSystemUIOverlayStyle(overlayStyle);
  }
}
