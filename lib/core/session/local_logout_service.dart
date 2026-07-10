import '../di/dependency_injection.dart';
import '../network/api_service.dart';
import '../preference/app_pref.dart';
import '../preference/app_pref_keys.dart';
import '../services/notification_service.dart';
import 'auth_session_refresh.dart';
import 'profile_session_sync.dart';

/// Clears all local auth/session data. Used after logout (even if API fails).
class LocalLogoutService {
  LocalLogoutService({
    required AppPref appPref,
    required ApiService apiService,
    required AuthSessionRefresh sessionRefresh,
  }) : _appPref = appPref,
       _apiService = apiService,
       _sessionRefresh = sessionRefresh;

  final AppPref _appPref;
  final ApiService _apiService;
  final AuthSessionRefresh _sessionRefresh;

  static LocalLogoutService get instance => LocalLogoutService(
    appPref: sl<AppPref>(),
    apiService: sl<ApiService>(),
    sessionRefresh: sl<AuthSessionRefresh>(),
  );

  Future<void> clearAll({bool notifyShell = true}) async {
    sl<ProfileSessionSync>().invalidate();
    _apiService.removeToken();
    await _appPref.setRefreshToken('');
    await _appPref.setAccessTokenExpiresIn(0);
    await _appPref.setRefreshTokenExpiresIn(0);
    await _appPref.setLoginStatus(false);
    await _appPref.setProfileCompleted(false);
    await _appPref.setToken('');
    await _appPref.setUserId('');
    await _appPref.clearUserLocalModel();
    await _appPref.remove(AppPrefKeys.fcmToken);

    if (sl.isRegistered<NotificationService>()) {
      final pushService = sl<NotificationService>();
      if (pushService.isInitialized) {
        await pushService.deleteToken();
      }
    }

    if (notifyShell) {
      _sessionRefresh.notifyLoggedOut();
    }
  }
}
