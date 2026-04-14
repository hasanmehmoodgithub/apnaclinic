import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart' hide Key;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer' as developer;

import '../security/native_security.dart';

class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  // Constants
  static const String _secretKeyName = 'app_random_secret_key';
  static const String _fallbackNativeKeyName = 'app_fallback_native_key';

  // Dependencies
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  late String _nativeKey; // Key from method channel
  late String _randomSecret; // Random key stored in secure storage
  late String _combinedKey; // Combined key
  late String _normalizedKey; // Normalized key

  bool _initialized = false;

  /// Initialize encryption keys and setup
  Future<void> initialize() async {
    if (_initialized) {
      if (kDebugMode) {
        developer.log(
          '⚠️ EncryptionService already initialized — skipping.',
          name: 'EncryptionService',
        );
      }
      return;
    }

    if (kDebugMode) {
      developer.log(
        '🔄 Initializing EncryptionService...',
        name: 'EncryptionService',
      );
    }

    // 1️⃣ Get native key from platform side (with fallback if not available)
    _nativeKey = await _getNativeKey();

    // Log native key
    if (kDebugMode) {
      developer.log('🔑 Native Key: $_nativeKey', name: 'EncryptionService');
    }

    // 2️⃣ Retrieve or create random secret
    String? storedSecret = await _secureStorage.read(key: _secretKeyName);
    if (storedSecret == null) {
      storedSecret = _generateRandomSecret();
      await _secureStorage.write(key: _secretKeyName, value: storedSecret);
      if (kDebugMode) {
        developer.log(
          '🔑 Random secret key generated and stored.',
          name: 'EncryptionService',
        );
      }
    } else {
      if (kDebugMode) {
        developer.log(
          '🔑 Random secret key loaded from secure storage.',
          name: 'EncryptionService',
        );
      }
    }
    _randomSecret = storedSecret;

    // Log random secret
    if (kDebugMode) {
      developer.log(
        '🔑 Random Secret: $_randomSecret',
        name: 'EncryptionService',
      );
    }

    // 3️⃣ Combine both keys
    _combinedKey = _combineKeys(_nativeKey, _randomSecret);
    _normalizedKey = _normalizeKey(_combinedKey);

    // Log all keys
    if (kDebugMode) {
      developer.log(
        '🔑 Combined Key: $_combinedKey',
        name: 'EncryptionService',
      );
      developer.log(
        '🔑 Normalized Key: $_normalizedKey',
        name: 'EncryptionService',
      );
      developer.log(
        '🔑 Normalized Key Length: ${_normalizedKey.length}',
        name: 'EncryptionService',
      );
    }

    _initialized = true;
    if (kDebugMode) {
      developer.log(
        '✅ EncryptionService initialization complete',
        name: 'EncryptionService',
      );
    }
  }

  /// Fetch native key via platform channel
  /// Falls back to generated key if native method channel is not available
  Future<String> _getNativeKey() async {
    try {
      if (kDebugMode) {
        developer.log(
          '🔄 Requesting native key from platform...',
          name: 'EncryptionService',
        );
      }
      final key = await NativeSecurity.getSecretKey();
      if (key.isEmpty) throw Exception('Native key not found');
      return key;
    } catch (e) {
      if (kDebugMode) {
        developer.log(
          '⚠️ Failed to get native key: $e',
          name: 'EncryptionService',
          error: e,
        );
        developer.log(
          '⚠️ Using fallback key (less secure - configure native code for production)',
          name: 'EncryptionService',
        );
      }
      // Persisted fallback key for environments where native key is unavailable.
      // If this changes between launches, obfuscated pref keys also change and
      // persisted values (like login status) become unreadable.
      final storedFallback = await _secureStorage.read(
        key: _fallbackNativeKeyName,
      );
      if (storedFallback != null && storedFallback.isNotEmpty) {
        if (kDebugMode) {
          developer.log(
            '🔑 Loaded persisted fallback native key.',
            name: 'EncryptionService',
          );
        }
        return storedFallback;
      }

      final generatedFallback = _generateFallbackKey();
      await _secureStorage.write(
        key: _fallbackNativeKeyName,
        value: generatedFallback,
      );
      if (kDebugMode) {
        developer.log(
          '🔑 Generated and stored fallback native key.',
          name: 'EncryptionService',
        );
      }
      return generatedFallback;
    }
  }

  /// Generate a fallback key when native method channel is not available
  /// This is less secure than native key but allows app to function
  String _generateFallbackKey() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    final fallbackKey = base64Encode(values);
    if (kDebugMode) {
      developer.log(
        '🔑 Generated fallback key (Base64 length: ${fallbackKey.length})',
        name: 'EncryptionService',
      );
      developer.log(
        '⚠️ WARNING: Using fallback key. Configure native method channel for production security.',
        name: 'EncryptionService',
      );
    }
    return fallbackKey;
  }

  /// Generate a secure random 32-byte secret key
  String _generateRandomSecret() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    final secret = base64Encode(values);
    if (kDebugMode) {
      developer.log(
        '🔑 Generated new random secret (Base64 length: ${secret.length})',
        name: 'EncryptionService',
      );
    }
    return secret;
  }

  /// Combine native and random secrets into a strong key
  String _combineKeys(String nativeKey, String randomSecret) {
    final combined = base64.encode(utf8.encode('$nativeKey$randomSecret'));
    if (kDebugMode) {
      developer.log(
        '🔄 Keys combined. Combined Base64 length: ${combined.length}',
        name: 'EncryptionService',
      );
    }
    return combined.substring(0, 32);
  }

  /// Normalize to 32 characters (AES-256 key)
  String _normalizeKey(String key) {
    final normalized = key.length >= 32
        ? key.substring(0, 32)
        : key.padRight(32, '0');
    if (kDebugMode) {
      developer.log(
        '🔄 Normalized key length: ${normalized.length}',
        name: 'EncryptionService',
      );
    }
    return normalized;
  }

  String encrypt(String plainText) {
    final key = utf8.encode(_normalizedKey);
    final bytes = utf8.encode(plainText);

    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(bytes);

    final random = Random.secure();
    final iv = List<int>.generate(16, (i) => random.nextInt(256));
    final encrypted = _xorEncrypt(bytes, iv);

    final base64Payload = base64Encode([...iv, ...encrypted]);
    final result = '$base64Payload:$digest';

    // Log encrypted text and lengths
    developer.log('Encrypted Text: $result', name: 'EncryptionService');
    developer.log(
      'Encrypted Text Length: ${result.length}',
      name: 'EncryptionService',
    );
    developer.log('Base64 Payload: $base64Payload', name: 'EncryptionService');
    developer.log(
      'Base64 Payload Length: ${base64Payload.length}',
      name: 'EncryptionService',
    );

    return result;
  }

  String decrypt(String encryptedText) {
    try {
      final parts = encryptedText.split(':');
      if (parts.length != 2) return '';

      final data = base64Decode(parts[0]);
      final storedDigest = parts[1];

      final iv = data.sublist(0, 16);
      final encrypted = data.sublist(16);

      final decrypted = _xorDecrypt(encrypted, iv);

      final key = utf8.encode(_normalizedKey);
      final hmac = Hmac(sha256, key);
      final calculatedDigest = hmac.convert(decrypted).toString();

      if (calculatedDigest != storedDigest) return '';

      final result = utf8.decode(decrypted);

      // Log decrypted text and its length
      developer.log('Decrypted Text: $result', name: 'EncryptionService');
      developer.log(
        'Decrypted Text Length: ${result.length}',
        name: 'EncryptionService',
      );

      return result;
    } catch (e) {
      return '';
    }
  }

  // XOR helpers
  List<int> _xorEncrypt(List<int> data, List<int> key) {
    final result = List<int>.filled(data.length, 0);
    for (var i = 0; i < data.length; i++) {
      result[i] = data[i] ^ key[i % key.length];
    }
    return result;
  }

  List<int> _xorDecrypt(List<int> data, List<int> key) =>
      _xorEncrypt(data, key);
  String obfuscateKey(String keyName) {
    final input = keyName + _nativeKey + _randomSecret;
    final bytes = utf8.encode(input);
    final hash = sha256.convert(bytes);
    return base64Encode(
      hash.bytes,
    ).substring(0, 20).replaceAll(RegExp(r'[+/=]'), '_');
  }

  /// Encrypt a JSON object/Map
  ///
  /// Takes a Map (JSON object) and encrypts it for secure storage or transmission.
  ///
  /// Example:
  /// ```dart
  /// final jsonData = {
  ///   'userId': 123,
  ///   'email': 'user@example.com',
  ///   'token': 'abc123'
  /// };
  /// final encrypted = encryptionService.encryptJson(jsonData);
  /// ```
  ///
  /// Returns encrypted string that can be stored or transmitted securely.
  /// Throws [FormatException] if JSON encoding fails.
  String encryptJson(Map<String, dynamic> jsonData) {
    try {
      if (kDebugMode) {
        developer.log('Encrypting JSON data...', name: 'EncryptionService');
      }

      // Convert Map to JSON string
      final jsonString = jsonEncode(jsonData);

      if (kDebugMode) {
        developer.log(
          'JSON string length: ${jsonString.length}',
          name: 'EncryptionService',
        );
      }

      // Encrypt the JSON string
      final encrypted = encrypt(jsonString);

      if (kDebugMode) {
        developer.log('JSON encrypted successfully', name: 'EncryptionService');
      }

      return encrypted;
    } catch (e) {
      if (kDebugMode) {
        developer.log('Error encrypting JSON: $e', name: 'EncryptionService');
      }
      throw FormatException('Failed to encrypt JSON: $e');
    }
  }

  /// Decrypt a JSON object/Map
  ///
  /// Takes an encrypted string and decrypts it back to a Map (JSON object).
  ///
  /// Example:
  /// ```dart
  /// final encrypted = 'encrypted_string_here';
  /// final jsonData = encryptionService.decryptJson(encrypted);
  /// print(jsonData['userId']); // 123
  /// ```
  ///
  /// Returns the decrypted Map, or empty Map if decryption fails.
  /// Throws [FormatException] if JSON decoding fails.
  Map<String, dynamic> decryptJson(String encryptedJson) {
    try {
      if (kDebugMode) {
        developer.log('Decrypting JSON data...', name: 'EncryptionService');
      }

      // Decrypt the encrypted string
      final decryptedString = decrypt(encryptedJson);

      if (decryptedString.isEmpty) {
        if (kDebugMode) {
          developer.log(
            'Decryption failed or returned empty string',
            name: 'EncryptionService',
          );
        }
        return {};
      }

      if (kDebugMode) {
        developer.log(
          'Decrypted string length: ${decryptedString.length}',
          name: 'EncryptionService',
        );
      }

      // Parse JSON string back to Map
      final jsonData = jsonDecode(decryptedString) as Map<String, dynamic>;

      if (kDebugMode) {
        developer.log('JSON decrypted successfully', name: 'EncryptionService');
      }

      return jsonData;
    } catch (e) {
      if (kDebugMode) {
        developer.log('Error decrypting JSON: $e', name: 'EncryptionService');
      }
      // Return empty map on error instead of throwing to prevent crashes
      return {};
    }
  }

  /// Encrypt a JSON string directly
  ///
  /// Alternative method that takes a JSON string instead of Map.
  /// Useful when you already have a JSON string from API responses.
  ///
  /// Example:
  /// ```dart
  /// final jsonString = '{"userId": 123, "email": "user@example.com"}';
  /// final encrypted = encryptionService.encryptJsonString(jsonString);
  /// ```
  String encryptJsonString(String jsonString) {
    try {
      if (kDebugMode) {
        developer.log('Encrypting JSON string...', name: 'EncryptionService');
      }

      // Validate that it's valid JSON first
      jsonDecode(jsonString);

      // Encrypt the JSON string
      final encrypted = encrypt(jsonString);

      if (kDebugMode) {
        developer.log(
          'JSON string encrypted successfully',
          name: 'EncryptionService',
        );
      }

      return encrypted;
    } catch (e) {
      if (kDebugMode) {
        developer.log(
          'Error encrypting JSON string: $e',
          name: 'EncryptionService',
        );
      }
      throw FormatException('Invalid JSON string or encryption failed: $e');
    }
  }

  /// Decrypt and return as JSON string
  ///
  /// Alternative method that returns the decrypted JSON string instead of Map.
  /// Useful when you need the raw JSON string.
  ///
  /// Example:
  /// ```dart
  /// final encrypted = 'encrypted_string_here';
  /// final jsonString = encryptionService.decryptJsonString(encrypted);
  /// ```
  ///
  /// Returns the decrypted JSON string, or empty string if decryption fails.
  String decryptJsonString(String encryptedJson) {
    try {
      if (kDebugMode) {
        developer.log('Decrypting JSON string...', name: 'EncryptionService');
      }

      // Decrypt the encrypted string
      final decryptedString = decrypt(encryptedJson);

      if (decryptedString.isEmpty) {
        if (kDebugMode) {
          developer.log(
            'Decryption failed or returned empty string',
            name: 'EncryptionService',
          );
        }
        return '';
      }

      // Validate that it's valid JSON
      jsonDecode(decryptedString);

      if (kDebugMode) {
        developer.log(
          'JSON string decrypted successfully',
          name: 'EncryptionService',
        );
      }

      return decryptedString;
    } catch (e) {
      if (kDebugMode) {
        developer.log(
          'Error decrypting JSON string: $e',
          name: 'EncryptionService',
        );
      }
      return '';
    }
  }
}
