import 'package:flutter/material.dart';

bool get isDevicePreviewEnabled => false;

Widget wrapWithDevicePreview({required Widget child}) => child;

Locale? devicePreviewLocale(BuildContext context) => null;

Widget? applyDevicePreviewBuilder(BuildContext context, Widget? child) => child;

List<Locale> mergeSupportedLocales(List<Locale> appLocales) => appLocales;
