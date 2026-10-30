import 'dart:async';

import 'package:image_picker/image_picker.dart';

import '../../../core/analytics/analytics_event_keys.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../core/di/dependency_injection.dart';

abstract final class PharmacyPrescriptionScanAnalytics {
  PharmacyPrescriptionScanAnalytics._();

  static AnalyticsService get _analytics => sl<AnalyticsService>();

  static void logOpened({String source = AnalyticsPharmacySourceKeys.home}) {
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.pharmacyPrescriptionScanOpened, {
        AnalyticsParamKeys.source: source,
      }),
    );
  }

  static void logClosed({String source = AnalyticsPharmacySourceKeys.home}) {
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.pharmacyPrescriptionScanClosed, {
        AnalyticsParamKeys.source: source,
      }),
    );
  }

  static void logSourceSelected(ImageSource source) {
    unawaited(
      _analytics.logEvent(
        AnalyticsEventKeys.pharmacyPrescriptionScanSourceSelected,
        {
          AnalyticsParamKeys.pickSource: source == ImageSource.camera
              ? AnalyticsPrescriptionScanPickSourceKeys.camera
              : AnalyticsPrescriptionScanPickSourceKeys.gallery,
        },
      ),
    );
  }

  static void logPicked(ImageSource source) {
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.pharmacyPrescriptionScanPicked, {
        AnalyticsParamKeys.pickSource: source == ImageSource.camera
            ? AnalyticsPrescriptionScanPickSourceKeys.camera
            : AnalyticsPrescriptionScanPickSourceKeys.gallery,
      }),
    );
  }

  static void logStarted() {
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.pharmacyPrescriptionScanStarted),
    );
  }

  static void logSuccess({required int medicineCount}) {
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.pharmacyPrescriptionScanSuccess, {
        AnalyticsParamKeys.medicineCount: medicineCount,
      }),
    );
  }

  static void logFailed({String? errorCode}) {
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.pharmacyPrescriptionScanFailed, {
        if ((errorCode ?? '').trim().isNotEmpty)
          AnalyticsParamKeys.errorCode: errorCode!.trim(),
      }),
    );
  }

  static void logMedicineAdded({
    required String productId,
    required String productName,
  }) {
    unawaited(
      _analytics.logEvent(
        AnalyticsEventKeys.pharmacyPrescriptionScanMedicineAdded,
        {
          AnalyticsParamKeys.productId: productId,
          AnalyticsParamKeys.productName: productName,
          AnalyticsParamKeys.source: AnalyticsPharmacySourceKeys.home,
        },
      ),
    );
  }
}
