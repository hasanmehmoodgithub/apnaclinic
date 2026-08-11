import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }
    application.registerForRemoteNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    registerSecurityChannels(messenger: engineBridge.applicationRegistrar.messenger())
  }

  private func registerSecurityChannels(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(
      name: "security_channel",
      binaryMessenger: messenger
    )
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "checkJailbreak":
        result(DeviceSecurityChecker.isJailbroken())
      case "checkEmulator":
        result(DeviceSecurityChecker.isSimulator())
      case "checkFrida":
        result(DeviceSecurityChecker.isFridaPresent())
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}
