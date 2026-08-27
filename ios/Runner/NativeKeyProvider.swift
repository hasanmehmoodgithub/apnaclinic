import Foundation
import Security

/// Stable app secret for Flutter `EncryptionService`, stored in the Keychain.
enum NativeKeyProvider {
  private static let service = "com.apna.clinic.native.keys"
  private static let account = "app_secret_key"
  private static let keyByteCount = 32

  static func getSecretKey() throws -> String {
    if let existing = try readKey() {
      return existing
    }
    let generated = try generateSecret()
    try storeKey(generated)
    return generated
  }

  private static func generateSecret() throws -> String {
    var bytes = [UInt8](repeating: 0, count: keyByteCount)
    let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
    guard status == errSecSuccess else {
      throw NativeKeyError.generationFailed(status)
    }
    return Data(bytes).base64EncodedString()
  }

  private static func readKey() throws -> String? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne,
    ]
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    if status == errSecItemNotFound {
      return nil
    }
    guard status == errSecSuccess,
      let data = item as? Data,
      let key = String(data: data, encoding: .utf8),
      !key.isEmpty
    else {
      throw NativeKeyError.unreadable
    }
    return key
  }

  private static func storeKey(_ key: String) throws {
    guard let data = key.data(using: .utf8) else {
      throw NativeKeyError.unreadable
    }
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
      kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
      kSecValueData as String: data,
    ]
    let status = SecItemAdd(query as CFDictionary, nil)
    guard status == errSecSuccess else {
      throw NativeKeyError.storeFailed(status)
    }
  }

  private enum NativeKeyError: Error {
    case unreadable
    case generationFailed(OSStatus)
    case storeFailed(OSStatus)
  }
}
