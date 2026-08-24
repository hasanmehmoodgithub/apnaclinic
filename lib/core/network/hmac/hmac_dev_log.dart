import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Debug-only HMAC logs. Never used for secrets.
void hmacDevLog(String message) {
  if (!kDebugMode) return;
  developer.log(message, name: 'HmacSigning');
}
