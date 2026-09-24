import 'dart:async';

import '../../../core/analytics/analytics_event_keys.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/services/appsflyer_event_keys.dart';
import '../../../core/services/appsflyer_service.dart';
import '../../consultation/presentation/consultation_analytics.dart';
import '../../promo_code/presentation/promo_code_analytics.dart';

class SurgeryRouteExtraKeys {
  SurgeryRouteExtraKeys._();

  static const source = 'source';
}

String? surgerySourceFromExtra(Object? extra) {
  if (extra is! Map) return null;
  final source =
      extra[SurgeryRouteExtraKeys.source]?.toString().trim() ?? '';
  return source.isEmpty ? null : source;
}

String surgeryHubSourceFromExtra(Object? extra) {
  return surgerySourceFromExtra(extra) ?? AnalyticsSurgerySourceKeys.home;
}

abstract final class SurgeryAnalytics {
  SurgeryAnalytics._();

  static AnalyticsService get _analytics => sl<AnalyticsService>();
  static AppsFlyerService get _appsFlyer => sl<AppsFlyerService>();

  static void logModule(String sourceScreen, {String selectedCity = ''}) {
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.surgeryModule, {
        AnalyticsParamKeys.sourceScreen: sourceScreen,
      }),
    );
    _logAppsFlyerModule(
      sourceScreen: sourceScreen,
      selectedCity: selectedCity,
    );
  }

  static void logCityChange(String selectedCity) {
    final city = selectedCity.trim();
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.surgeryCityChange, {
        if (city.isNotEmpty) AnalyticsParamKeys.selectedCity: city,
      }),
    );
    _logAppsFlyerModule(selectedCity: city);
  }

  static void logSearchClicked() {
    unawaited(_analytics.logEvent(AnalyticsEventKeys.surgerySearchClicked));
  }

  static void logSelectItem(String surgeryName) {
    final name = surgeryName.trim();
    if (name.isEmpty) return;
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.surgerySelectItem, {
        AnalyticsParamKeys.surgeryName: name,
      }),
    );
  }

  static void logDoctorSelect({
    required String doctorId,
    required String doctorName,
    required String surgeryName,
  }) {
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.surgeryDoctorSelect, {
        AnalyticsParamKeys.doctorId: doctorId.trim(),
        AnalyticsParamKeys.doctorName: doctorName.trim(),
        AnalyticsParamKeys.surgeryName: surgeryName.trim(),
      }),
    );
  }

  static void logCheckout({
    String surgeryName = '',
    String doctorId = '',
    String doctorName = '',
  }) {
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.surgeryCheckout, {
        AnalyticsParamKeys.afContentType: AnalyticsContentTypeKeys.surgery,
      }),
    );
    unawaited(
      _appsFlyer.logEvent(AppsFlyerEventKeys.initiatedCheckout, {
        AppsFlyerParamKeys.afContentType: AppsFlyerContentTypeKeys.surgery,
        AppsFlyerParamKeys.surgeryName: surgeryName.trim(),
        AppsFlyerParamKeys.doctorId: doctorId.trim(),
        AppsFlyerParamKeys.doctorName: doctorName.trim(),
      }),
    );
  }

  static void logBooked({
    required String bookingId,
    required String userName,
    required String msisdn,
    required String surgeryName,
    required String doctorName,
    required int amount,
    String? promoCode,
  }) {
    final id = bookingId.trim();
    final name = userName.trim();
    final appliedPromo = promoCode?.trim() ?? '';
    final promoApplied = appliedPromo.isNotEmpty
        ? AnalyticsYesNoKeys.yes
        : AnalyticsYesNoKeys.no;
    final timestamp = formatAnalyticsTimestamp(DateTime.now());
    final analyticsMsisdn = _analyticsMsisdn(msisdn);
    final surgery = surgeryName.trim();
    final doctor = doctorName.trim();

    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.surgeryBooked, {
        AnalyticsParamKeys.afContentType: AnalyticsContentTypeKeys.surgery,
        if (id.isNotEmpty) AnalyticsParamKeys.bookingId: id,
        if (name.isNotEmpty) AnalyticsParamKeys.userName: name,
        AnalyticsParamKeys.msisdn: analyticsMsisdn,
        AnalyticsParamKeys.surgeryName: surgery,
        AnalyticsParamKeys.doctorName: doctor,
        AnalyticsParamKeys.amount: amount,
        AnalyticsParamKeys.timestamp: timestamp,
      }),
    );

    unawaited(() async {
      final userType = await PromoCodeAnalytics.resolveUserType();
      await _appsFlyer.logEvent(AppsFlyerEventKeys.purchase, {
        AppsFlyerParamKeys.contentType: AppsFlyerContentTypeKeys.surgery,
        AppsFlyerParamKeys.afContentType: AppsFlyerContentTypeKeys.surgery,
        AppsFlyerParamKeys.bookingId: id,
        AppsFlyerParamKeys.userType: userType,
        AppsFlyerParamKeys.userName: name,
        AppsFlyerParamKeys.msisdn: analyticsMsisdn,
        AppsFlyerParamKeys.surgeryName: surgery,
        AppsFlyerParamKeys.doctorName: doctor,
        AppsFlyerParamKeys.amount: amount,
        AppsFlyerParamKeys.promoApplied: promoApplied,
        if (appliedPromo.isNotEmpty) AppsFlyerParamKeys.promoCode: appliedPromo,
        AppsFlyerParamKeys.timestamp: timestamp,
      });
    }());
  }

  static void _logAppsFlyerModule({
    String sourceScreen = '',
    String selectedCity = '',
  }) {
    unawaited(
      _appsFlyer.logEvent(AppsFlyerEventKeys.surgeryModule, {
        AppsFlyerParamKeys.sourceScreen: sourceScreen,
        AppsFlyerParamKeys.selectedCity: selectedCity,
      }),
    );
  }

  static int amountFromPrice(String price) {
    final digits = price.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return 0;
    return int.tryParse(digits) ?? 0;
  }

  static String _analyticsMsisdn(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('92') && digits.length >= 12) {
      return digits.substring(2);
    }
    if (digits.startsWith('0') && digits.length >= 11) {
      return digits.substring(1);
    }
    return digits;
  }
}
