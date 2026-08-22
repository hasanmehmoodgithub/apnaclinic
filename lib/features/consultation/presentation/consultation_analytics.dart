import 'dart:async';

import '../../../core/analytics/analytics_event_keys.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/preference/app_pref.dart';
import '../../payment/domain/entities/payment_initiation_result.dart';
import '../data/utils/consultation_booking_utils.dart';
import '../domain/entities/consultation_selected_slot_entity.dart';
import 'widgets/results_doctor_item.dart';

class ConsultationRouteExtraKeys {
  ConsultationRouteExtraKeys._();

  static const source = 'source';
}

String? consultancySourceFromExtra(Object? extra) {
  if (extra is! Map) return null;
  final source =
      extra[ConsultationRouteExtraKeys.source]?.toString().trim() ?? '';
  return source.isEmpty ? null : source;
}

String consultancyHubSourceFromExtra(Object? extra) {
  return consultancySourceFromExtra(extra) ??
      AnalyticsConsultancySourceKeys.home;
}

abstract final class ConsultationAnalytics {
  ConsultationAnalytics._();

  static AnalyticsService get _analytics => sl<AnalyticsService>();

  static void logModule(String source) {
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.consultancyModule, {
        AnalyticsParamKeys.source: source,
      }),
    );
  }

  static void logSearchClicked() {
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.consultancySearchClicked),
    );
  }

  static void logCategoryClicked(String categoryName) {
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.doctorCategoryClicked, {
        AnalyticsParamKeys.categoryName: categoryName,
      }),
    );
  }

  static void logListingScreen(String categoryName) {
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.doctorListingScreen, {
        AnalyticsParamKeys.categoryName: categoryName,
      }),
    );
  }

  static void logDoctorSearchClicked() {
    unawaited(_analytics.logEvent(AnalyticsEventKeys.doctorSearchClicked));
  }

  static void logDoctorSearchPerformed(String keyword) {
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.doctorSearchPerformed, {
        AnalyticsParamKeys.keyword: keyword,
      }),
    );
  }

  static void logFilterApplied(String partner) {
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.doctorFilterApplied, {
        AnalyticsParamKeys.partner: partner,
      }),
    );
  }

  static void logProfileClicked(ResultsDoctorItem doctor) {
    unawaited(
      _analytics.logEvent(
        AnalyticsEventKeys.doctorProfileClicked,
        _doctorParams(doctor),
      ),
    );
  }

  static void logProfileScreen(ResultsDoctorItem doctor) {
    unawaited(
      _analytics.logEvent(
        AnalyticsEventKeys.doctorProfileScreen,
        _doctorParams(doctor),
      ),
    );
  }

  static void logDocumentUploaded() {
    unawaited(_analytics.logEvent(AnalyticsEventKeys.doctorDocumentUploaded));
  }

  static void logConsultationConfirm({
    required ResultsDoctorItem doctor,
    required ConsultationSelectedSlotEntity slot,
  }) {
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.doctorConsultationConfirm, {
        ..._doctorParams(doctor),
        AnalyticsParamKeys.timeslot: formatSlotTimeslot(slot),
      }),
    );
  }

  static void logConsultationBooked({
    required ResultsDoctorItem doctor,
    required ConsultationSelectedSlotEntity slot,
    required String paymentMethodCode,
    required String paymentMethodName,
    required String msisdn,
    required String paymentStatus,
    required int discount,
    PaymentInitiationResult? initiation,
  }) {
    final user = sl<AppPref>().getUserLocalModel();
    final userName =
        '${user?.firstName.trim() ?? ''} ${user?.lastName.trim() ?? ''}'.trim();
    final bookingId = initiation?.orderId?.trim() ?? '';
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.doctorConsultationBooked, {
        AnalyticsParamKeys.afContentType: AnalyticsContentTypeKeys.consultancy,
        if (bookingId.isNotEmpty) AnalyticsParamKeys.bookingId: bookingId,
        if (userName.isNotEmpty) AnalyticsParamKeys.userName: userName,
        AnalyticsParamKeys.msisdn: _analyticsMsisdn(msisdn),
        ..._doctorParams(doctor),
        AnalyticsParamKeys.consultationTimeslot: formatSlotTimeslot(slot),
        AnalyticsParamKeys.bookingTimestamp: formatAnalyticsTimestamp(
          DateTime.now(),
        ),
        AnalyticsParamKeys.paymentMethod: _analyticsPaymentMethod(
          paymentMethodCode,
          name: paymentMethodName,
        ),
        AnalyticsParamKeys.paymentStatus: paymentStatus,
        AnalyticsParamKeys.promoApplied: discount > 0
            ? AnalyticsYesNoKeys.yes
            : AnalyticsYesNoKeys.no,
      }),
    );
  }

  static Map<String, Object> _doctorParams(ResultsDoctorItem doctor) {
    final doctorId = doctor.apiDoctorId.trim().isNotEmpty
        ? doctor.apiDoctorId.trim()
        : doctor.id.trim();
    return {
      AnalyticsParamKeys.doctorId: doctorId,
      AnalyticsParamKeys.doctorName: doctor.name,
      AnalyticsParamKeys.category: doctor.specialty,
    };
  }

  static String _analyticsPaymentMethod(String code, {String name = ''}) {
    if (ConsultationBookingUtils.isJazzCashPayment(code, name: name)) {
      return AnalyticsConsultationPaymentMethodKeys.jazzCash;
    }
    return AnalyticsConsultationPaymentMethodKeys.card;
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

String formatAnalyticsTimestamp(DateTime dt) {
  return '${dt.month}/${dt.day}/${dt.year} '
      '${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
}

String formatSlotTimeslot(ConsultationSelectedSlotEntity slot) {
  final parsed = DateTime.tryParse(slot.date.trim());
  final datePart = parsed != null
      ? '${parsed.month}/${parsed.day}/${parsed.year}'
      : slot.date.trim();
  final time = slot.startTime.trim();
  if (datePart.isEmpty) return time;
  if (time.isEmpty) return datePart;
  return '$datePart $time';
}
