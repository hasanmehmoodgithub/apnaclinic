import '../di/dependency_injection.dart';
import '../network/device_headers_provider.dart';
import '../preference/app_pref.dart';
import 'analytics_event_keys.dart';
import 'analytics_service.dart';

/// Logs [AnalyticsEventKeys.firstInstall] once per device install.
class FirstInstallAnalytics {
  FirstInstallAnalytics._();

  static Future<void> logIfFirstTime() async {
    if (!sl.isRegistered<AppPref>() || !sl.isRegistered<AnalyticsService>()) {
      return;
    }

    final appPref = sl<AppPref>();
    if (!appPref.isFirstTime()) return;

    final params = <String, Object>{};
    if (sl.isRegistered<DeviceHeadersProvider>()) {
      try {
        final headers = await sl<DeviceHeadersProvider>().headers();
        final device = headers['x-device-model']?.trim() ?? '';
        final platform = headers['x-device-platform']?.trim() ?? '';
        if (device.isNotEmpty) {
          params[AnalyticsParamKeys.device] = device;
        }
        if (platform.isNotEmpty) {
          params[AnalyticsParamKeys.platform] = platform;
        }
      } catch (_) {}
    }

    await sl<AnalyticsService>().logEvent(
      AnalyticsEventKeys.firstInstall,
      params.isEmpty ? null : params,
    );
    await appPref.setFirstTime(false);
  }
}
