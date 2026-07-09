import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/preference/app_pref.dart';
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
  }) : super(const InstantDoctorState()) {
    loadContent();
  }

  final GetInstantDoctorContentUseCase getContentUseCase;
  final SendInstantDoctorOtpUseCase sendOtpUseCase;
  final VerifyInstantDoctorOtpUseCase verifyOtpUseCase;
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
          errorMessage: AppStrings.instantDoctorPhoneRequiredError,
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

  Future<InstantDoctorProviderTapOutcome> onProviderPrimaryTap(
    InstantDoctorProviderEntity provider,
  ) async {
    if (provider.isSubscribed) {
      return consultationUrl(provider) != null
          ? InstantDoctorProviderTapOutcome.consultationOpened
          : InstantDoctorProviderTapOutcome.consultationFailed;
    }

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
      return const InstantDoctorOtpVerifyOutcome.failure();
    }
    if (otp.trim().length != 4) {
      return const InstantDoctorOtpVerifyOutcome.failure();
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
        return InstantDoctorOtpVerifyOutcome.failure(error);
      },
      (verifyResult) async {
        emit(
          state.copyWith(
            verifyOtpStatus: StateStatus.success,
            otpErrorMessage: null,
          ),
        );
        await loadContent();
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
