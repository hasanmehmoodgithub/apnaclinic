import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

/// GoRouter observer for logging navigation events
/// Logs push, pop, replace, and other navigation actions
/// Shows navigation events in debug console
class GoRouterObserver extends NavigatorObserver {
  final Logger _logger;

  GoRouterObserver()
    : _logger = Logger(
        printer: PrettyPrinter(
          methodCount: 0,
          errorMethodCount: 8,
          lineLength: 120,
          colors: true,
          printEmojis: true,
          dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
        ),
      );

  void _logRouteChange(
    String action,
    String emoji,
    String? from,
    String? to, {
    Map<String, dynamic>? extra,
  }) {
    if (kDebugMode) {
      _logger.d(
        '┌─────────────────────────────────────────────────────────────',
      );
      _logger.d('│ $emoji ROUTER: $action');
      _logger.d(
        '├─────────────────────────────────────────────────────────────',
      );
      if (from != null && from.isNotEmpty) {
        _logger.d('│ From: $from');
      }
      if (to != null && to.isNotEmpty) {
        _logger.d('│ To: $to');
      }
      if (extra != null && extra.isNotEmpty) {
        extra.forEach((key, value) {
          _logger.d('│ $key: $value');
        });
      }
      _logger.d(
        '└─────────────────────────────────────────────────────────────',
      );
    }
  }

  String? _getRouteName(Route<dynamic>? route) {
    if (route == null) return null;
    return route.settings.name ??
        route.settings.arguments?.toString() ??
        route.toString().split('(').first;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logRouteChange(
      'PUSH',
      '🚀',
      _getRouteName(previousRoute),
      _getRouteName(route),
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logRouteChange(
      'POP',
      '⬅️',
      _getRouteName(route),
      _getRouteName(previousRoute),
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _logRouteChange(
      'REMOVE',
      '🗑️',
      _getRouteName(route),
      _getRouteName(previousRoute),
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _logRouteChange(
      'REPLACE',
      '🔄',
      _getRouteName(oldRoute),
      _getRouteName(newRoute),
    );
  }
}
