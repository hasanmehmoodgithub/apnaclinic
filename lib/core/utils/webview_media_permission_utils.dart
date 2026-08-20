import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'microphone_permission_utils.dart';

const _mediaSessionChannel = MethodChannel('apna_clinic/media_session');

/// Requests camera access; returns true when granted.
Future<bool> ensureCameraPermission() async {
  try {
    final current = await Permission.camera.status;
    if (current.isGranted) return true;

    final requested = await Permission.camera.request();
    return requested.isGranted;
  } on MissingPluginException {
    return false;
  } on PlatformException {
    return false;
  }
}

/// Requests OS camera + microphone. Returns true only when both are granted.
Future<bool> ensureCameraAndMicrophonePermissions() async {
  final cameraGranted = await ensureCameraPermission();
  final microphoneGranted = await ensureMicrophonePermission();
  return cameraGranted && microphoneGranted;
}

/// iOS WKWebView getUserMedia needs PlayAndRecord + speaker for camera/mic.
Future<void> configureWebViewMediaSession() async {
  if (defaultTargetPlatform != TargetPlatform.iOS) return;
  try {
    await _mediaSessionChannel.invokeMethod<void>('configureForWebRtc');
  } on MissingPluginException {
    return;
  } on PlatformException {
    return;
  }
}

/// Grants a WebView getUserMedia request immediately.
///
/// Android/iOS auto-deny camera/mic if this callback waits on OS permission
/// dialogs. Call [ensureCameraAndMicrophonePermissions] before loading the page.
void grantWebViewMediaPermission(WebViewPermissionRequest request) {
  request.grant();
}
