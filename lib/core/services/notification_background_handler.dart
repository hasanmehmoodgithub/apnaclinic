import 'dart:developer' as developer;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

import '../firebase/firebase_bootstrap.dart';

/// Top-level handler for background/terminated FCM messages.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  final ready = await FirebaseBootstrap.initialize();
  if (!ready) return;

  developer.log(
    'Background message: ${message.messageId} data=${message.data}',
    name: 'firebaseMessagingBackgroundHandler',
  );
}
