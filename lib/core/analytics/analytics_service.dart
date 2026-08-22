import 'dart:developer' as developer;

/// App-facing analytics API. Cubits and screens depend on this, never on an SDK.
abstract class AnalyticsService {
  Future<void> logEvent(String name, [Map<String, Object>? parameters]);

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  });

  Future<void> setUserId(String? userId);

  Future<void> setUserProperty({
    required String name,
    required String? value,
  });
}

/// Fans events out to every registered backend (Firebase now, others later).
class AnalyticsServiceImpl implements AnalyticsService {
  AnalyticsServiceImpl(this._providers);

  final List<AnalyticsService> _providers;

  Future<void> _fanOut(Future<void> Function(AnalyticsService) action) async {
    for (final provider in _providers) {
      await action(provider);
    }
  }

  @override
  Future<void> logEvent(String name, [Map<String, Object>? parameters]) {
    developer.log(
      'event: $name${parameters == null || parameters.isEmpty ? '' : ', params: $parameters'}',
      name: 'AnalyticsService',
    );
    return _fanOut((p) => p.logEvent(name, parameters));
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) {
    return _fanOut(
      (p) => p.logScreenView(screenName: screenName, screenClass: screenClass),
    );
  }

  @override
  Future<void> setUserId(String? userId) {
    return _fanOut((p) => p.setUserId(userId));
  }

  @override
  Future<void> setUserProperty({required String name, required String? value}) {
    return _fanOut((p) => p.setUserProperty(name: name, value: value));
  }
}
