import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../analytics/analytics_event_keys.dart';
import '../di/dependency_injection.dart';
import '../preference/app_pref.dart';
import '../router/app_routes.dart';

abstract final class AuthLoginExtraKeys {
  static const source = 'source';
}

String authLoginSourceFromExtra(Object? extra) {
  if (extra is Map) {
    final value = extra[AuthLoginExtraKeys.source]?.toString().trim() ?? '';
    if (value.isNotEmpty) return value;
  }
  if (extra is String) {
    final value = extra.trim();
    if (value.isNotEmpty) return value;
  }
  return AnalyticsAuthSourceKeys.login;
}

/// Shared login checks and guest redirects.
abstract final class AuthGuard {
  AuthGuard._();

  static AppPref _pref([AppPref? appPref]) => appPref ?? sl<AppPref>();

  /// True when the user has an active login session.
  static bool isLoggedIn([AppPref? appPref]) =>
      _pref(appPref).getLoginStatus();

  static Future<T?> pushLogin<T extends Object?>(
    BuildContext context, {
    String source = AnalyticsAuthSourceKeys.login,
  }) {
    return context.push<T>(
      AppRoutes.path(AppRoutes.authLogin),
      extra: {AuthLoginExtraKeys.source: source},
    );
  }

  /// Returns `true` when logged in.
  ///
  /// When [redirectToLogin] is `true` (default), guests are sent to
  /// [AppRoutes.authLogin] via `push` and this returns `false`.
  /// After successful login, [LoginScreen] pops back to the caller when
  /// possible (all guest-gated services share this path).
  static bool requireLogin(
    BuildContext context, {
    AppPref? appPref,
    bool redirectToLogin = true,
    String loginSource = AnalyticsAuthSourceKeys.login,
  }) {
    if (isLoggedIn(appPref)) return true;
    if (redirectToLogin) {
      pushLogin(context, source: loginSource);
    }
    return false;
  }
}

extension AuthGuardContext on BuildContext {
  bool get isUserLoggedIn => AuthGuard.isLoggedIn();

  bool requireLogin({
    bool redirectToLogin = true,
    String loginSource = AnalyticsAuthSourceKeys.login,
  }) =>
      AuthGuard.requireLogin(
        this,
        redirectToLogin: redirectToLogin,
        loginSource: loginSource,
      );
}
