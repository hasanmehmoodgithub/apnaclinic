import 'dart:async';

import '../../../core/analytics/analytics_event_keys.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../core/analytics/apna_clinic_ai_analytics_event_keys.dart';
import '../../../core/di/dependency_injection.dart';

class ApnaClinicAiRouteExtraKeys {
  ApnaClinicAiRouteExtraKeys._();

  static const source = 'source';
}

String apnaClinicAiSourceFromExtra(Object? extra) {
  if (extra is! Map) return ApnaClinicAiAnalyticsSourceKeys.unknown;
  final value =
      extra[ApnaClinicAiRouteExtraKeys.source]?.toString().trim() ?? '';
  return value.isEmpty ? ApnaClinicAiAnalyticsSourceKeys.unknown : value;
}

abstract final class ApnaClinicAiAnalytics {
  ApnaClinicAiAnalytics._();

  static AnalyticsService get _analytics => sl<AnalyticsService>();

  static void logOpened({
    required String source,
    required bool isGuest,
  }) {
    unawaited(
      _analytics.logEvent(ApnaClinicAiAnalyticsEventKeys.opened, {
        ApnaClinicAiAnalyticsParamKeys.source: source,
        ApnaClinicAiAnalyticsParamKeys.guest: isGuest
            ? AnalyticsYesNoKeys.yes
            : AnalyticsYesNoKeys.no,
      }),
    );
  }

  static void logClosed({
    required String source,
    required bool isGuest,
  }) {
    unawaited(
      _analytics.logEvent(ApnaClinicAiAnalyticsEventKeys.closed, {
        ApnaClinicAiAnalyticsParamKeys.source: source,
        ApnaClinicAiAnalyticsParamKeys.guest: isGuest
            ? AnalyticsYesNoKeys.yes
            : AnalyticsYesNoKeys.no,
      }),
    );
  }

  static void logMessageSent({
    required String channel,
    required bool isGuest,
    String? conversationId,
  }) {
    unawaited(
      _analytics.logEvent(ApnaClinicAiAnalyticsEventKeys.messageSent, {
        ApnaClinicAiAnalyticsParamKeys.channel: channel,
        ApnaClinicAiAnalyticsParamKeys.guest: isGuest
            ? AnalyticsYesNoKeys.yes
            : AnalyticsYesNoKeys.no,
        if ((conversationId ?? '').trim().isNotEmpty)
          ApnaClinicAiAnalyticsParamKeys.conversationId: conversationId!.trim(),
      }),
    );
  }

  static void logMessageReceived({
    required String channel,
    required bool isGuest,
    String? intent,
    String? turnId,
    String? conversationId,
  }) {
    unawaited(
      _analytics.logEvent(ApnaClinicAiAnalyticsEventKeys.messageReceived, {
        ApnaClinicAiAnalyticsParamKeys.channel: channel,
        ApnaClinicAiAnalyticsParamKeys.guest: isGuest
            ? AnalyticsYesNoKeys.yes
            : AnalyticsYesNoKeys.no,
        if ((intent ?? '').trim().isNotEmpty)
          ApnaClinicAiAnalyticsParamKeys.intent: intent!.trim(),
        if ((turnId ?? '').trim().isNotEmpty)
          ApnaClinicAiAnalyticsParamKeys.turnId: turnId!.trim(),
        if ((conversationId ?? '').trim().isNotEmpty)
          ApnaClinicAiAnalyticsParamKeys.conversationId: conversationId!.trim(),
      }),
    );
  }

  static void logVoiceStarted({required bool isGuest}) {
    unawaited(
      _analytics.logEvent(ApnaClinicAiAnalyticsEventKeys.voiceStarted, {
        ApnaClinicAiAnalyticsParamKeys.guest: isGuest
            ? AnalyticsYesNoKeys.yes
            : AnalyticsYesNoKeys.no,
      }),
    );
  }

  static void logVoiceSent({required bool isGuest}) {
    unawaited(
      _analytics.logEvent(ApnaClinicAiAnalyticsEventKeys.voiceSent, {
        ApnaClinicAiAnalyticsParamKeys.guest: isGuest
            ? AnalyticsYesNoKeys.yes
            : AnalyticsYesNoKeys.no,
      }),
    );
  }

  static void logVoiceCancelled({required bool isGuest}) {
    unawaited(
      _analytics.logEvent(ApnaClinicAiAnalyticsEventKeys.voiceCancelled, {
        ApnaClinicAiAnalyticsParamKeys.guest: isGuest
            ? AnalyticsYesNoKeys.yes
            : AnalyticsYesNoKeys.no,
      }),
    );
  }
}
