import 'dart:async';

import '../../../core/analytics/analytics_event_keys.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../core/di/dependency_injection.dart';
import '../domain/entities/promo_code_service.dart';
import '../domain/entities/promo_code_validation_entity.dart';

abstract final class PromoCodeAnalytics {
  PromoCodeAnalytics._();

  static AnalyticsService get _analytics => sl<AnalyticsService>();

  static void logEntered({
    required String code,
    required PromoCodeService service,
  }) {
    final trimmed = code.trim();
    if (trimmed.isEmpty) return;
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.promoCodeEntered, {
        AnalyticsParamKeys.code: trimmed,
        AnalyticsParamKeys.service: service.apiValue,
      }),
    );
  }

  static void logApplied({
    required PromoCodeValidationEntity result,
    required PromoCodeService service,
  }) {
    unawaited(() async {
      final userType = await resolveUserType();
      await _analytics.logEvent(AnalyticsEventKeys.promoCodeApplied, {
        AnalyticsParamKeys.code: result.code.trim(),
        AnalyticsParamKeys.service: service.apiValue,
        AnalyticsParamKeys.discountType: result.discountType.trim().isEmpty
            ? 'UNKNOWN'
            : result.discountType.trim(),
        AnalyticsParamKeys.discountValue: result.discountValue,
        AnalyticsParamKeys.userType: userType,
      });
    }());
  }

  static void logRejected({
    required String code,
    required PromoCodeService service,
    required String reason,
  }) {
    final trimmed = code.trim();
    if (trimmed.isEmpty) return;
    unawaited(
      _analytics.logEvent(AnalyticsEventKeys.promoCodeRejected, {
        AnalyticsParamKeys.code: trimmed,
        AnalyticsParamKeys.service: service.apiValue,
        AnalyticsParamKeys.reason: reason,
      }),
    );
  }

  /// Maps API / exception text to BRD reject reasons.
  static String reasonFromMessage(String? message) {
    final m = (message ?? '').trim().toLowerCase();
    if (m.isEmpty) return AnalyticsPromoRejectReasonKeys.invalidCode;

    if (m.contains('expir')) {
      return AnalyticsPromoRejectReasonKeys.expired;
    }
    if (m.contains('not_started') ||
        m.contains('not started') ||
        m.contains('has not started') ||
        m.contains('before start') ||
        m.contains('upcoming')) {
      return AnalyticsPromoRejectReasonKeys.notStarted;
    }
    if (m.contains('ineligible_service') ||
        m.contains('service not') ||
        m.contains('not valid for') ||
        m.contains('wrong service') ||
        m.contains('invalid service')) {
      return AnalyticsPromoRejectReasonKeys.ineligibleService;
    }
    if (m.contains('ineligible_user') ||
        m.contains('user type') ||
        m.contains('not eligible') ||
        m.contains('pro only') ||
        m.contains('members only') ||
        m.contains('ineligible')) {
      return AnalyticsPromoRejectReasonKeys.ineligibleUserType;
    }
    return AnalyticsPromoRejectReasonKeys.invalidCode;
  }

  /// Always `free` until Pro membership should be reported again.
  static Future<String> resolveUserType() async {
    return AnalyticsUserTypeKeys.free;
  }

  /// Shared confirm-event promo params (`promo_code_used`, `promo_code`, `user_type`).
  static Future<Map<String, Object>> confirmPromoParams({
    required String? promoCode,
    bool? promoUsedOverride,
  }) async {
    final code = promoCode?.trim() ?? '';
    final used = promoUsedOverride ?? code.isNotEmpty;
    final userType = await resolveUserType();
    return {
      AnalyticsParamKeys.promoCodeUsed: used
          ? AnalyticsYesNoKeys.yes
          : AnalyticsYesNoKeys.no,
      if (code.isNotEmpty) AnalyticsParamKeys.promoCode: code,
      AnalyticsParamKeys.userType: userType,
    };
  }
}
