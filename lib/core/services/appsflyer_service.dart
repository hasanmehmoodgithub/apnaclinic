import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/foundation.dart';

import '../flavor/flavor_config.dart';

/// AppsFlyer attribution / analytics wrapper.
///
/// Safe without credentials: [initialize] is a no-op until
/// [FlavorConfig.appsFlyerDevKey] is set (iOS also needs [FlavorConfig.appsFlyerIosAppId]).
///
/// Product events are **separate** from Firebase [AnalyticsService] — call
/// [logEvent] only for AppsFlyer-specific conversions.
class AppsFlyerService {
  AppsflyerSdk? _sdk;
  bool _initialized = false;
  String _appsFlyerUid = '';

  bool get isConfigured {
    if (FlavorConfig.appsFlyerDevKey.trim().isEmpty) return false;
    if (Platform.isIOS && FlavorConfig.appsFlyerIosAppId.trim().isEmpty) {
      return false;
    }
    return true;
  }

  bool get isInitialized => _initialized;

  /// AppsFlyer install UID for API header `x-appsflyer-id`. Empty until ready.
  String get appsFlyerUid => _appsFlyerUid;

  /// Starts the SDK when Dev Key (and iOS App ID on iOS) are present.
  Future<void> initialize() async {
    if (_initialized) return;

    if (!isConfigured) {
      final missing = <String>[
        if (FlavorConfig.appsFlyerDevKey.trim().isEmpty) 'appsFlyerDevKey',
        if (Platform.isIOS && FlavorConfig.appsFlyerIosAppId.trim().isEmpty)
          'appsFlyerIosAppId',
      ];
      developer.log(
        'AppsFlyer skipped: fill ${missing.join(' + ')} in AppFlavor '
        'when business provides credentials. See APPSFLYER.md.',
        name: 'AppsFlyerService',
      );
      return;
    }

    try {
      final options = AppsFlyerOptions(
        afDevKey: FlavorConfig.appsFlyerDevKey.trim(),
        appId: FlavorConfig.appsFlyerIosAppId.trim(),
        showDebug: FlavorConfig.enableDebugFeatures || kDebugMode,
        timeToWaitForATTUserAuthorization: Platform.isIOS ? 15 : null,
        manualStart: true,
      );

      _sdk = AppsflyerSdk(options);
      await _sdk!.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true,
      );
      _sdk!.startSDK(
        onSuccess: () {
          developer.log('AppsFlyer SDK started', name: 'AppsFlyerService');
          unawaited(_refreshAppsFlyerUid());
        },
        onError: (int code, String message) {
          developer.log(
            'AppsFlyer start error: $code $message',
            name: 'AppsFlyerService',
          );
        },
      );
      _initialized = true;
      await _refreshAppsFlyerUid();
      developer.log('AppsFlyer initialized', name: 'AppsFlyerService');
    } catch (e, st) {
      developer.log(
        'AppsFlyer init failed: $e',
        name: 'AppsFlyerService',
        error: e,
        stackTrace: st,
      );
    }
  }

  Future<void> _refreshAppsFlyerUid() async {
    final sdk = _sdk;
    if (sdk == null) return;
    try {
      final uid = (await sdk.getAppsFlyerUID())?.trim() ?? '';
      if (uid.isEmpty) return;
      _appsFlyerUid = uid;
      developer.log(
        'AppsFlyer UID ready',
        name: 'AppsFlyerService',
      );
    } catch (e, st) {
      developer.log(
        'AppsFlyer getAppsFlyerUID failed: $e',
        name: 'AppsFlyerService',
        error: e,
        stackTrace: st,
      );
    }
  }

  /// Binds the logged-in user for attribution. No-op if SDK not started.
  void setCustomerUserId(String userId) {
    final id = userId.trim();
    if (!_initialized || _sdk == null || id.isEmpty) return;
    _sdk!.setCustomerUserId(id);
    developer.log('AppsFlyer customerUserId set', name: 'AppsFlyerService');
  }

  /// Clears customer user id on logout (empty id).
  void clearCustomerUserId() {
    if (!_initialized || _sdk == null) return;
    _sdk!.setCustomerUserId('');
  }

  /// Logs a custom in-app event. No-op if SDK not started.
  Future<void> logEvent(
    String eventName, [
    Map<String, dynamic>? eventValues,
  ]) async {
    if (!_initialized || _sdk == null) return;
    final name = eventName.trim();
    if (name.isEmpty) return;
    try {
      await _sdk!.logEvent(name, eventValues);
    } catch (e, st) {
      developer.log(
        'AppsFlyer logEvent failed: $e',
        name: 'AppsFlyerService',
        error: e,
        stackTrace: st,
      );
    }
  }
}
