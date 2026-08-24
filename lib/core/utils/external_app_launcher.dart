import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../network/app_urls.dart';
import 'app_url_launcher.dart';

/// Opens another installed app, or its store listing when it is missing.
class ExternalAppLauncher {
  ExternalAppLauncher._();

  static const _channel = MethodChannel('apna_clinic/external_app');

  /// Opens FikrFree if installed; otherwise Play Store (Android) or App Store (iOS).
  static Future<void> openFikrFree() async {
    final opened = await _tryOpenInstalledApp(
      androidPackage: AppUrls.fikrFreeAndroidPackage,
      iosUrlSchemes: AppUrls.fikrFreeIosUrlSchemes,
    );
    if (opened) return;

    final storeUrl = !kIsWeb && Platform.isIOS
        ? AppUrls.fikrFreeAppStoreIos
        : AppUrls.fikrFreePlayStoreAndroid;
    await AppUrlLauncher.open(
      url: storeUrl,
      lunchMode: LaunchMode.externalApplication,
    );
  }

  static Future<bool> _tryOpenInstalledApp({
    required String androidPackage,
    required List<String> iosUrlSchemes,
  }) async {
    if (kIsWeb) return false;
    try {
      final result = await _channel.invokeMethod<bool>(
        'openInstalledApp',
        {
          'androidPackage': androidPackage,
          'iosUrlSchemes': iosUrlSchemes,
        },
      );
      return result == true;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }
}
