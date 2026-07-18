// ignore_for_file: depend_on_referenced_packages

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Debug-only device frame preview. Disabled in release (`dart.vm.product`).
///
/// Opt out: `flutter run --dart-define=ENABLE_DEVICE_PREVIEW=false`
bool get isDevicePreviewEnabled {
  if (kReleaseMode) return false;
  const flag = String.fromEnvironment(
    'ENABLE_DEVICE_PREVIEW',
    defaultValue: 'false',
  );
  return flag.toLowerCase() != 'false';
}

Widget wrapWithDevicePreview({required Widget child}) {
  return DevicePreview(
    enabled: isDevicePreviewEnabled,
    builder: (_) => child,
  );
}

Locale? devicePreviewLocale(BuildContext context) {
  if (!isDevicePreviewEnabled) return null;
  return DevicePreview.locale(context);
}

Widget? applyDevicePreviewBuilder(BuildContext context, Widget? child) {
  if (!isDevicePreviewEnabled) return child;
  return DevicePreview.appBuilder(context, child);
}

List<Locale> mergeSupportedLocales(List<Locale> appLocales) {
  if (!isDevicePreviewEnabled) return appLocales;
  final previewLocales =
      defaultAvailableLocales.map((e) => Locale(e.code)).toList();
  return [...appLocales, ...previewLocales];
}
