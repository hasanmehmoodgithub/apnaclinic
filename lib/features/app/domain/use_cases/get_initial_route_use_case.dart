import '../../../../core/utils/auth_guard.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';

class GetInitialRouteUseCase {
  const GetInitialRouteUseCase(this._appPref);

  final AppPref _appPref;

  String call() {
    if (AuthGuard.isLoggedIn(_appPref) && !_appPref.isProfileCompleted()) {
      return AppRoutes.profileSetup;
    }
    if (!_appPref.isOnboardingCompleted()) {
      return AppRoutes.onboarding;
    }
    return AppRoutes.home;
  }
}
