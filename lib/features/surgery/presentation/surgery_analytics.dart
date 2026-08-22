import 'dart:async';

import '../../../core/analytics/analytics_event_keys.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../core/di/dependency_injection.dart';
import '../../consultation/presentation/consultation_analytics.dart';

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

  static void logModule(String sourceScreen) {
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.surgeryModule, {
        AnalyticsParamKeys.sourceScreen: sourceScreen,
      }),
    );
  }

  static void logCityChange(String selectedCity) {
    final city = selectedCity.trim();
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.surgeryCityChange, {
        if (city.isNotEmpty) AnalyticsParamKeys.selectedCity: city,
      }),
    );
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

  static void logCheckout() {
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.surgeryCheckout, {
        AnalyticsParamKeys.afContentType: AnalyticsContentTypeKeys.surgery,
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
  }) {
    final id = bookingId.trim();
    final name = userName.trim();
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.surgeryBooked, {
        AnalyticsParamKeys.afContentType: AnalyticsContentTypeKeys.surgery,
        if (id.isNotEmpty) AnalyticsParamKeys.bookingId: id,
        if (name.isNotEmpty) AnalyticsParamKeys.userName: name,
        AnalyticsParamKeys.msisdn: _analyticsMsisdn(msisdn),
        AnalyticsParamKeys.surgeryName: surgeryName.trim(),
        AnalyticsParamKeys.doctorName: doctorName.trim(),
        AnalyticsParamKeys.amount: amount,
        AnalyticsParamKeys.timestamp: formatAnalyticsTimestamp(DateTime.now()),
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
