import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';

class GetInitialRouteUseCase {
  const GetInitialRouteUseCase(this._appPref);

  final AppPref _appPref;

  String call() {
    if (_appPref.getLoginStatus() && !_appPref.isProfileCompleted()) {
      return AppRoutes.profileSetup;
    }
    if (!_appPref.isOnboardingCompleted()) {
      return AppRoutes.onboarding;
    }
    return AppRoutes.home;
  }
}
