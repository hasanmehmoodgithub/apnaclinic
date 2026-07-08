import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/enums/state_status.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../../../core/utils/phone_format_utils.dart';
import '../../../../core/utils/subscription_uuid_utils.dart';
import '../../domain/entities/instant_doctor_provider_entity.dart';
import '../../domain/use_cases/cancel_instant_doctor_subscription_params.dart';
import '../../domain/use_cases/cancel_instant_doctor_subscription_use_case.dart';
import '../../domain/use_cases/get_instant_doctor_content_params.dart';
import '../../domain/use_cases/get_instant_doctor_content_use_case.dart';
import '../../domain/use_cases/send_instant_doctor_otp_params.dart';
import '../../domain/use_cases/send_instant_doctor_otp_use_case.dart';
import '../../domain/use_cases/verify_instant_doctor_otp_params.dart';
import '../../domain/use_cases/verify_instant_doctor_otp_use_case.dart';
import 'instant_doctor_state.dart';

class InstantDoctorCubit extends Cubit<InstantDoctorState> {
  InstantDoctorCubit({
    required this.getContentUseCase,
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.cancelSubscriptionUseCase,
    required this.appPref,
  }) : super(const InstantDoctorState()) {
    loadContent();
  }

  final GetInstantDoctorContentUseCase getContentUseCase;
  final SendInstantDoctorOtpUseCase sendOtpUseCase;
  final VerifyInstantDoctorOtpUseCase verifyOtpUseCase;
  final CancelInstantDoctorSubscriptionUseCase cancelSubscriptionUseCase;
  final AppPref appPref;
  Timer? _otpTimer;

  @override
  Future<void> close() {
    _otpTimer?.cancel();
    return super.close();
  }

  String? _resolveMsisdn() {
    final phone = appPref.getUserLocalModel()?.phone ?? '';
    final msisdn = PhoneFormatUtils.toMsisdn(phone);
    return msisdn.isEmpty ? null : msisdn;
  }

  Future<void> loadContent() async {
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

    emit(
      state.copyWith(
        loadingStateStatus: StateStatus.loading,
        errorMessage: null,
      ),
    );

    final msisdn = _resolveMsisdn();
    if (msisdn == null) {
      emit(
        state.copyWith(
          loadingStateStatus: StateStatus.error,
          errorMessage: 'Phone number is required for instant doctor.',
        ),
      );
      return;
    }

    final result = await getContentUseCase(
      GetInstantDoctorContentParams(msisdn: msisdn),
    );
    result.fold(
      (error) => emit(
        state.copyWith(
          loadingStateStatus: StateStatus.error,
          errorMessage: error,
        ),
      ),
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

  Future<bool> startSubscription(InstantDoctorProviderEntity provider) async {
    final msisdn = _resolveMsisdn();
    if (msisdn == null) {
      emit(
        state.copyWith(
          otpErrorMessage: 'Phone number is required for instant doctor.',
        ),
      );
      return false;
    }

    final uuid = SubscriptionUuidUtils.generate();
    emit(
      state.copyWith(
        activeOtpProvider: provider,
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
      ),
    );

    return result.fold(
      (error) {
        emit(
          state.copyWith(
            sendOtpStatus: StateStatus.error,
            otpErrorMessage: error,
            activeOtpProvider: null,
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

  Future<bool> resendSubscriptionOtp() async {
    final provider = state.activeOtpProvider;
    final uuid = state.subscriptionUuid;
    final msisdn = _resolveMsisdn();
    if (provider == null || uuid == null || msisdn == null) return false;
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

  Future<bool> verifySubscriptionOtp(String otp) async {
    final provider = state.activeOtpProvider;
    final uuid = state.subscriptionUuid;
    final msisdn = _resolveMsisdn();
    if (provider == null || uuid == null || msisdn == null) return false;
    if (otp.trim().length != 4) {
      return false;
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
      ),
    );

    return result.fold(
      (error) {
        emit(
          state.copyWith(
            verifyOtpStatus: StateStatus.error,
            otpErrorMessage: error,
          ),
        );
        return false;
      },
      (_) {
        emit(
          state.copyWith(
            verifyOtpStatus: StateStatus.success,
            otpErrorMessage: null,
          ),
        );
        return true;
      },
    );
  }

  void clearOtpFlow() {
    _otpTimer?.cancel();
    emit(
      state.copyWith(
        activeOtpProvider: null,
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

  Future<bool> cancelSubscription(InstantDoctorProviderEntity provider) async {
    final msisdn = _resolveMsisdn();
    if (msisdn == null) return false;

    emit(state.copyWith(cancellingProviderId: provider.providerId));
    final result = await cancelSubscriptionUseCase(
      CancelInstantDoctorSubscriptionParams(
        msisdn: msisdn,
        productId: provider.product.productId,
      ),
    );

    emit(state.copyWith(cancellingProviderId: null));
    return result.fold((_) => false, (_) => true);
  }

  Future<bool> openProviderPage(InstantDoctorProviderEntity provider) async {
    final redirectUrl = provider.product.redirectUrl.trim();
    if (redirectUrl.isEmpty) {
      return false;
    }

    emit(state.copyWith(openingProviderId: provider.providerId));
    try {
      final uri = Uri.parse(redirectUrl);
      return await launchUrl(uri, mode: LaunchMode.inAppWebView);
    } catch (_) {
      return false;
    } finally {
      emit(state.copyWith(openingProviderId: null));
    }
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
