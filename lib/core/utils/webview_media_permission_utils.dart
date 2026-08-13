import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'microphone_permission_utils.dart';

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

/// Handles a WebView media permission prompt: ask OS first, then grant/deny.
Future<bool> handleWebViewMediaPermission(
  WebViewPermissionRequest request,
) async {
  final needsCamera = request.types.contains(WebViewPermissionResourceType.camera);
  final needsMicrophone = request.types.contains(
    WebViewPermissionResourceType.microphone,
  );

  if (!needsCamera && !needsMicrophone) {
    await request.grant();
    return true;
  }

  var allowed = true;
  if (needsCamera) {
    allowed = await ensureCameraPermission();
  }
  if (allowed && needsMicrophone) {
    allowed = await ensureMicrophonePermission();
  }

  if (allowed) {
    await request.grant();
    return true;
  }

  await request.deny();
  return false;
}
