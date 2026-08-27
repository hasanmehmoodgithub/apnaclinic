import 'package:flutter/material.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/session/local_logout_service.dart';
import '../../../../core/widgets/heart_loader_widget.dart';
import '../../../auth/domain/use_cases/logout_use_case.dart';
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

  const loaderId = 'menu_logout_loader';
  showHeartLoaderDialog(context, id: loaderId, size: 120);
  String? logoutApiError;
  try {
    logoutApiError = await performMenuLogout();
  } finally {
    HeartLoaderDialogController.close(loaderId);
  }
  if (!context.mounted) return;

  if (logoutApiError != null && logoutApiError.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(logoutApiError)),
    );
  }
}
