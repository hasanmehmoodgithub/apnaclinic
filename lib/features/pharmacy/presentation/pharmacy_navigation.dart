import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/session/auth_session_refresh.dart';
import '../../../core/utils/auth_guard.dart';
import '../../bookings/presentation/constants/bookings_tabs.dart';
import '../../dashboard/presentation/constants/main_navigation_tabs.dart';

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

/// After placing an order: home shell → Bookings tab → Pharmacy sub-tab.
void pharmacyGoToOrderDetailsAfterPlace(
  BuildContext context, {
  Map<String, Object?>? extra,
}) {
  sl<AuthSessionRefresh>().requestTabIndex(
    MainNavigationTabs.bookings,
    bookingsSubTabIndex: BookingsTabs.pharmacy,
  );
  context.goNamed(AppRoutes.home);
}
