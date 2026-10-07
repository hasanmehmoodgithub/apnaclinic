import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/services/appsflyer_event_keys.dart';
import '../../../../core/services/appsflyer_service.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../../../core/utils/phone_format_utils.dart';
import '../../../../core/utils/subscription_uuid_utils.dart';
import '../../domain/entities/instant_doctor_provider_entity.dart';
import '../../domain/enums/instant_doctor_otp_action.dart';
import '../../domain/use_cases/get_instant_doctor_content_params.dart';
import '../../domain/use_cases/get_instant_doctor_content_use_case.dart';
import '../../domain/use_cases/send_instant_doctor_otp_params.dart';
import '../../domain/use_cases/send_instant_doctor_otp_use_case.dart';
import '../../domain/use_cases/verify_instant_doctor_otp_params.dart';
import '../../domain/use_cases/verify_instant_doctor_otp_use_case.dart';
import '../models/instant_doctor_flow_outcome.dart';
import 'instant_doctor_state.dart';

class InstantDoctorCubit extends Cubit<InstantDoctorState> {
  InstantDoctorCubit({
    required this.getContentUseCase,
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.appPref,
    required AnalyticsService analytics,
    required AppsFlyerService appsFlyer,
  }) : _analytics = analytics,
       _appsFlyer = appsFlyer,
       super(const InstantDoctorState()) {
    loadContent();
  }

  final GetInstantDoctorContentUseCase getContentUseCase;
  final SendInstantDoctorOtpUseCase sendOtpUseCase;
  final VerifyInstantDoctorOtpUseCase verifyOtpUseCase;
  final AppPref appPref;
  final AnalyticsService _analytics;
  final AppsFlyerService _appsFlyer;
  Timer? _otpTimer;

  /// Cancels in-flight post-OTP subscription refresh retries.
  int _subscriptionRefreshToken = 0;

  /// Last Instant Doctor entry source for AppsFlyer (`banner` / `bottom_tab`).
  String _appsFlyerSourceScreen = '';

  @override
  Future<void> close() {
    _subscriptionRefreshToken++;
    _otpTimer?.cancel();
    return super.close();
  }

  String? _resolveMsisdn() {
    final phone = appPref.getUserLocalModel()?.phone ?? '';
    final msisdn = PhoneFormatUtils.toMsisdn(phone);
    return msisdn.isEmpty ? null : msisdn;
  }

  Future<void> loadContent({bool refresh = false, bool silent = false}) async {
    if (!AuthGuard.isLoggedIn(appPref)) {
      emit(
        state.copyWith(
          loadingStateStatus: StateStatus.idle,
          providers: const [],
          errorMessage: null,
        ),
      );
      return;
    }

    if (!silent) {
      emit(
        state.copyWith(
          loadingStateStatus:
              refresh ? StateStatus.refreshing : StateStatus.loading,
          errorMessage: null,
        ),
      );
    }

    final msisdn = _resolveMsisdn();
    if (msisdn == null) {
      if (silent) return;
      emit(
        state.copyWith(
          loadingStateStatus: StateStatus.error,
          errorMessage: AppStrings.instantDoctorPhoneRequiredError,
        ),
      );
      return;
    }

    final result = await getContentUseCase(
      GetInstantDoctorContentParams(msisdn: msisdn),
    );
    if (isClosed) return;
    result.fold(
      (error) {
        if (silent) return;
        emit(
          state.copyWith(
            loadingStateStatus: StateStatus.error,
            errorMessage: error,
          ),
        );
      },
      (content) => emit(
        state.copyWith(
          loadingStateStatus: content.providers.isEmpty
              ? StateStatus.empty
              : StateStatus.success,
          providers: content.providers,
          errorMessage: null,
        ),
      ),
    );
  }

  /// Reloads providers once with list shimmer.
  ///
  /// When [delay] is set (unsubscribe), shimmer starts immediately and the
  /// providers request is sent after the delay. Subscribe passes none.
  Future<void> refreshProvidersAfterSubscriptionChange({
    Duration delay = Duration.zero,
  }) async {
    final token = ++_subscriptionRefreshToken;
    if (delay > Duration.zero) {
      emit(
        state.copyWith(
          loadingStateStatus: StateStatus.refreshing,
          errorMessage: null,
        ),
      );
      await Future<void>.delayed(delay);
      if (isClosed || token != _subscriptionRefreshToken) return;
    }
    await loadContent(refresh: true);
  }

  Future<InstantDoctorProviderTapOutcome> onProviderPrimaryTap(
    InstantDoctorProviderEntity provider,
  ) async {
    if (provider.isSubscribed) {
      return consultationUrl(provider) != null
          ? InstantDoctorProviderTapOutcome.consultationOpened
          : InstantDoctorProviderTapOutcome.consultationFailed;
    }

    _logEvent(
      AnalyticsEventKeys.instantDocSubscribeClicked,
      provider,
    );
    final sent = await startSubscription(provider);
    return sent
        ? InstantDoctorProviderTapOutcome.otpFlowStarted
        : InstantDoctorProviderTapOutcome.otpSendFailed;
  }

  Future<InstantDoctorProviderTapOutcome> onCancelSubscriptionConfirmed(
    InstantDoctorProviderEntity provider,
  ) async {
    final sent = await startUnsubscription(provider);
    return sent
        ? InstantDoctorProviderTapOutcome.otpFlowStarted
        : InstantDoctorProviderTapOutcome.otpSendFailed;
  }

  Future<bool> startSubscription(InstantDoctorProviderEntity provider) {
    return _startOtpFlow(provider, InstantDoctorOtpAction.subscribe);
  }

  Future<bool> startUnsubscription(InstantDoctorProviderEntity provider) {
    return _startOtpFlow(provider, InstantDoctorOtpAction.unsubscribe);
  }

  Future<bool> _startOtpFlow(
    InstantDoctorProviderEntity provider,
    InstantDoctorOtpAction action,
  ) async {
    final msisdn = _resolveMsisdn();
    if (msisdn == null) {
      emit(
        state.copyWith(
          otpErrorMessage: AppStrings.instantDoctorPhoneRequiredError,
        ),
      );
      return false;
    }

    final uuid = SubscriptionUuidUtils.generate();
    emit(
      state.copyWith(
        activeOtpProvider: provider,
        otpAction: action,
        subscriptionUuid: uuid,
        sendOtpStatus: StateStatus.loading,
        verifyOtpStatus: StateStatus.idle,
        otpErrorMessage: null,
      ),
    );

    final result = await sendOtpUseCase(
      SendInstantDoctorOtpParams(
        msisdn: msisdn,
        productId: provider.product.productId,
        uuid: uuid,
        action: action,
      ),
    );

    return result.fold(
      (error) {
        emit(
          state.copyWith(
            sendOtpStatus: StateStatus.error,
            otpErrorMessage: error,
            activeOtpProvider: null,
            otpAction: null,
            subscriptionUuid: null,
          ),
        );
        return false;
      },
      (_) {
        emit(
          state.copyWith(
            sendOtpStatus: StateStatus.success,
            otpSecondsRemaining: 30,
            otpErrorMessage: null,
          ),
        );
        _startOtpTimer();
        return true;
      },
    );
  }

  Future<bool> resendOtp() async {
    final provider = state.activeOtpProvider;
    final action = state.otpAction;
    final uuid = state.subscriptionUuid;
    final msisdn = _resolveMsisdn();
    if (provider == null || action == null || uuid == null || msisdn == null) {
      return false;
    }
    if (!state.canResendOtp) return false;

    emit(
      state.copyWith(
        sendOtpStatus: StateStatus.loading,
        otpErrorMessage: null,
      ),
    );

    final result = await sendOtpUseCase(
      SendInstantDoctorOtpParams(
        msisdn: msisdn,
        productId: provider.product.productId,
        uuid: uuid,
        action: action,
      ),
    );

    return result.fold(
      (error) {
        emit(
          state.copyWith(
            sendOtpStatus: StateStatus.error,
            otpErrorMessage: error,
          ),
        );
        return false;
      },
      (_) {
        emit(
          state.copyWith(
            sendOtpStatus: StateStatus.success,
            otpSecondsRemaining: 30,
            otpErrorMessage: null,
          ),
        );
        _startOtpTimer();
        return true;
      },
    );
  }

  Future<InstantDoctorOtpVerifyOutcome> verifyOtp(String otp) async {
    final provider = state.activeOtpProvider;
    final action = state.otpAction;
    final uuid = state.subscriptionUuid;
    final msisdn = _resolveMsisdn();
    if (provider == null || action == null || uuid == null || msisdn == null) {
      return InstantDoctorOtpVerifyOutcome.failure(action: action);
    }
    if (otp.trim().length != 4) {
      return InstantDoctorOtpVerifyOutcome.failure(action: action);
    }

    emit(
      state.copyWith(
        verifyOtpStatus: StateStatus.loading,
        otpErrorMessage: null,
      ),
    );

    final result = await verifyOtpUseCase(
      VerifyInstantDoctorOtpParams(
        msisdn: msisdn,
        productId: provider.product.productId,
        otp: otp.trim(),
        uuid: uuid,
        action: action,
      ),
    );

    return await result.fold(
      (error) async {
        emit(
          state.copyWith(
            verifyOtpStatus: StateStatus.error,
            otpErrorMessage: error,
          ),
        );
        return InstantDoctorOtpVerifyOutcome.failure(
          action: action,
          errorMessage: error,
        );
      },
      (verifyResult) async {
        emit(
          state.copyWith(
            verifyOtpStatus: StateStatus.success,
            otpErrorMessage: null,
          ),
        );
        if (action == InstantDoctorOtpAction.subscribe) {
          _logEvent(
            AnalyticsEventKeys.fbMobileSubscribe,
            provider,
            includeMsisdn: true,
          );
          _logAppsFlyerPurchase(provider);
        }
        final redirectUrl = verifyResult.redirectUrl.trim();
        return InstantDoctorOtpVerifyOutcome.success(
          action: action,
          redirectUrl: redirectUrl.isEmpty ? null : redirectUrl,
        );
      },
    );
  }

  void clearOtpFlow() {
    _otpTimer?.cancel();
    emit(
      state.copyWith(
        activeOtpProvider: null,
        otpAction: null,
        subscriptionUuid: null,
        sendOtpStatus: StateStatus.idle,
        verifyOtpStatus: StateStatus.idle,
        otpSecondsRemaining: 30,
        otpErrorMessage: null,
      ),
    );
  }

  void clearOtpError() {
    if (state.otpErrorMessage == null) return;
    emit(state.copyWith(otpErrorMessage: null));
  }

  String? consultationUrl(InstantDoctorProviderEntity provider) {
    final redirectUrl = provider.product.redirectUrl.trim();
    if (redirectUrl.isEmpty) return null;
    return redirectUrl;
  }

  void logStartConsultation(InstantDoctorProviderEntity provider) {
    _logEvent(
      AnalyticsEventKeys.startConsultationClicked,
      provider,
      includeMsisdn: true,
    );
  }

  void logModuleViewed(String sourceScreen) {
    final clickedSource =
        sourceScreen == AnalyticsInstantDoctorSourceKeys.bottomTab
            ? AnalyticsInstantDoctorSourceKeys.navigationTab
            : sourceScreen;
    unawaited(
      _analytics.logEvent(
        AnalyticsEventKeys.instantDoctorClicked,
        {AnalyticsParamKeys.source: clickedSource},
      ),
    );
    final legacySource = _legacySourceScreen(sourceScreen);
    _appsFlyerSourceScreen = legacySource;
    unawaited(
      _analytics.logEvent(
        AnalyticsEventKeys.instantDoctorModule,
        {AnalyticsParamKeys.sourceScreen: legacySource},
      ),
    );
    // Partner unknown at tab open; empty until purchase selects a provider.
    unawaited(
      _appsFlyer.logEvent(AppsFlyerEventKeys.instantDoctorModule, {
        AppsFlyerParamKeys.sourceScreen: legacySource,
        AppsFlyerParamKeys.partner: '',
      }),
    );
  }

  void _logAppsFlyerPurchase(InstantDoctorProviderEntity provider) {
    unawaited(
      _appsFlyer.logEvent(AppsFlyerEventKeys.purchase, {
        AppsFlyerParamKeys.sourceScreen: _appsFlyerSourceScreen,
        AppsFlyerParamKeys.partner: provider.providerName,
      }),
    );
  }

  String _legacySourceScreen(String sourceScreen) {
    if (sourceScreen == AnalyticsInstantDoctorSourceKeys.popup) {
      return AnalyticsInstantDoctorSourceKeys.banner;
    }
    if (sourceScreen == AnalyticsInstantDoctorSourceKeys.navigationTab) {
      return AnalyticsInstantDoctorSourceKeys.bottomTab;
    }
    return sourceScreen;
  }

  void _logEvent(
    String name,
    InstantDoctorProviderEntity provider, {
    bool includeMsisdn = false,
  }) {
    unawaited(
      _analytics.logEvent(name, {
        AnalyticsParamKeys.partner: provider.providerName,
        if (includeMsisdn) AnalyticsParamKeys.msisdn: _analyticsMsisdn(),
      }),
    );
  }

  String _analyticsMsisdn() {
    final msisdn = _resolveMsisdn() ?? '';
    if (msisdn.startsWith('92') && msisdn.length >= 12) {
      return msisdn.substring(2);
    }
    return msisdn;
  }

  void setOpeningProvider(int providerId) {
    emit(state.copyWith(openingProviderId: providerId));
  }

  void clearOpeningProvider() {
    if (state.openingProviderId == null) return;
    emit(state.copyWith(openingProviderId: null));
  }

  void _startOtpTimer() {
    _otpTimer?.cancel();
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }
      final remaining = state.otpSecondsRemaining;
      if (remaining <= 0) {
        timer.cancel();
        return;
      }
      emit(state.copyWith(otpSecondsRemaining: remaining - 1));
    });
  }
}
