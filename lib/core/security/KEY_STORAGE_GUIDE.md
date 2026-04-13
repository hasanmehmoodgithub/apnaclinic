# 🔑 Key Storage Guide - Android Keystore & iOS Keychain

Complete guide for adding and managing keys in Android Keystore and iOS Keychain.

---

## 📖 Overview

This guide shows you how to:
- Add keys to Android Keystore
- Add keys to iOS Keychain
- Change existing keys
- Use different key storage methods

---

## 🤖 Android Keystore

### Method 1: Hardcode in C++ (Development Only)

**File:** `android/app/src/main/cpp/native-lib.cpp`

```cpp
#include <jni.h>
#include <string>

extern "C"
JNIEXPORT jstring JNICALL
Java_com_example_teknosys_1flutter_1base_1architecture_NativeKeyProvider_getSecretKey(
    JNIEnv *env, jobject /* this */) {
    // Replace with your key
    std::string key = "YourSecureKey12345678901234567890";
    return env->NewStringUTF(key.c_str());
}
```

**⚠️ Warning:** Only for development. Never use in production!

---

### Method 2: Use Android Keystore (Recommended for Production)

**File:** `android/app/src/main/kotlin/com/example/teknosys_flutter_base_architecture/NativeKeyProvider.kt`

```kotlin
package com.example.teknosys_flutter_base_architecture

import android.content.Context
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import java.security.KeyStore
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey

class NativeKeyProvider {
    companion object {
        private const val KEYSTORE_ALIAS = "app_secret_key"
        private const val ANDROID_KEYSTORE = "AndroidKeyStore"
        
        @JvmStatic
        fun getSecretKey(): String {
            val keyStore = KeyStore.getInstance(ANDROID_KEYSTORE)
            keyStore.load(null)
            
            // Check if key exists
            if (keyStore.containsAlias(KEYSTORE_ALIAS)) {
                // Retrieve existing key
                val entry = keyStore.getEntry(KEYSTORE_ALIAS, null) as? KeyStore.SecretKeyEntry
                val secretKey = entry?.secretKey
                if (secretKey != null) {
                    return String(secretKey.encoded)
                }
            }
            
            // Generate new key
            val keyGenerator = KeyGenerator.getInstance(
                KeyProperties.KEY_ALGORITHM_AES,
                ANDROID_KEYSTORE
            )
            
            val keyGenParameterSpec = KeyGenParameterSpec.Builder(
                KEYSTORE_ALIAS,
                KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT
            )
                .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
                .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
                .setKeySize(256)
                .build()
            
            keyGenerator.init(keyGenParameterSpec)
            val secretKey = keyGenerator.generateKey()
            
            return String(secretKey.encoded)
        }
        
        // Manually set a custom key (development only)
        @JvmStatic
        fun setCustomKey(key: String): Boolean {
            // Note: Android Keystore doesn't support setting arbitrary keys
            // You would need to use SharedPreferences or another method
            // For production, always use auto-generated Keystore keys
            return false
        }
    }
}
```

**Update MainActivity.kt:**

```kotlin
// Remove the C++ library loading if using Kotlin implementation
// init {
//     System.loadLibrary("native-lib")
// }
// @JvmStatic
// external fun getSecretKey(): String
```

---

### Method 3: Use SharedPreferences (Less Secure)

**File:** `android/app/src/main/kotlin/com/example/teknosys_flutter_base_architecture/NativeKeyProvider.kt`

```kotlin
package com.example.teknosys_flutter_base_architecture

import android.content.Context
import android.content.SharedPreferences

class NativeKeyProvider(private val context: Context) {
    companion object {
        private const val PREFS_NAME = "secure_prefs"
        private const val KEY_NAME = "secret_key"
        
        @JvmStatic
        fun getSecretKey(context: Context): String {
            val prefs: SharedPreferences = context.getSharedPreferences(
                PREFS_NAME,
                Context.MODE_PRIVATE
            )
            
            // Try to get existing key
            val existingKey = prefs.getString(KEY_NAME, null)
            if (existingKey != null) {
                return existingKey
            }
            
            // Generate new key
            val newKey = generateRandomKey()
            
            // Store in SharedPreferences
            prefs.edit().putString(KEY_NAME, newKey).apply()
            
            return newKey
        }
        
        @JvmStatic
        fun setCustomKey(context: Context, key: String): Boolean {
            val prefs: SharedPreferences = context.getSharedPreferences(
                PREFS_NAME,
                Context.MODE_PRIVATE
            )
            return prefs.edit().putString(KEY_NAME, key).commit()
        }
        
        private fun generateRandomKey(): String {
            val chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
            return (1..32)
                .map { chars.random() }
                .joinToString("")
        }
    }
}
```

**Update MainActivity.kt:**

```kotlin
MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
    .setMethodCallHandler { call, result ->
        if (call.method == "getSecretKey") {
            try {
                val key = NativeKeyProvider.getSecretKey(this) // Pass context
                result.success(key)
            } catch (e: Exception) {
                result.error("ERROR", e.message, null)
            }
        } else {
            result.notImplemented()
        }
    }
```

---

## 🍎 iOS Keychain

### Method 1: Set Custom Key in Code

**File:** `ios/Runner/NativeKeyProvider.swift`

```swift
// Change this line to set your custom key
private static let customKey: String? = "YourCustomKey12345678901234567890"
```

**To disable custom key:**
```swift
private static let customKey: String? = nil  // Auto-generate
```

---

### Method 2: Set Key Programmatically

**From Swift code:**

```swift
// Set a custom key
let success = NativeKeyProvider.setCustomKey("YourNewKeyHere")
```

**From Flutter (via Method Channel):**

Add to `AppDelegate.swift`:

```swift
nativeKeysChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
    if call.method == "getSecretKey" {
        let key = NativeKeyProvider.getSecretKey()
        result(key)
    } else if call.method == "setCustomKey" {
        if let key = call.arguments as? String {
            let success = NativeKeyProvider.setCustomKey(key)
            result(success)
        } else {
            result(FlutterError(code: "INVALID_ARG", message: "Key must be a string", details: nil))
        }
    } else {
        result(FlutterMethodNotImplemented)
    }
}
```

**From Flutter Dart:**

```dart
// Add method to NativeSecurity class
static Future<bool> setCustomKey(String key) async {
  try {
    final result = await platform.invokeMethod<bool>('setCustomKey', key);
    return result ?? false;
  } catch (e) {
    developer.log('Error setting custom key: $e', name: 'NativeSecurity');
    return false;
  }
}

// Usage
await NativeSecurity.setCustomKey('YourNewKey123');
```

---

### Method 3: Change Keychain Account Name

**File:** `ios/Runner/NativeKeyProvider.swift`

```swift
// Change this to use a different Keychain entry
private static let keychainAccount = "my_custom_key_name"
```

This creates a new Keychain entry, leaving the old one untouched.

---

### Method 4: Delete and Regenerate

**From Swift:**

```swift
// Delete existing key
NativeKeyProvider.deleteKey()

// Next call will generate new key
let newKey = NativeKeyProvider.getSecretKey()
```

**From Flutter (add method):**

```dart
static Future<bool> deleteKey() async {
  try {
    final result = await platform.invokeMethod<bool>('deleteKey');
    return result ?? false;
  } catch (e) {
    developer.log('Error deleting key: $e', name: 'NativeSecurity');
    return false;
  }
}

// Usage
await NativeSecurity.deleteKey();
let newKey = await NativeSecurity.getSecretKey(); // Generates new key
```

---

## 🔄 Step-by-Step: Adding a Key

### Android (C++ Method - Simplest)

1. **Open:** `android/app/src/main/cpp/native-lib.cpp`

2. **Replace the key:**
```cpp
std::string key = "YourSecureKey12345678901234567890";
```

3. **Rebuild:**
```bash
flutter clean
flutter build apk
```

---

### Android (Keystore Method - Most Secure)

1. **Update:** `android/app/src/main/kotlin/com/example/teknosys_flutter_base_architecture/NativeKeyProvider.kt`

2. **Use the Keystore implementation** (see Method 2 above)

3. **Remove C++ dependency** from `NativeKeyProvider.kt`

4. **Rebuild:**
```bash
flutter clean
flutter build apk
```

---

### iOS (Custom Key Method - Simplest)

1. **Open:** `ios/Runner/NativeKeyProvider.swift`

2. **Set custom key:**
```swift
private static let customKey: String? = "YourSecureKey12345678901234567890"
```

3. **Rebuild:**
```bash
flutter clean
flutter build ios
```

---

### iOS (Programmatic Method)

1. **Add method to AppDelegate.swift** (see Method 2 above)

2. **Add method to NativeSecurity.dart** (see Method 2 above)

3. **Call from Flutter:**
```dart
await NativeSecurity.setCustomKey('YourKeyHere');
```

---

## 🔐 Security Comparison

| Method | Security Level | Use Case |
|--------|---------------|----------|
| **Android Keystore** | ⭐⭐⭐⭐⭐ | Production (Hardware-backed) |
| **iOS Keychain** | ⭐⭐⭐⭐⭐ | Production (Secure Enclave) |
| **Hardcoded in C++** | ⭐⭐ | Development only |
| **SharedPreferences** | ⭐⭐⭐ | Development/Testing |

---

## ✅ Best Practices

### Android

1. **Production:** Use Android Keystore (hardware-backed)
2. **Development:** Use C++ hardcoded or SharedPreferences
3. **Never:** Hardcode keys in production code

### iOS

1. **Production:** Use auto-generated keys in Keychain
2. **Development:** Can use custom keys
3. **Never:** Hardcode keys in production code

---

## 🧪 Testing

### Test Key Change (Android)

```kotlin
// In MainActivity or test
val key1 = NativeKeyProvider.getSecretKey()
// Change key in C++ or Keystore
val key2 = NativeKeyProvider.getSecretKey()
// Verify change
```

### Test Key Change (iOS)

```swift
// Delete old key
NativeKeyProvider.deleteKey()

// Set new key
NativeKeyProvider.setCustomKey("NewKey123")

// Verify
let key = NativeKeyProvider.getSecretKey()
assert(key == "NewKey123")
```

---

## 📝 Quick Reference

### Android - Change Key in C++

```cpp
// File: android/app/src/main/cpp/native-lib.cpp
std::string key = "YourNewKeyHere";
```

### iOS - Change Key in Code

```swift
// File: ios/Runner/NativeKeyProvider.swift
private static let customKey: String? = "YourNewKeyHere"
```

### iOS - Change Key Programmatically

```swift
NativeKeyProvider.setCustomKey("YourNewKeyHere")
```

### iOS - Change Keychain Account

```swift
// File: ios/Runner/NativeKeyProvider.swift
private static let keychainAccount = "new_key_name"
```

---

## 🐛 Troubleshooting

### Key Not Changing

- **Android:** Rebuild the app after changing C++ code
- **iOS:** Delete app and reinstall, or call `deleteKey()` first

### Key Not Persisting

- **Android:** Check Keystore permissions
- **iOS:** Check Keychain access rights

### Multiple Keys

- Use different account names/aliases for different keys

---

## 📚 Files

- **Android C++:** `android/app/src/main/cpp/native-lib.cpp`
- **Android Kotlin:** `android/app/src/main/kotlin/.../NativeKeyProvider.kt`
- **iOS Swift:** `ios/Runner/NativeKeyProvider.swift`
- **Flutter:** `lib/core/security/native_security.dart`

---

**That's it! You can now add and manage keys in both Android Keystore and iOS Keychain. 🔑**
