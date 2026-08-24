import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'hmac_dev_log.dart';
import 'hmac_headers.dart';

/// HMAC secrets. Never log the values.
///
/// Primary keys are per platform (`x-key-id` = `android` / `ios`) and are
/// used for both aggregator and user-auth. Optional per-service defines
/// override that when backend issues distinct aggregator vs auth secrets.
///
/// Defaults match `MOBILE_API_KEY` so a normal `flutter run` signs.
/// Override with `--dart-define` / `--dart-define-from-file=hmac.keys.json`.
class HmacSecretStore {
  HmacSecretStore({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const _androidFallback =
      '95fc9e2baf705d24127b7fcbd1fa11bb086a3775bcf844b5847186b016a2fbab';
  static const _iosFallback =
      '86171bf287e53bf425456b31ef7ace77bc3cc94c5cbbf8d04c10d2a40484304f';

  static const _androidDefine = String.fromEnvironment(
    'HMAC_ANDROID_SECRET',
    defaultValue: _androidFallback,
  );
  static const _iosDefine = String.fromEnvironment(
    'HMAC_IOS_SECRET',
    defaultValue: _iosFallback,
  );
  static const _aggregatorDefine = String.fromEnvironment(
    'HMAC_AGGREGATOR_SECRET',
  );
  static const _authDefine = String.fromEnvironment('HMAC_AUTH_SECRET');

  static const _androidStorageKey = 'hmac_android_secret';
  static const _iosStorageKey = 'hmac_ios_secret';
  static const _aggregatorStorageKey = 'hmac_aggregator_secret';
  static const _authStorageKey = 'hmac_auth_secret';

  final FlutterSecureStorage _secureStorage;

  String _androidSecret = '';
  String _iosSecret = '';
  String _aggregatorSecret = '';
  String _authSecret = '';

  Future<void> initialize() async {
    _androidSecret = await _loadSecret(
      defineValue: _androidDefine,
      storageKey: _androidStorageKey,
      label: 'android',
    );
    _iosSecret = await _loadSecret(
      defineValue: _iosDefine,
      storageKey: _iosStorageKey,
      label: 'ios',
    );
    _aggregatorSecret = await _loadSecret(
      defineValue: _aggregatorDefine,
      storageKey: _aggregatorStorageKey,
      label: 'aggregator-override',
    );
    _authSecret = await _loadSecret(
      defineValue: _authDefine,
      storageKey: _authStorageKey,
      label: 'user-auth-override',
    );

    hmacDevLog(
      'Initialized keyId=$keyId '
      'android=${_presence(_androidSecret)} ios=${_presence(_iosSecret)} '
      'aggregatorOverride=${_presence(_aggregatorSecret)} '
      'userAuthOverride=${_presence(_authSecret)} '
      'active=${_presence(secretFor(HmacBackend.aggregator))}',
    );
  }

  /// `android` or `ios` — sent as `x-key-id`.
  String get keyId {
    if (!kIsWeb && Platform.isIOS) return 'ios';
    return 'android';
  }

  String get _platformSecret {
    final loaded = keyId == 'ios' ? _iosSecret : _androidSecret;
    if (loaded.isNotEmpty) return loaded;
    // In-memory can be empty after hot reload (initialize ran once at startup).
    final defined = (keyId == 'ios' ? _iosDefine : _androidDefine).trim();
    if (defined.isNotEmpty) return defined;
    return keyId == 'ios' ? _iosFallback : _androidFallback;
  }

  /// Per-service override if present, otherwise the platform secret for [keyId].
  String secretFor(HmacBackend backend) {
    final override = switch (backend) {
      HmacBackend.aggregator =>
        _aggregatorSecret.isNotEmpty
            ? _aggregatorSecret
            : _aggregatorDefine.trim(),
      HmacBackend.userAuth =>
        _authSecret.isNotEmpty ? _authSecret : _authDefine.trim(),
    };
    if (override.isNotEmpty) return override;
    return _platformSecret;
  }

  Future<String> _loadSecret({
    required String defineValue,
    required String storageKey,
    required String label,
  }) async {
    final fromDefine = defineValue.trim();
    if (fromDefine.isNotEmpty) {
      await _secureStorage.write(key: storageKey, value: fromDefine);
      hmacDevLog(
        '$label secret loaded from dart-define (length=${fromDefine.length})',
      );
      return fromDefine;
    }

    final stored = (await _secureStorage.read(key: storageKey))?.trim() ?? '';
    if (stored.isNotEmpty) {
      hmacDevLog(
        '$label secret loaded from secure storage (length=${stored.length})',
      );
      return stored;
    }

    hmacDevLog('$label secret not set');
    return '';
  }

  String _presence(String secret) =>
      secret.isEmpty ? 'missing' : 'present(len=${secret.length})';
}
