import 'dart:async';

import '../../../core/analytics/analytics_event_keys.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../core/di/dependency_injection.dart';
import '../../consultation/data/utils/consultation_booking_utils.dart';
import '../../consultation/presentation/consultation_analytics.dart';
import '../../payment/domain/entities/payment_initiation_result.dart';
import '../domain/entities/lab_test_item_entity.dart';
import '../domain/utils/lab_test_price_formatter.dart';
import 'lab_test_route_args.dart';

abstract final class LabTestAnalytics {
  LabTestAnalytics._();

  static AnalyticsService get _analytics => sl<AnalyticsService>();

  static void logModule() {
    unawaited(_analytics.logEvent(AnalyticsEventKeys.labModule));
  }

  static void logCityChange(String selectedCity) {
    final city = selectedCity.trim();
    if (city.isEmpty) return;
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.labCityChange, {
        AnalyticsParamKeys.selectedCity: city,
      }),
    );
  }

  static void logSearchClicked() {
    unawaited(_analytics.logEvent(AnalyticsEventKeys.labSearchClicked));
  }

  static void logSearchPerformed({
    required String keyword,
    required int resultItems,
  }) {
    final query = keyword.trim();
    if (query.isEmpty) return;
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.labSearchPerformed, {
        AnalyticsParamKeys.keyword: query,
        AnalyticsParamKeys.resultItems: resultItems,
      }),
    );
  }

  static void logItemSelect({
    required String testName,
    String labName = '',
    String sampleType = '',
  }) {
    final name = testName.trim();
    if (name.isEmpty) return;
    final lab = labName.trim();
    final sample = sampleType.trim();
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.labItemSelect, {
        AnalyticsParamKeys.testName: name,
        if (lab.isNotEmpty) AnalyticsParamKeys.labName: lab,
        if (sample.isNotEmpty) AnalyticsParamKeys.sampleType: sample,
      }),
    );
  }

  static void logItemSelectFromCatalog(LabTestItemEntity item) {
    logItemSelect(
      testName: item.title,
      labName: labNameFromCatalogItem(item),
      sampleType: item.sampleType,
    );
  }

  static void logAddToCart({
    required String testName,
    required String labName,
    required String partnerName,
    required String sampleType,
    required bool bookingMethodIsHomeSample,
  }) {
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.labAddToCart, {
        AnalyticsParamKeys.afContentType: AnalyticsContentTypeKeys.lab,
        AnalyticsParamKeys.testName: testName.trim(),
        if (labName.trim().isNotEmpty) AnalyticsParamKeys.labName: labName.trim(),
        if (partnerName.trim().isNotEmpty)
          AnalyticsParamKeys.partnerName: partnerName.trim(),
        if (sampleType.trim().isNotEmpty)
          AnalyticsParamKeys.sampleType: sampleType.trim(),
        AnalyticsParamKeys.samplingMode: bookingMethodIsHomeSample
            ? AnalyticsLabSamplingModeKeys.homeSample
            : AnalyticsLabSamplingModeKeys.walkIn,
      }),
    );
  }

  static void logCartViewed() {
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.labCartViewed, {
        AnalyticsParamKeys.afContentType: AnalyticsContentTypeKeys.labCart,
      }),
    );
  }

  static void logCheckout() {
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.labCheckout, {
        AnalyticsParamKeys.afContentType: AnalyticsContentTypeKeys.labCheckout,
      }),
    );
  }

  static void logPatientDetailsEdit() {
    unawaited(_analytics.logEvent(AnalyticsEventKeys.labPatientDetailsEdit));
  }

  static void logBookingConfirmed({
    required LabTestCheckoutArgs args,
    required String paymentMethodCode,
    required String userName,
    required String msisdn,
    required String paymentStatus,
    PaymentInitiationResult? initiation,
    String? appliedPromoCode,
  }) {
    final bookingId = initiation?.orderId?.trim() ?? '';
    final name = userName.trim();
    final labName = args.labDisplayName.trim();
    final promoCode = (appliedPromoCode ?? args.discountCode).trim();
    final promoApplied =
        LabTestPriceFormatter.parseRsAmount(args.discountAmount) > 0 ||
        args.discountPercent > 0 ||
        promoCode.isNotEmpty;
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.labBookingConfirmed, {
        AnalyticsParamKeys.afContentType: AnalyticsContentTypeKeys.lab,
        if (bookingId.isNotEmpty) AnalyticsParamKeys.bookingId: bookingId,
        if (name.isNotEmpty) AnalyticsParamKeys.userName: name,
        AnalyticsParamKeys.msisdn: _analyticsMsisdn(msisdn),
        AnalyticsParamKeys.numberOfTests: args.testIds.length,
        if (labName.isNotEmpty) AnalyticsParamKeys.labName: labName,
        AnalyticsParamKeys.timestamp: formatAnalyticsTimestamp(DateTime.now()),
        AnalyticsParamKeys.paymentMethod: _analyticsPaymentMethod(
          paymentMethodCode,
        ),
        AnalyticsParamKeys.paymentStatus: paymentStatus,
        AnalyticsParamKeys.promoApplied: promoApplied
            ? AnalyticsYesNoKeys.yes
            : AnalyticsYesNoKeys.no,
        if (promoCode.isNotEmpty) AnalyticsParamKeys.promo: promoCode,
      }),
    );
  }

  static String labNameFromCatalogItem(LabTestItemEntity item) {
    final summary = item.labsSummary?.trim() ?? '';
    if (summary.isNotEmpty) return summary;
    for (final offer in item.labOffers) {
      final name = offer.labName.trim();
      if (name.isNotEmpty) return name;
    }
    return '';
  }

  static String _analyticsPaymentMethod(String code) {
    if (ConsultationBookingUtils.isJazzCashPayment(code)) {
      return AnalyticsLabPaymentMethodKeys.jazzCash;
    }
    if (ConsultationBookingUtils.isCashPayment(code)) {
      return AnalyticsLabPaymentMethodKeys.cod;
    }
    return AnalyticsLabPaymentMethodKeys.card;
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
