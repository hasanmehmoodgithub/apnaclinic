import AVFoundation
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
    let messenger = engineBridge.applicationRegistrar.messenger()
    registerSecurityChannels(messenger: messenger)
    registerMediaSessionChannel(messenger: messenger)
  }

  private func registerMediaSessionChannel(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(
      name: "apna_clinic/media_session",
      binaryMessenger: messenger
    )
    channel.setMethodCallHandler { call, result in
      guard call.method == "configureForWebRtc" else {
        result(FlutterMethodNotImplemented)
        return
      }
      do {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(
          .playAndRecord,
          mode: .videoChat,
          options: [.defaultToSpeaker, .allowBluetooth]
        )
        try session.setActive(true)
        result(true)
      } catch {
        result(
          FlutterError(
            code: "audio_session",
            message: error.localizedDescription,
            details: nil
          )
        )
      }
    }
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
