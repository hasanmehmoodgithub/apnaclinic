import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

/// Requests microphone access; returns true when granted.
///
/// Returns `false` when denied, permanently denied, or when the native plugin
/// is unavailable (e.g. after hot restart without a full rebuild).
Future<bool> ensureMicrophonePermission() async {
  try {
    final current = await Permission.microphone.status;
    if (current.isGranted) return true;

    final requested = await Permission.microphone.request();
    return requested.isGranted;
  } on MissingPluginException {
    return false;
  } on PlatformException {
    return false;
  }
}
