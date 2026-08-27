# 🔐 Native Security Guide

Complete guide for using native platform security for encryption keys.

---

## 📖 Overview

The `NativeSecurity` class provides a secure way to retrieve encryption keys from the native platform (Android/iOS) using method channels. This ensures that sensitive keys are stored and retrieved at the native level, providing an additional layer of security.

---

## 🎯 Why Use Native Security?

### Security Benefits

1. **Platform-Level Security**
   - Keys are stored in native code (C++/Kotlin/Swift)
   - Not easily accessible from Flutter/Dart code
   - Can leverage platform-specific secure storage (Android Keystore, iOS Keychain)

2. **Protection Against Reverse Engineering**
   - Native code is compiled to machine code
   - Harder to decompile and analyze than Dart code
   - Obfuscation is more effective at native level

3. **Hardware-Backed Security**
   - Can use hardware security modules (HSM)
   - Android Keystore provides hardware-backed key storage
   - iOS Keychain uses Secure Enclave on supported devices

4. **Separation of Concerns**
   - Security logic separated from application logic
   - Easier to audit and maintain
   - Follows security best practices

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter App (Dart)                    │
│  ┌──────────────────────────────────────────────────┐  │
│  │         NativeSecurity.getSecretKey()             │  │
│  └──────────────────┬───────────────────────────────┘  │
└──────────────────────┼─────────────────────────────────┘
                       │ MethodChannel: "native/keys"
                       ▼
┌─────────────────────────────────────────────────────────┐
│              Android/iOS Native Layer                    │
│  ┌──────────────────────────────────────────────────┐  │
│  │  MainActivity.kt / AppDelegate.swift             │  │
│  │  └─> MethodChannel Handler                       │  │
│  └──────────────────┬───────────────────────────────┘  │
│                     │                                    │
│  ┌──────────────────▼──────────────────────────────┐  │
│  │  NativeKeyProvider.kt / NativeKeyProvider.swift   │  │
│  │  └─> JNI/FFI Bridge                              │  │
│  └──────────────────┬───────────────────────────────┘  │
│                     │                                    │
│  ┌──────────────────▼──────────────────────────────┐  │
│  │  native-lib.cpp (C++)                            │  │
│  │  └─> Secure Key Generation/Retrieval             │  │
│  └──────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

---

## 📱 Platform Implementation

### Android

**Files:**
- `MainActivity.kt` — Method channel `native/keys`
- `NativeKeyProvider.kt` — AndroidKeyStore wrap of a persisted secret

**Flow:**
1. Flutter calls `NativeSecurity.getSecretKey()`
2. Method channel sends `getSecretKey` to `MainActivity`
3. `NativeKeyProvider` unwraps (or generates once) a 32-byte Base64 secret
4. The same string is returned on every launch

AndroidKeyStore AES keys cannot export raw bytes. The secret is generated once, encrypted with a Keystore AES-GCM wrapping key, and stored in SharedPreferences.

### iOS

**Files:**
- `AppDelegate.swift` — Method channel `native/keys` (registered in `didInitializeImplicitFlutterEngine`)
- `NativeKeyProvider.swift` — Keychain generic password

**Flow:**
1. Flutter calls `NativeSecurity.getSecretKey()`
2. Method channel sends `getSecretKey` to `AppDelegate`
3. `NativeKeyProvider` reads (or generates once) a 32-byte Base64 secret from Keychain

---

## 🚀 Usage

### Basic Usage

```dart
import 'package:teknosys_flutter_base_architecture/core/security/native_security.dart';

// Get secret key from native platform
try {
  final key = await NativeSecurity.getSecretKey();
  print('Secret key: $key');
} catch (e) {
  print('Error: $e');
}
```

### With Encryption Service

The `EncryptionService` automatically uses `NativeSecurity`:

```dart
import 'package:teknosys_flutter_base_architecture/core/services/encryption_service.dart';

final encryptionService = EncryptionService();
await encryptionService.initialize(); // Automatically calls NativeSecurity

// Use encryption
final encrypted = encryptionService.encrypt('Sensitive data');
```

---

## ⚙️ Setup

Native registration is already wired:

- **Android:** `MainActivity` registers `native/keys`; `NativeKeyProvider.kt` wraps a one-time secret with AndroidKeyStore AES-GCM.
- **iOS:** `AppDelegate.didInitializeImplicitFlutterEngine` registers `native/keys`; `NativeKeyProvider.swift` stores the secret in Keychain.

A full native rebuild is required after changing Kotlin/Swift (`flutter run` / stop and relaunch). Hot reload will not register a new method channel.

If the channel is missing, `EncryptionService` logs this warning and uses a persisted Dart fallback key. Switching from fallback to native later changes the combined encryption key, so existing encrypted prefs (login status, etc.) become unreadable until the user signs in again.

---

## 🔒 Security Best Practices

### 1. Use Android Keystore (Android)

```kotlin
// In native-lib.cpp or Kotlin
// Use Android Keystore for hardware-backed keys
val keyStore = KeyStore.getInstance("AndroidKeyStore")
keyStore.load(null)
// Generate or retrieve key from keystore
```

### 2. Use iOS Keychain (iOS)

```swift
// Store key in Keychain
let query: [String: Any] = [
    kSecClass as String: kSecClassGenericPassword,
    kSecAttrAccount as String: "secretKey",
    kSecValueData as String: keyData
]
SecItemAdd(query as CFDictionary, nil)
```

### 3. Key Derivation

```cpp
// Use PBKDF2 or similar for key derivation
// Never hardcode keys in production
std::string deriveKey(const std::string& salt) {
    // Implement secure key derivation
    return derivedKey;
}
```

### 4. Obfuscation

- Use code obfuscation tools
- Minimize key exposure in logs
- Use ProGuard/R8 for Android
- Use Swift obfuscation for iOS

---

## 🐛 Troubleshooting

### Error: "Method channel not registered"

**Solution:**
- Ensure `MainActivity.kt` (Android) or `AppDelegate.swift` (iOS) registers the method channel
- Check channel name matches: `"native/keys"`

### Error: "Native method returned null"

**Solution:**
- Check C++/Swift implementation returns a valid string
- Verify JNI function name matches package name exactly
- Check native library is loaded correctly

### Error: "Platform error"

**Solution:**
- Check native code compiles without errors
- Verify CMakeLists.txt (Android) is configured correctly
- Check build.gradle.kts includes NDK configuration

---

## 📝 Example: Production Implementation

### Android with Keystore

```kotlin
// NativeKeyProvider.kt
class NativeKeyProvider {
    companion object {
        @JvmStatic
        fun getSecretKey(): String {
            val keyStore = KeyStore.getInstance("AndroidKeyStore")
            keyStore.load(null)
            
            // Get or generate key
            val key = keyStore.getKey("app_secret_key", null)
            return String(key.encoded)
        }
    }
}
```

### iOS with Keychain

```swift
// NativeKeyProvider.swift
@objc class NativeKeyProvider: NSObject {
    @objc static func getSecretKey() -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "app_secret_key",
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess {
            let data = result as! Data
            return String(data: data, encoding: .utf8) ?? ""
        }
        
        // Generate new key if not found
        return generateNewKey()
    }
}
```

---

## ✅ Checklist

- [ ] Native method channel registered in MainActivity/AppDelegate
- [ ] C++/Swift implementation returns valid key
- [ ] JNI function name matches package name exactly
- [ ] CMakeLists.txt configured (Android)
- [ ] build.gradle.kts includes NDK config (Android)
- [ ] Key generation uses secure methods (not hardcoded)
- [ ] Error handling implemented
- [ ] Logging uses `developer.log()` (not `print()`)
- [ ] Production keys use Keystore/Keychain

---

## 📚 Files

- **Flutter:** `lib/core/security/native_security.dart`
- **Android MainActivity:** `android/app/src/main/kotlin/.../MainActivity.kt`
- **Android Bridge:** `android/app/src/main/kotlin/.../NativeKeyProvider.kt`
- **Android C++:** `android/app/src/main/cpp/native-lib.cpp`
- **Android Build:** `android/app/build.gradle.kts`
- **Android CMake:** `android/app/CMakeLists.txt`
- **iOS:** `ios/Runner/AppDelegate.swift` (to be implemented)

---

## 🔗 Related

- [Encryption Service Guide](../services/guides/ENCRYPTION_GUIDE.md)
- [Security Service](../security/security_service.dart)
- [Flutter Method Channels](https://docs.flutter.dev/platform-integration/platform-channels)

---

**That's it! Your native security implementation is ready. 🔐**
