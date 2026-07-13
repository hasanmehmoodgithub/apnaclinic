import 'package:flutter/material.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../auth/domain/use_cases/logout_use_case.dart';
import '../../../../core/session/local_logout_service.dart';
import '../widgets/menu_logout_dialog.dart';

Future<String?> performMenuLogout() async {
  final appPref = sl<AppPref>();
  final userId = appPref.getUserId();

  String? logoutApiError;
  if (userId.isNotEmpty) {
    final result = await sl<LogoutUseCase>().call(
      LogoutParams(
        userId: userId,
        refreshToken: appPref.getRefreshToken(),
      ),
    );
    logoutApiError = result.fold((error) => error, (_) => null);
  }

  await sl<LocalLogoutService>().clearAll();
  return logoutApiError;
}

Future<void> handleMenuLogoutTap(BuildContext context) async {
  final shouldLogout = await showMenuLogoutDialog(context);
  if (!shouldLogout || !context.mounted) return;

  final logoutApiError = await performMenuLogout();
  if (!context.mounted) return;

  if (logoutApiError != null && logoutApiError.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(logoutApiError)),
    );
  }
}
