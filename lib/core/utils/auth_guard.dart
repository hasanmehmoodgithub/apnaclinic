import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../di/dependency_injection.dart';
import '../preference/app_pref.dart';
import '../router/app_routes.dart';

/// Shared login checks and guest redirects.
abstract final class AuthGuard {
  AuthGuard._();

  static AppPref _pref([AppPref? appPref]) => appPref ?? sl<AppPref>();

  /// True when the user has an active login session.
  static bool isLoggedIn([AppPref? appPref]) =>
      _pref(appPref).getLoginStatus();

  /// Returns `true` when logged in.
  ///
  /// When [redirectToLogin] is `true` (default), guests are sent to
  /// [AppRoutes.authLogin] and this returns `false`.
  static bool requireLogin(
    BuildContext context, {
    AppPref? appPref,
    bool redirectToLogin = true,
  }) {
    if (isLoggedIn(appPref)) return true;
    if (redirectToLogin) {
      context.push(AppRoutes.path(AppRoutes.authLogin));
    }
    return false;
  }
}

extension AuthGuardContext on BuildContext {
  bool get isUserLoggedIn => AuthGuard.isLoggedIn();

  bool requireLogin({bool redirectToLogin = true}) => AuthGuard.requireLogin(
        this,
        redirectToLogin: redirectToLogin,
      );
}
