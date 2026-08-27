# 🔐 Encryption Service Guide

Simple guide for using encryption in your Flutter app.

---

## 📖 Overview

`EncryptionService` provides secure encryption and decryption for:
- **Strings** - Text data encryption
- **JSON Objects** - Encrypt/decrypt API responses and data structures
- **JSON Strings** - Direct JSON string encryption

It uses a combination of:
- **Native key** (from Android/iOS via method channel)
- **Random secret key** (stored in FlutterSecureStorage)
- **HMAC-SHA256** for integrity verification
- **XOR encryption** with random IV

---

## 🚀 Quick Start

### 1. Initialize Service

```dart
import 'core/services/encryption_service.dart';
import 'core/di/dependency_injection.dart';

// Get from dependency injection
final encryptionService = sl<EncryptionService>();

// Initialize (call once at app startup)
await encryptionService.initialize();
```

### 2. Basic Usage

```dart
// Encrypt string
final encrypted = encryptionService.encrypt('Hello World');
print('Encrypted: $encrypted');

// Decrypt string
final decrypted = encryptionService.decrypt(encrypted);
print('Decrypted: $decrypted');
```

---

## 📝 Methods

### String Encryption

#### `encrypt(String plainText)`
Encrypts a plain text string.

```dart
final encrypted = encryptionService.encrypt('Sensitive data');
```

#### `decrypt(String encryptedText)`
Decrypts an encrypted string.

```dart
final decrypted = encryptionService.decrypt(encrypted);
```

**Returns:** Decrypted string, or empty string if decryption fails.

---

### JSON Encryption

#### `encryptJson(Map<String, dynamic> jsonData)`
Encrypts a JSON object (Map).

```dart
final jsonData = {
  'userId': 123,
  'email': 'user@example.com',
  'token': 'abc123'
};

final encrypted = encryptionService.encryptJson(jsonData);
```

**Throws:** `FormatException` if JSON encoding fails.

#### `decryptJson(String encryptedJson)`
Decrypts encrypted JSON back to Map.

```dart
final encrypted = 'encrypted_string_here';
final jsonData = encryptionService.decryptJson(encrypted);

print(jsonData['userId']); // 123
print(jsonData['email']);  // user@example.com
```

**Returns:** `Map<String, dynamic>`, or empty Map `{}` if decryption fails.

#### `encryptJsonString(String jsonString)`
Encrypts a JSON string directly.

```dart
final jsonString = '{"userId": 123, "email": "user@example.com"}';
final encrypted = encryptionService.encryptJsonString(jsonString);
```

**Throws:** `FormatException` if JSON is invalid or encryption fails.

#### `decryptJsonString(String encryptedJson)`
Decrypts and returns JSON string.

```dart
final encrypted = 'encrypted_string_here';
final jsonString = encryptionService.decryptJsonString(encrypted);
```

**Returns:** Decrypted JSON string, or empty string if decryption fails.

---

## 💡 Usage Examples

### Example 1: Encrypt API Response

```dart
// API response as Map
final apiResponse = {
  'userId': 123,
  'email': 'user@example.com',
  'token': 'secret_token_123',
  'refreshToken': 'refresh_token_456'
};

// Encrypt for secure storage
final encrypted = encryptionService.encryptJson(apiResponse);

// Store in secure storage
await secureStorage.write(key: 'user_data', value: encrypted);
```

### Example 2: Decrypt Stored Data

```dart
// Retrieve encrypted data
final encrypted = await secureStorage.read(key: 'user_data');

if (encrypted != null) {
  // Decrypt back to Map
  final userData = encryptionService.decryptJson(encrypted);
  
  print('User ID: ${userData['userId']}');
  print('Email: ${userData['email']}');
  print('Token: ${userData['token']}');
}
```

### Example 3: Encrypt JSON String from API

```dart
// API returns JSON string
final jsonString = await apiClient.get('/user/profile');

// Encrypt the JSON string
final encrypted = encryptionService.encryptJsonString(jsonString);

// Store securely
await secureStorage.write(key: 'profile_data', value: encrypted);
```

### Example 4: Decrypt JSON String

```dart
// Get encrypted JSON string
final encrypted = await secureStorage.read(key: 'profile_data');

if (encrypted != null) {
  // Decrypt to JSON string
  final jsonString = encryptionService.decryptJsonString(encrypted);
  
  // Parse if needed
  final profileData = jsonDecode(jsonString);
  print(profileData);
}
```

### Example 5: Error Handling

```dart
try {
  final jsonData = {
    'userId': 123,
    'email': 'user@example.com'
  };
  
  final encrypted = encryptionService.encryptJson(jsonData);
  // Store encrypted data
} on FormatException catch (e) {
  print('Encryption failed: $e');
  // Handle error
}

// Decryption with safe fallback
final encrypted = 'encrypted_data';
final jsonData = encryptionService.decryptJson(encrypted);

if (jsonData.isEmpty) {
  print('Decryption failed or data is empty');
  // Handle error - maybe re-fetch from API
} else {
  // Use decrypted data
  print('User ID: ${jsonData['userId']}');
}
```

---

## 🔧 Setup

### Dependencies

Already included in `pubspec.yaml`:

```yaml
dependencies:
  crypto: ^3.0.6
  flutter_secure_storage: ^9.2.2
```

### Native Integration

The service uses `NativeSecurity.getSecretKey()` on MethodChannel `native/keys`.

- **Android:** `MainActivity` registers the channel; `NativeKeyProvider` wraps a one-time 32-byte secret with AndroidKeyStore AES-GCM.
- **iOS:** `AppDelegate` registers the channel; `NativeKeyProvider` stores the same secret in Keychain.

If the channel is missing, `EncryptionService` falls back to a persisted Dart-generated key (less secure, and a later native key change will make existing encrypted prefs unreadable).

---

## 🎯 Best Practices

### 1. Initialize Once

```dart
// ✅ Good - Initialize in main() or app initialization
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final encryptionService = EncryptionService();
  await encryptionService.initialize();
  
  runApp(MyApp());
}

// ❌ Bad - Don't initialize multiple times
void encryptData() {
  final service = EncryptionService();
  await service.initialize(); // Unnecessary if already initialized
}
```

### 2. Use JSON Methods for Structured Data

```dart
// ✅ Good - Use encryptJson for Maps
final userData = {'userId': 123, 'email': 'user@example.com'};
final encrypted = encryptionService.encryptJson(userData);

// ❌ Bad - Manual JSON encoding
final jsonString = jsonEncode(userData);
final encrypted = encryptionService.encrypt(jsonString);
```

### 3. Handle Errors Gracefully

```dart
// ✅ Good - Check for empty results
final jsonData = encryptionService.decryptJson(encrypted);
if (jsonData.isEmpty) {
  // Handle decryption failure
  return;
}

// ❌ Bad - Assume decryption always works
final jsonData = encryptionService.decryptJson(encrypted);
final userId = jsonData['userId']; // Might throw if empty
```

### 4. Store Encrypted Data Securely

```dart
// ✅ Good - Use FlutterSecureStorage for encrypted data
final encrypted = encryptionService.encryptJson(userData);
await secureStorage.write(key: 'user_data', value: encrypted);

// ❌ Bad - Store in SharedPreferences (less secure)
await prefs.setString('user_data', encrypted);
```

### 5. Validate JSON Before Encryption

```dart
// ✅ Good - encryptJson validates automatically
final encrypted = encryptionService.encryptJson(jsonData);

// For JSON strings, validate first
try {
  jsonDecode(jsonString); // Validate
  final encrypted = encryptionService.encryptJsonString(jsonString);
} catch (e) {
  // Handle invalid JSON
}
```

---

## 📋 Quick Reference

### Methods

| Method | Input | Output | Throws |
|--------|-------|--------|--------|
| `encrypt()` | `String` | `String` | No |
| `decrypt()` | `String` | `String` | No |
| `encryptJson()` | `Map<String, dynamic>` | `String` | `FormatException` |
| `decryptJson()` | `String` | `Map<String, dynamic>` | No |
| `encryptJsonString()` | `String` | `String` | `FormatException` |
| `decryptJsonString()` | `String` | `String` | No |

### Return Values on Error

- `encrypt()` / `decrypt()` - Returns empty string `''` on failure
- `decryptJson()` - Returns empty Map `{}` on failure
- `decryptJsonString()` - Returns empty string `''` on failure
- `encryptJson()` / `encryptJsonString()` - Throws `FormatException` on failure

---

## 🔍 How It Works

1. **Initialization:**
   - Gets native key from platform
   - Retrieves or generates random secret
   - Combines both keys
   - Normalizes to 32-byte key

2. **Encryption:**
   - Generates random IV (16 bytes)
   - XOR encrypts data with IV
   - Creates HMAC-SHA256 digest
   - Returns: `base64(iv + encrypted):digest`

3. **Decryption:**
   - Splits encrypted string
   - Extracts IV and encrypted data
   - XOR decrypts data
   - Verifies HMAC digest
   - Returns decrypted string

---

## ⚠️ Important Notes

1. **Always initialize** before using encryption methods
2. **Empty results** indicate decryption failure - handle gracefully
3. **JSON methods** validate JSON automatically
4. **Native key** should be stored securely (KeyStore/Keychain)
5. **Random secret** is stored in FlutterSecureStorage automatically

---

## 🎯 Summary

1. ✅ **Initialize**: `await encryptionService.initialize()`
2. ✅ **Encrypt Strings**: `encrypt('text')`
3. ✅ **Encrypt JSON**: `encryptJson({'key': 'value'})`
4. ✅ **Decrypt**: `decryptJson(encrypted)` or `decrypt(encrypted)`
5. ✅ **Handle Errors**: Check for empty results

---

That's it! Simple and secure. 🔐
