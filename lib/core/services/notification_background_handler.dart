import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

import '../../firebase_options.dart';

/// Top-level handler for background/terminated FCM messages.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!DefaultFirebaseOptions.isConfigured) return;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    developer.log(
      'Background Firebase init failed: $e',
      name: 'firebaseMessagingBackgroundHandler',
    );
    return;
  }

  developer.log(
    'Background message: ${message.messageId} data=${message.data}',
    name: 'firebaseMessagingBackgroundHandler',
  );
}
