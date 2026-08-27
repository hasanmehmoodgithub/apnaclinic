// File generated from android/app/google-services.json and
// ios/Runner/GoogleService-Info.plist (project: apna-clinic-mobile-app).
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
    apiKey: 'AIzaSyDp5B6a-Zp2erRYrQz4PZrCVSVVMwg_sZ4',
    appId: '1:293590853827:android:bc2f2cc68e51c231c71a76',
    messagingSenderId: '293590853827',
    projectId: 'apna-clinic-mobile-app',
    storageBucket: 'apna-clinic-mobile-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDbwSbx1FIPHkPG4kBZDhRMnkzNtoFqBGI',
    appId: '1:293590853827:ios:71c9192518f0960ac71a76',
    messagingSenderId: '293590853827',
    projectId: 'apna-clinic-mobile-app',
    storageBucket: 'apna-clinic-mobile-app.firebasestorage.app',
    iosBundleId: 'com.apna.clinic.ios',
  );
}
