import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/analytics/analytics_event_keys.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/utils/auth_guard.dart';

/// Opens lab test cart when logged in; otherwise redirects to login.
Future<void> labTestOpenCart(BuildContext context) async {
  if (!context.requireLogin(loginSource: AnalyticsAuthSourceKeys.lab)) return;
  await context.pushNamed(AppRoutes.labTestCart);
}
