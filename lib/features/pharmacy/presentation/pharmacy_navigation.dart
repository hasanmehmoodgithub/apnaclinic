import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/utils/auth_guard.dart';

/// Pops when possible; otherwise returns to the app home shell.
void pharmacyPopOrGoHome(BuildContext context) {
  if (context.canPop()) {
    context.pop();
    return;
  }
  context.goNamed(AppRoutes.home);
}

/// Opens cart when logged in; otherwise redirects to login.
void pharmacyOpenCart(BuildContext context) {
  if (!context.requireLogin()) return;
  context.pushNamed(AppRoutes.pharmacyCart);
}

/// After placing an order: home → pharmacy hub → order details (back works at each step).
void pharmacyGoToOrderDetailsAfterPlace(
  BuildContext context, {
  required Map<String, Object?> extra,
}) {
  context.goNamed(AppRoutes.home);
  if (!context.mounted) return;
  context.pushNamed(AppRoutes.pharmacyMain);
  if (!context.mounted) return;
  context.pushNamed(AppRoutes.pharmacyBookingDetails, extra: extra);
}
