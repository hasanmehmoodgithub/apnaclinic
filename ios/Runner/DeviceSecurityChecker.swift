import Foundation
import UIKit
import MachO

/// Device integrity heuristics for Flutter `SecurityService` MethodChannel.
enum DeviceSecurityChecker {
  static func isJailbroken() -> Bool {
    if isSimulator() { return false }

    let paths = [
      "/Applications/Cydia.app",
      "/Library/MobileSubstrate/MobileSubstrate.dylib",
      "/bin/bash",
      "/usr/sbin/sshd",
      "/etc/apt",
      "/private/var/lib/apt/",
      "/private/var/lib/cydia",
      "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
      "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
      "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
      "/var/cache/apt",
      "/var/lib/apt",
      "/var/lib/cydia",
      "/usr/libexec/ssh-keysign",
      "/usr/bin/sshd",
      "/etc/ssh/sshd_config",
      "/Applications/FakeCarrier.app",
      "/Applications/Icy.app",
      "/Applications/SBSettings.app",
      "/Applications/WinterBoard.app",
      "/Applications/blackra1n.app",
    ]

    for path in paths where FileManager.default.fileExists(atPath: path) {
      return true
    }

    // Writable outside sandbox is a common jailbreak signal.
    let testPath = "/private/jailbreak_test_\(UUID().uuidString).txt"
    do {
      try "test".write(toFile: testPath, atomically: true, encoding: .utf8)
      try? FileManager.default.removeItem(atPath: testPath)
      return true
    } catch {
      // Expected on non-jailbroken devices.
    }

    return false
  }

  static func isSimulator() -> Bool {
#if targetEnvironment(simulator)
    return true
#else
    return false
#endif
  }

  static func isFridaPresent() -> Bool {
    let suspicious = ["frida", "fridagadget", "frida-agent", "libfrida"]
    let count = _dyld_image_count()
    for i in 0..<count {
      guard let cName = _dyld_get_image_name(i) else { continue }
      let image = String(cString: cName).lowercased()
      if suspicious.contains(where: { image.contains($0) }) {
        return true
      }
    }

    let fridaPaths = [
      "/usr/lib/frida",
      "/usr/lib/frida/frida-agent.dylib",
      "/Library/MobileSubstrate/DynamicLibraries/FridaGadget.dylib",
    ]
    return fridaPaths.contains { FileManager.default.fileExists(atPath: $0) }
  }
}
