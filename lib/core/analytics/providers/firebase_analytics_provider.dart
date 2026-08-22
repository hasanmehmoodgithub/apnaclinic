import 'dart:developer' as developer;

import 'package:firebase_analytics/firebase_analytics.dart';

import '../../firebase/firebase_bootstrap.dart';
import '../analytics_service.dart';

/// Firebase backend. No-op until [FirebaseBootstrap] has initialized.
class FirebaseAnalyticsProvider implements AnalyticsService {
  FirebaseAnalytics? _analytics;

  FirebaseAnalytics? get _ready {
    if (!FirebaseBootstrap.isInitialized) return null;
    return _analytics ??= FirebaseAnalytics.instance;
  }

  Future<void> _safe(
    String label,
    Future<void> Function(FirebaseAnalytics analytics) run,
  ) async {
    final analytics = _ready;
    if (analytics == null) return;
    try {
      await run(analytics);
    } catch (e, st) {
      developer.log(
        label,
        name: 'FirebaseAnalyticsProvider',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<void> logEvent(String name, [Map<String, Object>? parameters]) {
    return _safe(
      'logEvent $name',
      (a) => a.logEvent(name: name, parameters: parameters),
    );
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) {
    return _safe(
      'logScreenView $screenName',
      (a) => a.logScreenView(screenName: screenName, screenClass: screenClass),
    );
  }

  @override
  Future<void> setUserId(String? userId) {
    return _safe('setUserId', (a) => a.setUserId(id: userId));
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) {
    return _safe(
      'setUserProperty $name',
      (a) => a.setUserProperty(name: name, value: value),
    );
  }
}
