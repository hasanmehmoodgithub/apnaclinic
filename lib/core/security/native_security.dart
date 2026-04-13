import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Native Security - Handles communication with native platform for secure keys
class NativeSecurity {
  static const platform = MethodChannel("native/keys");

  /// Get secret key from native platform
  ///
  /// Throws [Exception] if key is null, empty, or platform communication fails
  static Future<String> getSecretKey() async {
    try {
      developer.log('Requesting secret key...', name: 'NativeSecurity');

      final key = await platform.invokeMethod<String>('getSecretKey');

      if (key == null || key.isEmpty) {
        throw Exception(
          'Native method returned ${key == null ? 'null' : 'empty string'}. '
          'Check native implementation.',
        );
      }

      developer.log(
        '✅ Key retrieved (length: ${key.length})',
        name: 'NativeSecurity',
      );

      // Log the actual key value (only in debug mode)
      if (kDebugMode) {
        developer.log('🔑 Native Key: $key', name: 'NativeSecurity');
      }

      return key;
    } on PlatformException catch (e) {
      final error = 'Platform error: ${e.message ?? 'Unknown error'}';
      developer.log(
        '$error (code: ${e.code})',
        name: 'NativeSecurity',
        error: e,
      );
      throw Exception(error);
    } on MissingPluginException catch (_) {
      const error = 'Method channel not registered. Configure native code.';
      developer.log('❌ $error', name: 'NativeSecurity');
      throw Exception(error);
    } catch (e) {
      final error = 'Unexpected error: $e';
      developer.log('❌ $error', name: 'NativeSecurity', error: e);
      throw Exception(error);
    }
  }
}
