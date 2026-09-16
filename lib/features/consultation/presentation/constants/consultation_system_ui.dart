import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

/// Transparent system navigation bar so consultation screens do not show the
/// opaque white strip inherited from the home shell bottom-nav overlay style.
const consultationSystemUiOverlay = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
  systemNavigationBarColor: Colors.transparent,
  systemNavigationBarDividerColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.dark,
  systemNavigationBarContrastEnforced: false,
);
