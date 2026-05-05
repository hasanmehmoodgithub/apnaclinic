import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';

class GetInitialRouteUseCase {
  const GetInitialRouteUseCase(this._appPref);

  final AppPref _appPref;

  String call() {
    final seenOnboarding = _appPref.isOnboardingCompleted();
    return seenOnboarding ? AppRoutes.home : AppRoutes.onboarding;
  }
}
