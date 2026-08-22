import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/analytics/analytics_event_keys.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/session/auth_session_refresh.dart';
import '../../../core/utils/auth_guard.dart';
import '../../instant_doctor/presentation/cubit/instant_doctor_cubit.dart';
import 'constants/main_navigation_tabs.dart';
import 'cubit/main_navigation_cubit.dart';

/// Opens the Instant Doctor bottom tab, gating guests through login.
void openInstantDoctorTab(
  BuildContext context, {
  String sourceScreen = AnalyticsInstantDoctorSourceKeys.banner,
}) {
  openBottomNavTab(
    context,
    MainNavigationTabs.instantDoctor,
    sourceScreen: sourceScreen,
  );
}

/// Opens a shell bottom-nav tab. Instant Doctor and Bookings require login.
void openBottomNavTab(
  BuildContext context,
  int index, {
  String sourceScreen = AnalyticsInstantDoctorSourceKeys.banner,
}) {
  if (index < MainNavigationTabs.home || index > MainNavigationTabs.support) {
    return;
  }

  final needsLogin =
      index == MainNavigationTabs.instantDoctor ||
      index == MainNavigationTabs.bookings;
  final sessionRefresh = sl<AuthSessionRefresh>();

  if (needsLogin && !AuthGuard.isLoggedIn()) {
    sessionRefresh.requestTabIndex(
      index,
      instantDoctorSourceScreen: index == MainNavigationTabs.instantDoctor
          ? sourceScreen
          : null,
    );
    context.requireLogin();
    return;
  }

  if (index == MainNavigationTabs.instantDoctor &&
      context.read<MainNavigationCubit>().state.currentIndex != index) {
    context.read<InstantDoctorCubit>().logModuleViewed(sourceScreen);
  }
  context.read<MainNavigationCubit>().setIndex(index);
}
