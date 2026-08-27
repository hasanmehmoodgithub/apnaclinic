import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../flavor/flavor_config.dart';

/// Result of an APK / application integrity check.
///
/// Native code never returns certificate hashes to Dart.
enum AppIntegrityStatus {
  /// Package name and signing cert match the expected release identity.
  valid,

  /// Installed package was renamed, resigned, or otherwise modified.
  tampered,

  /// Check is not available on this platform (iOS / desktop).
  unsupported,

  /// Native call failed. Production treats this as compromised.
  unavailable,
}

class AppIntegrityResult {
  const AppIntegrityResult({
    required this.status,
    required this.platformSupported,
  });

  final AppIntegrityStatus status;
  final bool platformSupported;

  /// Whether the app should refuse to run.
  bool get shouldBlock {
    if (!AppIntegrity.enforceBlock) return false;
    if (status == AppIntegrityStatus.tampered) return true;
    if (status == AppIntegrityStatus.unavailable) {
      return FlavorConfig.isProduction;
    }
    return false;
  }
}

/// Flutter API for APK signature / package integrity. Comparison runs on Android.
class AppIntegrity {
  AppIntegrity._();

  /// Temporarily off so sideloaded / debug APKs are not blocked.
  /// Set to `true` to restore APK signature + package checks.
  static const bool enforceBlock = false;

  static const MethodChannel _channel = MethodChannel('security_channel');

  /// Verifies the installed Android package and signing certificate.
  ///
  /// iOS returns [AppIntegrityStatus.unsupported] (not APK-signed).
  static Future<AppIntegrityResult> verify() async {
    if (!enforceBlock) {
      return AppIntegrityResult(
        status: AppIntegrityStatus.valid,
        platformSupported: Platform.isAndroid,
      );
    }
    if (!Platform.isAndroid) {
      return const AppIntegrityResult(
        status: AppIntegrityStatus.unsupported,
        platformSupported: false,
      );
    }

    try {
      final tampered = await _channel.invokeMethod<bool>('checkAppIntegrity');
      return AppIntegrityResult(
        status: (tampered ?? true)
            ? AppIntegrityStatus.tampered
            : AppIntegrityStatus.valid,
        platformSupported: true,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[AppIntegrity] native check failed: $e');
      }
      return const AppIntegrityResult(
        status: AppIntegrityStatus.unavailable,
        platformSupported: true,
      );
    }
  }

  static Future<bool> isTampered() async {
    return (await verify()).status == AppIntegrityStatus.tampered;
  }
}
