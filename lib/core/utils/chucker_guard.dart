import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/foundation.dart';

/// Gates Chucker interceptor + floating bug button.
///
/// Enabled in debug always. In release/profile it is **on by default** so QA
/// APKs get the inspector without extra flags. Opt out:
/// `--dart-define=CHUCKER_ACTIVE=false`.
class ChuckerGuard {
  static const bool _flagPrimary =
      bool.fromEnvironment('CHUCKER_ACTIVE', defaultValue: false);

  static bool get isEnabled => kDebugMode || _flagPrimary;

  /// Must run from [main] before [runApp]. Chucker ignores capture/UI in
  /// release unless [ChuckerFlutter.showOnRelease] is true.
  static void configureIfEnabled() {
    if (!isEnabled) return;
    ChuckerFlutter.showOnRelease = true;
  }
}
