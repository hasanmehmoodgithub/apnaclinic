import 'dart:async';

import 'package:flutter/material.dart';

import '../di/dependency_injection.dart';
import 'analytics_service.dart';

/// Logs Firebase screen views on GoRouter navigation (production only).
class AnalyticsRouteObserver extends NavigatorObserver {
  void _track(Route<dynamic>? route) {
    if (route is! PageRoute) return;
    final name = route.settings.name?.trim();
    if (name == null || name.isEmpty) return;
    if (!sl.isRegistered<AnalyticsService>()) return;
    unawaited(
      sl<AnalyticsService>().logScreenView(
        screenName: name,
        screenClass: route.runtimeType.toString(),
      ),
    );
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _track(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _track(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _track(newRoute);
  }
}
