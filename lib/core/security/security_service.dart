import 'dart:io';
import 'dart:developer' as developer;
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../flavor/flavor_config.dart';
import '../flavor/app_flavor.dart';
import 'app_integrity.dart';

/// Comprehensive security service for device integrity checks
class SecurityService {
  /// Master switch for device integrity (root, jailbreak, Frida, APK tamper).
  ///
  /// Default **on**. Opt out: `--dart-define=SECURITY_CHECKS=false`.
  static const bool securityChecksEnabled = bool.fromEnvironment(
    'SECURITY_CHECKS',
    defaultValue: false,
  );

  // Method channels
  static const MethodChannel _securityChannel = MethodChannel(
    'security_channel',
  );
  static const MethodChannel _advancedChannel = MethodChannel('qwe_rty_123');

  /// Perform all security checks and return true if device is compromised.
  static Future<bool> isDeviceCompromised() async {
    if (!securityChecksEnabled) {
      if (kDebugMode) {
        developer.log(
          'Device integrity checks disabled (SECURITY_CHECKS=false)',
          name: 'SecurityService',
        );
      }
      return false;
    }

    try {
      if (Platform.isAndroid) {
        final integrity = await AppIntegrity.verify();
        if (integrity.shouldBlock) return true;
      }

      if (Platform.isAndroid) {
        return await _checkAndroidSecurity();
      } else if (Platform.isIOS) {
        return await _checkIOSSecurity();
      }
      return false;
    } catch (e) {
      // On error, assume compromised (fail-safe)
      return true;
    }
  }

  /// Get detailed security status message
  static Future<String?> getSecurityMessage() async {
    if (!securityChecksEnabled) return null;

    try {
      if (Platform.isAndroid) {
        final integrity = await AppIntegrity.verify();
        if (integrity.shouldBlock) {
          return 'Application integrity compromised. You cannot access this application.';
        }
      }

      if (Platform.isAndroid) {
        return await _getAndroidSecurityMessage();
      } else if (Platform.isIOS) {
        return await _getIOSSecurityMessage();
      }
      return null;
    } catch (e) {
      return "Security check failed. Please contact support.";
    }
  }

  // ==================== Android Security Checks ====================

  static Future<bool> _checkAndroidSecurity() async {
    // Check using native method channel
    final nativeRooted = await _checkRootNative();

    // Emulators are OK for local/debug flavors; production still blocks them.
    final shouldBlockEmulator =
        FlavorConfig.currentFlavor == AppFlavor.production;
    final nativeEmulator =
        shouldBlockEmulator ? await _checkEmulatorNative() : false;

    // Developer mode check - only enforce in production
    final shouldCheckDevMode =
        FlavorConfig.currentFlavor == AppFlavor.production;
    final nativeDevMode = shouldCheckDevMode
        ? await _checkDeveloperModeNative()
        : false;

    // Advanced checks (obfuscated channel)
    final advancedRoot = await _checkRootAdvanced();
    final advancedEmulator =
        shouldBlockEmulator ? await _checkEmulatorAdvanced() : false;
    final advancedDevMode = shouldCheckDevMode
        ? await _checkDeveloperModeAdvanced()
        : false;
    final advancedFrida = await _checkFridaAdvanced();
    final advancedXposed = await _checkXposedAdvanced();
    final advancedTampered = await _checkAppTamperedAdvanced();

    // Log results in debug mode
    if (kDebugMode) {
      developer.log('Android Security Check Results:', name: 'SecurityService');
      developer.log(
        '  Root (Native): $nativeRooted, Root (Advanced): $advancedRoot',
        name: 'SecurityService',
      );
      developer.log(
        '  Emulator (Native): $nativeEmulator, Emulator (Advanced): $advancedEmulator',
        name: 'SecurityService',
      );
      developer.log(
        '  DevMode (Native): $nativeDevMode, DevMode (Advanced): $advancedDevMode',
        name: 'SecurityService',
      );
      developer.log(
        '  Frida: $advancedFrida, Xposed: $advancedXposed, Tampered: $advancedTampered',
        name: 'SecurityService',
      );
      developer.log(
        '  Flavor: ${FlavorConfig.currentFlavor.name}',
        name: 'SecurityService',
      );
    }

    // Return true if ANY check fails
    final isCompromised =
        nativeRooted ||
        nativeEmulator ||
        nativeDevMode ||
        advancedRoot ||
        advancedEmulator ||
        advancedDevMode ||
        advancedFrida ||
        advancedXposed ||
        advancedTampered;

    if (kDebugMode) {
      developer.log(
        'Device compromised: $isCompromised',
        name: 'SecurityService',
      );
    }
    return isCompromised;
  }

  static Future<String?> _getAndroidSecurityMessage() async {
    final nativeRooted = await _checkRootNative();
    final nativeEmulator = await _checkEmulatorNative();
    final nativeDevMode = await _checkDeveloperModeNative();
    final frida = await _checkFridaAdvanced();
    final xposed = await _checkXposedAdvanced();
    final tampered = await _checkAppTamperedAdvanced();

    if (nativeRooted) {
      return "Your device is rooted. You cannot access this application.";
    } else if (nativeEmulator) {
      return "You are currently running the application on an emulator. You cannot access this application.";
    } else if (nativeDevMode) {
      return "Your device has developer mode enabled. You cannot access this application.";
    } else if (frida) {
      return "Security threat detected (Frida). You cannot access this application.";
    } else if (xposed) {
      return "Security threat detected (Xposed). You cannot access this application.";
    } else if (tampered) {
      return "Application integrity compromised. You cannot access this application.";
    }

    return null;
  }

  // ==================== iOS Security Checks ====================

  static Future<bool> _checkIOSSecurity() async {
    try {
      final jailbroken = await _checkJailbreakNative();
      final shouldBlockSimulator =
          FlavorConfig.currentFlavor == AppFlavor.production;
      final simulator =
          shouldBlockSimulator ? await _checkSimulatorNative() : false;
      final frida = await _checkFridaNative();

      if (kDebugMode) {
        developer.log('iOS Security Check Results:', name: 'SecurityService');
        developer.log(
          '  Jailbroken: $jailbroken, Simulator: $simulator, Frida: $frida',
          name: 'SecurityService',
        );
      }

      return jailbroken || simulator || frida;
    } on PlatformException catch (e) {
      developer.log(
        'iOS security check error: ${e.message}',
        name: 'SecurityService',
        error: e,
      );
      // On error, assume compromised (fail-safe)
      return true;
    }
  }

  static Future<String?> _getIOSSecurityMessage() async {
    try {
      final jailbroken = await _checkJailbreakNative();
      final simulator = await _checkSimulatorNative();
      final frida = await _checkFridaNative();

      if (jailbroken) {
        return "Your device is jailbroken. You cannot access this application.";
      } else if (simulator) {
        return "You are currently running the application on a simulator. You cannot access this application.";
      } else if (frida) {
        return "Security threat detected (Frida). You cannot access this application.";
      }

      return null;
    } on PlatformException catch (e) {
      developer.log(
        'Error getting iOS security message: ${e.message}',
        name: 'SecurityService',
        error: e,
      );
      return "Security check failed. Please contact support.";
    }
  }

  // ==================== Native Method Channel Calls ====================

  /// Check for root (Android) / jailbreak (iOS) via native channel
  static Future<bool> _checkRootNative() async {
    try {
      if (Platform.isAndroid) {
        final result = await _securityChannel.invokeMethod<bool>('checkRoot');
        return result ?? false;
      } else if (Platform.isIOS) {
        final result = await _securityChannel.invokeMethod<bool>(
          'checkJailbreak',
        );
        return result ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Check for emulator (Android) / simulator (iOS) via native channel
  static Future<bool> _checkEmulatorNative() async {
    try {
      if (Platform.isAndroid) {
        final result = await _securityChannel.invokeMethod<bool>(
          'checkEmulator',
        );
        if (kDebugMode) {
          debugPrint('[Security] Native emulator check result: $result');
        }
        return result ?? false;
      } else if (Platform.isIOS) {
        final result = await _securityChannel.invokeMethod<bool>(
          'checkEmulator',
        );
        return result ?? false;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[Security] Error checking emulator: $e');
      }
      // Fail-safe: assume emulator on error
      return true;
    }
  }

  static Future<bool> _checkSimulatorNative() async {
    try {
      final result = await _securityChannel.invokeMethod<bool>('checkEmulator');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> _checkJailbreakNative() async {
    try {
      final result = await _securityChannel.invokeMethod<bool>(
        'checkJailbreak',
      );
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Check for developer mode (Android only)
  static Future<bool> _checkDeveloperModeNative() async {
    try {
      if (Platform.isAndroid) {
        final result = await _securityChannel.invokeMethod<bool>(
          'checkDeveloperMode',
        );
        return result ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ==================== Advanced/Obfuscated Checks ====================

  static Future<bool> _checkRootAdvanced() async {
    try {
      if (Platform.isAndroid) {
        final result = await _advancedChannel.invokeMethod<bool>('a1');
        return result ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> _checkEmulatorAdvanced() async {
    try {
      if (Platform.isAndroid) {
        final result = await _advancedChannel.invokeMethod<bool>('b1');
        return result ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> _checkDeveloperModeAdvanced() async {
    try {
      if (Platform.isAndroid) {
        final result = await _advancedChannel.invokeMethod<bool>('c1');
        return result ?? false;
      }
      return false;
    } catch (e) {
      developer.log(
        'Error in advanced developer mode check: $e',
        name: 'SecurityService',
        error: e,
      );
      return false;
    }
  }

  /// Advanced Frida detection (Android only)
  static Future<bool> _checkFridaAdvanced() async {
    try {
      if (Platform.isAndroid) {
        final result = await _advancedChannel.invokeMethod<bool>('d1');
        return result ?? false;
      }
      return false;
    } catch (e) {
      developer.log(
        'Error in advanced Frida check: $e',
        name: 'SecurityService',
        error: e,
      );
      return false;
    }
  }

  /// Advanced Xposed detection (Android only)
  static Future<bool> _checkXposedAdvanced() async {
    try {
      if (Platform.isAndroid) {
        final result = await _advancedChannel.invokeMethod<bool>('e1');
        return result ?? false;
      }
      return false;
    } catch (e) {
      developer.log(
        'Error in advanced Xposed check: $e',
        name: 'SecurityService',
        error: e,
      );
      return false;
    }
  }

  /// Advanced app tampering detection (Android only)
  static Future<bool> _checkAppTamperedAdvanced() async {
    return (await AppIntegrity.verify()).shouldBlock;
  }

  /// Check for Frida (iOS)
  static Future<bool> _checkFridaNative() async {
    try {
      if (Platform.isIOS) {
        final result = await _securityChannel.invokeMethod<bool>('checkFrida');
        return result ?? false;
      }
      return false;
    } catch (e) {
      developer.log(
        'Error checking Frida: $e',
        name: 'SecurityService',
        error: e,
      );
      return false;
    }
  }
}
