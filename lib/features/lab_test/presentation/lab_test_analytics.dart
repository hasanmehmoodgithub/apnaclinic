import 'dart:async';

import '../../../core/analytics/analytics_event_keys.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/services/appsflyer_event_keys.dart';
import '../../../core/services/appsflyer_service.dart';
import '../../consultation/data/utils/consultation_booking_utils.dart';
import '../../consultation/presentation/consultation_analytics.dart';
import '../../payment/domain/entities/payment_initiation_result.dart';
import '../../promo_code/presentation/promo_code_analytics.dart';
import '../domain/entities/lab_test_item_entity.dart';
import '../domain/utils/lab_test_price_formatter.dart';
import 'lab_test_route_args.dart';

class LabTestRouteExtraKeys {
  LabTestRouteExtraKeys._();

  static const source = 'source';
}

String? labSourceFromExtra(Object? extra) {
  if (extra is! Map) return null;
  final source =
      extra[LabTestRouteExtraKeys.source]?.toString().trim() ?? '';
  return source.isEmpty ? null : source;
}

String labHubSourceFromExtra(Object? extra) {
  return labSourceFromExtra(extra) ?? AnalyticsLabSourceKeys.home;
}

abstract final class LabTestAnalytics {
  LabTestAnalytics._();

  static AnalyticsService get _analytics => sl<AnalyticsService>();
  static AppsFlyerService get _appsFlyer => sl<AppsFlyerService>();

  /// Legacy hub open + BRD [AnalyticsEventKeys.labModuleOpened] with [source].
  static void logModule([String source = AnalyticsLabSourceKeys.home]) {
    final resolved = source.trim().isEmpty
        ? AnalyticsLabSourceKeys.home
        : source.trim();
    unawaited(_analytics.logEvent(AnalyticsEventKeys.labModule));
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.labModuleOpened, {
        AnalyticsParamKeys.source: resolved,
      }),
    );
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

  /// BRD [AnalyticsEventKeys.labSelected].
  static void logLabSelected(String labName) {
    final name = labName.trim();
    if (name.isEmpty) return;
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.labSelected, {
        AnalyticsParamKeys.labName: name,
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
    logTestSelected(name);
    unawaited(
      _appsFlyer.logEvent(AppsFlyerEventKeys.contentView, {
        AppsFlyerParamKeys.afContentType: AppsFlyerContentTypeKeys.lab,
      }),
    );
  }

  /// BRD [AnalyticsEventKeys.labTestSelected].
  static void logTestSelected(String testName) {
    final name = testName.trim();
    if (name.isEmpty) return;
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.labTestSelected, {
        AnalyticsParamKeys.testName: name,
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
    final samplingMode = bookingMethodIsHomeSample
        ? AnalyticsLabSamplingModeKeys.homeSample
        : AnalyticsLabSamplingModeKeys.walkIn;
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.labAddToCart, {
        AnalyticsParamKeys.afContentType: AnalyticsContentTypeKeys.lab,
        AnalyticsParamKeys.testName: testName.trim(),
        if (labName.trim().isNotEmpty) AnalyticsParamKeys.labName: labName.trim(),
        if (partnerName.trim().isNotEmpty)
          AnalyticsParamKeys.partnerName: partnerName.trim(),
        if (sampleType.trim().isNotEmpty)
          AnalyticsParamKeys.sampleType: sampleType.trim(),
        AnalyticsParamKeys.samplingMode: samplingMode,
      }),
    );
    unawaited(
      _appsFlyer.logEvent(AppsFlyerEventKeys.addToCart, {
        AppsFlyerParamKeys.afContentType: AppsFlyerContentTypeKeys.lab,
        AppsFlyerParamKeys.testName: testName.trim(),
        AppsFlyerParamKeys.labName: labName.trim(),
        AppsFlyerParamKeys.partnerName: partnerName.trim(),
        AppsFlyerParamKeys.sampleType: sampleType.trim(),
        AppsFlyerParamKeys.samplingMode: samplingMode,
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

  /// BRD [AnalyticsEventKeys.labCheckout].
  static void logCheckout() {
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.labCheckout, {
        AnalyticsParamKeys.afContentType: AnalyticsContentTypeKeys.labCheckout,
      }),
    );
    unawaited(
      _appsFlyer.logEvent(AppsFlyerEventKeys.initiatedCheckout, {
        AppsFlyerParamKeys.afContentType: AppsFlyerContentTypeKeys.labCheckout,
      }),
    );
  }

  static void logPatientDetailsEdit() {
    unawaited(_analytics.logEvent(AnalyticsEventKeys.labPatientDetailsEdit));
  }

  /// Legacy confirm + BRD [AnalyticsEventKeys.labTestBooked].
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
    final partner = _partnerNameFromCheckout(args);
    final promoCode = (appliedPromoCode ?? args.discountCode).trim();
    final promoApplied =
        LabTestPriceFormatter.parseRsAmount(args.discountAmount) > 0 ||
        args.discountPercent > 0 ||
        promoCode.isNotEmpty;
    final paymentMethod = _analyticsPaymentMethod(paymentMethodCode);
    final normalizedMsisdn = _analyticsMsisdn(msisdn);
    final timestamp = formatAnalyticsTimestamp(DateTime.now());

    final testName = args.testTitle.trim().isNotEmpty
        ? args.testTitle.trim()
        : args.lines
              .map((line) => line.testTitle.trim())
              .where((title) => title.isNotEmpty)
              .join(', ');
    final testId = args.testIds.isEmpty
        ? ''
        : args.testIds.map((id) => id.toString()).join(',');
    final totalAmount = LabTestPriceFormatter.parseRsAmount(
      args.totalAmount.trim().isNotEmpty
          ? args.totalAmount
          : args.discountedFee,
    );
    final discount = LabTestPriceFormatter.parseRsAmount(args.discountAmount);
    final transactionId = initiation?.publicId?.trim() ?? '';
    final promoAppliedLabel =
        promoApplied ? AnalyticsYesNoKeys.yes : AnalyticsYesNoKeys.no;

    unawaited(() async {
      final promoParams = await PromoCodeAnalytics.confirmPromoParams(
        promoCode: promoCode,
        promoUsedOverride: promoApplied,
      );
      await _analytics.logEvent(AnalyticsEventKeys.labBookingConfirmed, {
        AnalyticsParamKeys.afContentType: AnalyticsContentTypeKeys.lab,
        if (bookingId.isNotEmpty) AnalyticsParamKeys.bookingId: bookingId,
        if (name.isNotEmpty) AnalyticsParamKeys.userName: name,
        AnalyticsParamKeys.msisdn: normalizedMsisdn,
        AnalyticsParamKeys.numberOfTests: args.testIds.length,
        if (labName.isNotEmpty) AnalyticsParamKeys.labName: labName,
        AnalyticsParamKeys.timestamp: timestamp,
        AnalyticsParamKeys.paymentMethod: paymentMethod,
        AnalyticsParamKeys.paymentStatus: paymentStatus,
        AnalyticsParamKeys.promoApplied: promoAppliedLabel,
        if (promoCode.isNotEmpty) AnalyticsParamKeys.promo: promoCode,
        ...promoParams,
      });

      await _analytics.logEvent(AnalyticsEventKeys.labTestBooked, {
        if (bookingId.isNotEmpty) AnalyticsParamKeys.bookingId: bookingId,
        AnalyticsParamKeys.timestamp: timestamp,
        if (name.isNotEmpty) AnalyticsParamKeys.userName: name,
        AnalyticsParamKeys.msisdn: normalizedMsisdn,
        if (labName.isNotEmpty) AnalyticsParamKeys.labName: labName,
        if (testName.isNotEmpty) AnalyticsParamKeys.testName: testName,
        if (testId.isNotEmpty) AnalyticsParamKeys.testId: testId,
        AnalyticsParamKeys.samplingMode: args.bookingMethodIsHomeSample
            ? AnalyticsLabSamplingModeKeys.homeSample
            : AnalyticsLabSamplingModeKeys.walkIn,
        AnalyticsParamKeys.totalAmount: totalAmount,
        AnalyticsParamKeys.discount: discount,
        AnalyticsParamKeys.paymentMethod: paymentMethod,
        AnalyticsParamKeys.paymentStatus: paymentStatus,
        if (transactionId.isNotEmpty)
          AnalyticsParamKeys.transactionId: transactionId,
        ...promoParams,
      });

      await _appsFlyer.logEvent(AppsFlyerEventKeys.purchase, {
        AppsFlyerParamKeys.contentType: AppsFlyerContentTypeKeys.lab,
        AppsFlyerParamKeys.afContentType: AppsFlyerContentTypeKeys.lab,
        AppsFlyerParamKeys.bookingId: bookingId,
        AppsFlyerParamKeys.userName: name,
        AppsFlyerParamKeys.msisdn: normalizedMsisdn,
        AppsFlyerParamKeys.numberOfTests: args.testIds.length,
        AppsFlyerParamKeys.labName: labName,
        AppsFlyerParamKeys.partner: partner,
        // Street address not on checkout model.
        AppsFlyerParamKeys.address: '',
        AppsFlyerParamKeys.timestamp: timestamp,
        AppsFlyerParamKeys.paymentMethod: paymentMethod,
        AppsFlyerParamKeys.paymentStatus: paymentStatus,
        AppsFlyerParamKeys.transactionId: transactionId,
        AppsFlyerParamKeys.promoApplied: promoAppliedLabel,
        if (promoCode.isNotEmpty) AppsFlyerParamKeys.promo: promoCode,
      });
    }());
  }

  static String _partnerNameFromCheckout(LabTestCheckoutArgs args) {
    for (final line in args.lines) {
      final name = line.partnerName.trim();
      if (name.isNotEmpty) return name;
    }
    return '';
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
