import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/foundation.dart';

class ChuckerGuard {
  static const bool _flagPrimary =
      bool.fromEnvironment('CHUCKER_ACTIVE', defaultValue: true);

  /// On in debug builds, or when [CHUCKER_ACTIVE] is set at compile time.
  static bool get isEnabled => kDebugMode || _flagPrimary;

  /// When [CHUCKER_ACTIVE] is true at compile time, allows Chucker UI in release
  /// (the package disables it otherwise). Call from [main] before [runApp].
  static void configureIfEnabled() {
    if (!_flagPrimary) return;
    ChuckerFlutter.showOnRelease = true;
  }
}
