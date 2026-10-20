import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';

/// After Pro subscribe from consultation checkout, return to the doctors list
/// so prices can reload for the new membership.
void popToConsultationDoctors(BuildContext context) {
  if (!context.mounted) return;
  final router = GoRouter.of(context);
  final matches = router.routerDelegate.currentConfiguration.matches;
  final doctorsInStack = matches.any((match) {
    final route = match.route;
    return route is GoRoute && route.name == AppRoutes.consultationDoctors;
  });

  if (!doctorsInStack) {
    context.go(AppRoutes.path(AppRoutes.consultation));
    return;
  }

  while (context.canPop()) {
    final currentMatches =
        router.routerDelegate.currentConfiguration.matches;
    if (currentMatches.isEmpty) return;
    final route = currentMatches.last.route;
    if (route is GoRoute && route.name == AppRoutes.consultationDoctors) {
      return;
    }
    context.pop();
  }
}
