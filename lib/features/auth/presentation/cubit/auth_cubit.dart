import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/app_enums.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/session/auth_session_refresh.dart';
import '../../../../core/preference/user_local_model.dart';
import '../../../../core/utils/jwt_utils.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/use_cases/request_otp_use_case.dart';
import '../../domain/use_cases/verify_otp_use_case.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required RequestOtpUseCase requestOtpUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required AppPref appPref,
    required AuthSessionRefresh sessionRefresh,
  }) : _requestOtpUseCase = requestOtpUseCase,
       _verifyOtpUseCase = verifyOtpUseCase,
       _appPref = appPref,
       _sessionRefresh = sessionRefresh,
       super(const AuthState());

  final RequestOtpUseCase _requestOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final AppPref _appPref;
  final AuthSessionRefresh _sessionRefresh;
  Timer? _timer;

  String formatPhoneInput(String input) {
    var digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('0')) {
      digits = digits.substring(1);
    }
    if (digits.startsWith('92') && digits.length > 10) {
      digits = digits.substring(2);
    }
    return '+92$digits';
  }

  String _normalizeLocalPhone(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('92') && digits.length > 10) {
      return digits.substring(2);
    }
    if (digits.startsWith('0') && digits.length > 10) {
      return digits.substring(1);
    }
    return digits;
  }

  // ---------- UI interactions ----------
  bool onPhoneInputChanged(String value) {
    clearError();
    if (!state.otpRequested) return false;

    final currentDraftPhone = _normalizeLocalPhone(value);
    final requestedPhone = _normalizeLocalPhone(state.phoneNumber);
    if (currentDraftPhone == requestedPhone) return false;

    hideOtpSection();
    return true;
  }

  // ---------- Login flow ----------
  Future<AuthSubmitResult> submitLogin({
    required bool isFormValid,
    required String rawPhoneInput,
    required String otpCode,
  }) async {
    if (!isFormValid) return AuthSubmitResult.validationFailed;
    final phone = formatPhoneInput(rawPhoneInput.trim());

    if (!state.otpRequested) {
      final success = await requestOtp(phone);
      return success ? AuthSubmitResult.otpSent : AuthSubmitResult.failed;
    }

    if (otpCode.length != 4) return AuthSubmitResult.invalidOtp;

    final result = await verifyOtp(otpCode);
    if (!result.isSuccess) return AuthSubmitResult.failed;
    return result.goToHome
        ? AuthSubmitResult.verifiedGoHome
        : AuthSubmitResult.verifiedGoProfileSetup;
  }

  Future<bool> requestOtp(String phoneNumber) async {
    emit(
      state.copyWith(
        isLoading: true,
        phoneNumber: phoneNumber,
        requestOtpLoadingStateStatus: StateStatus.loading,
        errorMessage: null,
      ),
    );

    final result = await _requestOtpUseCase(
      RequestOtpParams(phoneNumber: phoneNumber, channel: 'SMS'),
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(
          state.copyWith(
            isLoading: false,
            requestOtpLoadingStateStatus: StateStatus.error,
            errorMessage: error,
          ),
        );
        return false;
      },
      (entity) {
        _startOtpTimer(expiresInSeconds: entity.expiresInSeconds);
        emit(
          _otpRequestedSuccessState(expiresInSeconds: entity.expiresInSeconds),
        );
        return true;
      },
    );
  }

  Future<VerifyOtpOutcome> verifyOtp(String otp) async {
    emit(
      state.copyWith(
        isLoading: true,
        verifyOtpLoadingStateStatus: StateStatus.loading,
        errorMessage: null,
      ),
    );

    final result = await _verifyOtpUseCase(
      VerifyOtpParams(phoneNumber: state.phoneNumber, otp: otp),
    );
    if (isClosed) {
      return const VerifyOtpOutcome(isSuccess: false, goToHome: false);
    }
    return result.fold(
      (error) {
        emit(
          state.copyWith(
            isLoading: false,
            verifyOtpLoadingStateStatus: StateStatus.error,
            errorMessage: error,
          ),
        );
        return const VerifyOtpOutcome(isSuccess: false, goToHome: false);
      },
      (entity) async {
        await _saveUserSession(entity: entity);
        if (isClosed) {
          return const VerifyOtpOutcome(isSuccess: false, goToHome: false);
        }
        emit(
          state.copyWith(
            isLoading: false,
            verifyOtpLoadingStateStatus: StateStatus.success,
            errorMessage: null,
          ),
        );
        return VerifyOtpOutcome(
          isSuccess: true,
          goToHome: entity.isOnboardingCompleted,
        );
      },
    );
  }

  void clearError() {
    if (state.errorMessage == null) return;
    emit(state.copyWith(errorMessage: null));
  }

  void setPhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty || phoneNumber == state.phoneNumber) return;
    emit(
      state.copyWith(
        phoneNumber: phoneNumber,
        otpRequested: false,
        errorMessage: null,
      ),
    );
  }

  void hideOtpSection() {
    _timer?.cancel();
    emit(
      state.copyWith(
        otpRequested: false,
        otpSecondsRemaining: 30,
        errorMessage: null,
      ),
    );
  }

  // ---------- Private helpers ----------
  AuthState _otpRequestedSuccessState({int? expiresInSeconds}) {
    return state.copyWith(
      isLoading: false,
      requestOtpLoadingStateStatus: StateStatus.success,
      otpSecondsRemaining: _resolveOtpExpirySeconds(expiresInSeconds),
      otpRequested: true,
      errorMessage: null,
    );
  }

  int _resolveOtpExpirySeconds(int? expiresInSeconds) {
    if (expiresInSeconds == null || expiresInSeconds <= 0) return 30;
    return expiresInSeconds;
  }

  Future<void> _saveUserSession({required AuthEntity entity}) async {
    final tokenUserId = JwtUtils.claim<dynamic>(entity.token, 'sub');
    final resolvedUserId =
        entity.userId ??
        (tokenUserId != null ? tokenUserId.toString() : state.phoneNumber);

    await _appPref.setLoginStatus(true);
    await _appPref.setUserId(resolvedUserId);
    await _appPref.setToken(entity.token ?? '');
    await _appPref.setRefreshToken(entity.refreshToken ?? '');
    await _appPref.setAccessTokenExpiresIn(entity.accessTokenExpiresIn ?? 0);
    await _appPref.setRefreshTokenExpiresIn(entity.refreshTokenExpiresIn ?? 0);
    await _appPref.setOnboardingCompleted(entity.isOnboardingCompleted == true);

    if (entity.isOnboardingCompleted == true) {
      await _appPref.setProfileCompleted(true);
      await _appPref.setUserLocalModel(
        UserLocalModel(
          firstName: entity.firstName ?? '',
          lastName: entity.lastName ?? '',
          phone: state.phoneNumber,
          gender: entity.gender ?? '',
          email: entity.email ?? '',
          address: entity.address ?? '',
          dateOfBirth: entity.dateOfBirth ?? '',
        ),
      );
    } else {
      await _appPref.setProfileCompleted(false);
      await _appPref.setUserLocalModel(
        UserLocalModel(phone: state.phoneNumber),
      );
    }

    _sessionRefresh.notifyLoggedIn();
  }

  void _startOtpTimer({int? expiresInSeconds}) {
    final startingSeconds = _resolveOtpExpirySeconds(expiresInSeconds);
    _timer?.cancel();
    emit(state.copyWith(otpSecondsRemaining: startingSeconds));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final nextValue = state.otpSecondsRemaining - 1;
      if (nextValue <= 0) {
        emit(state.copyWith(otpSecondsRemaining: 0));
        timer.cancel();
      } else {
        emit(state.copyWith(otpSecondsRemaining: nextValue));
      }
    });
  }

  // ---------- Lifecycle ----------
  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

class VerifyOtpOutcome {
  const VerifyOtpOutcome({required this.isSuccess, required this.goToHome});

  final bool isSuccess;
  final bool goToHome;
}
