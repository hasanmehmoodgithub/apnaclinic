import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Top-level function for handling background messages
/// This must be a top-level or static function
/// Called when app is in background or terminated
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('Background message handler called');
    print('Message ID: ${message.messageId}');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Data: ${message.data}');
  }

  // Initialize Firebase if not already initialized
  // Note: Firebase should already be initialized in main.dart
  // await Firebase.initializeApp();

  // You can perform background operations here:
  // - Save notification to local database
  // - Update local cache
  // - Schedule local notifications
  // - etc.

  // Navigation will be handled when app is opened
  // See NotificationService.handleBackgroundMessage()
}
