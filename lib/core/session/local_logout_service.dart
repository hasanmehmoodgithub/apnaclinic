import 'dart:async';

import '../../features/apna_clinic_ai/data/data_sources/apna_clinic_ai_sdk_client.dart';
import '../di/dependency_injection.dart';
import '../firebase/crashlytics_service.dart';
import '../network/api_service.dart';
import '../preference/app_pref.dart';
import '../preference/app_pref_keys.dart';
import '../services/notification_service.dart';
import '../services/appsflyer_service.dart';
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
    unawaited(CrashlyticsService.setUserId(null));
    if (sl.isRegistered<AppsFlyerService>()) {
      sl<AppsFlyerService>().clearCustomerUserId();
    }
    await _appPref.clearUserLocalModel();
    await _appPref.clearApnaClinicAiSession();
    if (sl.isRegistered<ApnaClinicAiSdkClient>()) {
      await sl<ApnaClinicAiSdkClient>().clearSession(clearConversation: true);
    }
    await _appPref.remove(AppPrefKeys.fcmToken);
    await _appPref.remove(AppPrefKeys.fcmTokenSentToBackend);
    if (sl.isRegistered<NotificationService>()) {
      sl<NotificationService>().discardLocalToken();
    }

    if (notifyShell) {
      _sessionRefresh.notifyLoggedOut();
    }

    unawaited(_deleteFcmToken());
  }

  Future<void> _deleteFcmToken() async {
    if (!sl.isRegistered<NotificationService>()) return;
    final pushService = sl<NotificationService>();
    if (!pushService.isInitialized) return;
    await pushService.deleteToken();
  }
}
