// File generated from android/app/google-services.json and
// ios/Runner/GoogleService-Info.plist (project: notificationtes-dc9f6).
// ignore_for_file: type=lint

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static bool get isConfigured {
    try {
      final options = currentPlatform;
      return _isValid(options.apiKey) && _isValid(options.appId);
    } catch (_) {
      return false;
    }
  }

  static bool _isValid(String value) {
    final normalized = value.trim();
    return normalized.isNotEmpty && !normalized.contains('REPLACE_ME');
  }

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web.',
      );
    }
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => android,
      TargetPlatform.iOS => ios,
      TargetPlatform.macOS => ios,
      _ => throw UnsupportedError(
        'DefaultFirebaseOptions are not supported for this platform.',
      ),
    };
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB8L-lDz2pou5r97S-pTqp6t0dyYo7-JPo',
    appId: '1:411885842320:android:88a2f0eb4cb41432c44d15',
    messagingSenderId: '411885842320',
    projectId: 'notificationtes-dc9f6',
    storageBucket: 'notificationtes-dc9f6.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCOKenPCOZpkscjMjeTSO0hJc3vtq_VKLc',
    appId: '1:411885842320:ios:37b0a077d18d37ebc44d15',
    messagingSenderId: '411885842320',
    projectId: 'notificationtes-dc9f6',
    storageBucket: 'notificationtes-dc9f6.firebasestorage.app',
    iosBundleId: 'com.apna.clinic.ios',
  );
}
