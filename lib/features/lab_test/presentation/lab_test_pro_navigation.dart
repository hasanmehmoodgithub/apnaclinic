import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';

/// After Pro subscribe from lab checkout, return to the test catalog
/// so prices can reload for the new membership.
void popToLabTestSelectTest(BuildContext context) {
  if (!context.mounted) return;
  final router = GoRouter.of(context);
  final matches = router.routerDelegate.currentConfiguration.matches;

  final selectTestInStack = matches.any((match) {
    final route = match.route;
    return route is GoRoute && route.name == AppRoutes.labTestSelectTest;
  });

  if (!selectTestInStack) {
    context.go(AppRoutes.path(AppRoutes.labTest));
    return;
  }

  while (context.canPop()) {
    final currentMatches = router.routerDelegate.currentConfiguration.matches;
    if (currentMatches.isEmpty) return;
    final route = currentMatches.last.route;
    if (route is GoRoute && route.name == AppRoutes.labTestSelectTest) {
      return;
    }
    context.pop();
  }
}
