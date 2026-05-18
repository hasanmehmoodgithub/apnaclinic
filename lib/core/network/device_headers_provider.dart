import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceHeadersProvider {
  DeviceHeadersProvider({
    DeviceInfoPlugin? deviceInfoPlugin,
    Future<PackageInfo> Function()? packageInfoLoader,
  }) : _deviceInfoPlugin = deviceInfoPlugin ?? DeviceInfoPlugin(),
       _packageInfoLoader = packageInfoLoader ?? PackageInfo.fromPlatform;

  final DeviceInfoPlugin _deviceInfoPlugin;
  final Future<PackageInfo> Function() _packageInfoLoader;
  Future<Map<String, String>>? _cachedHeadersFuture;

  Future<Map<String, String>> headers() {
    return _cachedHeadersFuture ??= _loadHeaders();
  }

  Future<Map<String, String>> _loadHeaders() async {
    final packageInfo = await _packageInfoLoader();
    final headers = <String, String>{
      'x-app-version': packageInfo.version,
      'x-app-build-number': packageInfo.buildNumber,
      'x-app-package': packageInfo.packageName,
      'x-device-platform': _platformName,
      ...await _platformHeaders(),
    };

    headers.removeWhere((_, value) => value.trim().isEmpty);
    return Map.unmodifiable(headers);
  }

  String get _platformName {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isWindows) return 'windows';
    if (Platform.isLinux) return 'linux';
    if (Platform.isFuchsia) return 'fuchsia';
    return 'unknown';
  }

  Future<Map<String, String>> _platformHeaders() async {
    if (kIsWeb) {
      final web = await _deviceInfoPlugin.webBrowserInfo;
      return <String, String>{
        'x-device-model': web.browserName.name,
        'x-device-manufacturer': web.vendor ?? '',
        'x-os-version': web.platform ?? '',
      };
    }

    if (Platform.isAndroid) {
      final android = await _deviceInfoPlugin.androidInfo;
      return <String, String>{
        'x-device-id': android.id,
        'x-device-model': android.model,
        'x-device-manufacturer': android.manufacturer,
        'x-os-version': android.version.release,
        'x-os-sdk': android.version.sdkInt.toString(),
      };
    }

    if (Platform.isIOS) {
      final ios = await _deviceInfoPlugin.iosInfo;
      return <String, String>{
        'x-device-id': ios.identifierForVendor ?? '',
        'x-device-model': ios.utsname.machine,
        'x-device-manufacturer': 'Apple',
        'x-os-version': ios.systemVersion,
      };
    }

    if (Platform.isMacOS) {
      final mac = await _deviceInfoPlugin.macOsInfo;
      return <String, String>{
        'x-device-id': mac.systemGUID ?? '',
        'x-device-model': mac.model,
        'x-device-manufacturer': 'Apple',
        'x-os-version': mac.osRelease,
      };
    }

    if (Platform.isWindows) {
      final windows = await _deviceInfoPlugin.windowsInfo;
      return <String, String>{
        'x-device-id': windows.deviceId,
        'x-device-model': windows.computerName,
        'x-device-manufacturer': 'Microsoft',
        'x-os-version': windows.displayVersion,
      };
    }

    if (Platform.isLinux) {
      final linux = await _deviceInfoPlugin.linuxInfo;
      return <String, String>{
        'x-device-id': linux.machineId ?? '',
        'x-device-model': linux.prettyName,
        'x-device-manufacturer': linux.name,
        'x-os-version': linux.version ?? '',
      };
    }

    return const <String, String>{};
  }
}
