import 'dart:async';

import '../../../core/analytics/analytics_event_keys.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/preference/app_pref.dart';
import '../../notification/domain/entities/notification_entity.dart';

import 'constants/bookings_tabs.dart';

abstract final class BookingsAnalytics {
  BookingsAnalytics._();

  static AnalyticsService get _analytics => sl<AnalyticsService>();

  static void logMyBookingsTab() {
    unawaited(_analytics.logEvent(AnalyticsEventKeys.myBookingsTab));
  }

  static void logMyBookingInstantDoc() {
    unawaited(_analytics.logEvent(AnalyticsEventKeys.myBookingInstantDoc));
  }

  static void logMyBookingConsultation() {
    unawaited(_analytics.logEvent(AnalyticsEventKeys.myBookingConsultation));
  }

  static void logMyBookingPharmacy() {
    unawaited(_analytics.logEvent(AnalyticsEventKeys.myBookingPharmacy));
  }

  static void logMyBookingLab() {
    unawaited(_analytics.logEvent(AnalyticsEventKeys.myBookingLab));
  }

  static void logMyBookingSurgery() {
    unawaited(_analytics.logEvent(AnalyticsEventKeys.myBookingSurgery));
  }

  static void logBookingTabByIndex(int index) {
    switch (index) {
      case BookingsTabs.instantDoctor:
        logMyBookingInstantDoc();
        break;
      case BookingsTabs.pharmacy:
        logMyBookingPharmacy();
        break;
      case BookingsTabs.doctorConsultation:
        logMyBookingConsultation();
        break;
      case BookingsTabs.labTest:
        logMyBookingLab();
        break;
      case BookingsTabs.surgery:
        logMyBookingSurgery();
        break;
    }
  }

  static void logBookingViewed(String type) {
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.bookingViewed, {
        AnalyticsParamKeys.type: type,
      }),
    );
  }

  static void logPrescriptionAvailable({
    required String bookingId,
    required String service,
  }) {
    final id = bookingId.trim();
    if (id.isEmpty) return;
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.prescriptionAvailable, {
        AnalyticsParamKeys.bookingId: id,
        AnalyticsParamKeys.service: service,
      }),
    );
  }

  static void logPrescriptionDownloaded({
    required String bookingId,
    required String service,
  }) {
    final id = bookingId.trim();
    if (id.isEmpty) return;
    final user = sl<AppPref>().getUserLocalModel();
    final userName =
        '${user?.firstName.trim() ?? ''} ${user?.lastName.trim() ?? ''}'.trim();
    final msisdn = _analyticsMsisdn(user?.phone ?? '');
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.prescriptionDownloaded, {
        AnalyticsParamKeys.bookingId: id,
        AnalyticsParamKeys.service: service,
        if (userName.isNotEmpty) AnalyticsParamKeys.userName: userName,
        if (msisdn.isNotEmpty) AnalyticsParamKeys.msisdn: msisdn,
      }),
    );
  }

  static void logPharmacyStatusChanged({
    required String bookingId,
    required String status,
    String changedBy = '',
  }) {
    final id = bookingId.trim();
    if (id.isEmpty) return;
    final statusLabel = status.trim();
    final actor = changedBy.trim();
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.pharmacyStatusChanged, {
        AnalyticsParamKeys.bookingId: id,
        if (statusLabel.isNotEmpty) AnalyticsParamKeys.status: statusLabel,
        if (actor.isNotEmpty) AnalyticsParamKeys.changedBy: actor,
      }),
    );
  }

  /// Push / inbox events that mean a partner uploaded a prescription or
  /// changed a pharmacy order status.
  static void logFromNotification(NotificationEntity item) {
    final service = item.serviceType.trim().toUpperCase();
    final bookingId = service == 'PHARMACY' && item.entityPublicId.trim().isNotEmpty
        ? item.entityPublicId
        : (item.unifiedOrderId.trim().isNotEmpty
            ? item.unifiedOrderId
            : item.entityId);
    logFromPush(
      type: item.type,
      serviceType: item.serviceType,
      bookingId: bookingId,
    );
  }

  static void logFromFcmData(Map<String, dynamic> data) {
    final serviceType =
        (data['serviceType'] ?? data['service_type'] ?? '').toString();
    final publicId =
        (data['publicId'] ?? data['public_id'] ?? data['entityPublicId'] ?? '')
            .toString()
            .trim();
    final unifiedId = (data['unified_order_id'] ??
            data['booking_id'] ??
            data['bookingId'] ??
            data['entity_id'] ??
            '')
        .toString()
        .trim();
    final isPharmacy = serviceType.trim().toUpperCase() == 'PHARMACY';
    logFromPush(
      type: (data['type'] ?? data['event_type'] ?? '').toString(),
      serviceType: serviceType,
      bookingId: isPharmacy && publicId.isNotEmpty
          ? publicId
          : (unifiedId.isNotEmpty ? unifiedId : publicId),
      status: (data['status'] ?? '').toString(),
      changedBy: (data['changed_by'] ??
              data['changedBy'] ??
              data['partner'] ??
              '')
          .toString(),
    );
  }

  static void logFromPush({
    required String type,
    required String serviceType,
    required String bookingId,
    String status = '',
    String changedBy = '',
  }) {
    final id = bookingId.trim();
    if (id.isEmpty) return;
    final normalizedType = type.trim().toUpperCase();
    final service = _serviceFromNotification(serviceType);

    if (_isPrescriptionType(normalizedType) && service != null) {
      logPrescriptionAvailable(bookingId: id, service: service);
    }

    if (_isPharmacyStatusType(normalizedType, serviceType)) {
      logPharmacyStatusChanged(
        bookingId: id,
        status: status,
        changedBy: changedBy,
      );
    }
  }

  static String? _serviceFromNotification(String serviceType) {
    switch (serviceType.trim().toUpperCase()) {
      case 'CONSULTATION':
        return AnalyticsBookingTypeKeys.consultancy;
      case 'INSTANT_DOCTOR':
      case 'INSTANTDOCTOR':
        return AnalyticsBookingTypeKeys.instantDoctor;
      default:
        return null;
    }
  }

  static bool _isPrescriptionType(String type) {
    return type.contains('PRESCRIPTION');
  }

  static bool _isPharmacyStatusType(String type, String serviceType) {
    if (serviceType.trim().toUpperCase() != 'PHARMACY') return false;
    return type.contains('STATUS') ||
        type.contains('DELIVER') ||
        type.contains('DISPATCH');
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
