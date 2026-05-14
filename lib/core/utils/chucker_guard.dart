import 'package:chucker_flutter/chucker_flutter.dart';

class ChuckerGuard {
  static const bool _flagPrimary =
      bool.fromEnvironment('CHUCKER_ACTIVE', defaultValue: true);
  static bool get isEnabled => _flagPrimary;

  /// When [CHUCKER_ACTIVE] is true at compile time, allows Chucker UI in release
  /// (the package disables it otherwise). Call from [main] before [runApp].
  static void configureIfEnabled() {
    if (!_flagPrimary) return;
    ChuckerFlutter.showOnRelease = true;
  }
}
