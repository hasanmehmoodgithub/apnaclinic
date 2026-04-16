import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/app_enums.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/preference/app_pref.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/use_cases/request_otp_use_case.dart';
import '../../domain/use_cases/verify_otp_use_case.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required RequestOtpUseCase requestOtpUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required AppPref appPref,
  })  : _requestOtpUseCase = requestOtpUseCase,
        _verifyOtpUseCase = verifyOtpUseCase,
        _appPref = appPref,
        super(const AuthState());

  final RequestOtpUseCase _requestOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final AppPref _appPref;
  Timer? _timer;

  // ---------- UI helpers ----------
  void _safeEmit(AuthState newState) {
    if (isClosed) return;
    emit(newState);
  }

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
    _safeEmit(
      state.copyWith(
        isLoading: true,
        phoneNumber: phoneNumber,
        requestOtpLoadingStateStatus: StateStatus.loading,
        errorMessage: null,
      ),
    );

    final result = await _requestOtpUseCase(
      RequestOtpParams(phoneNumber: phoneNumber),
    );
    if (isClosed) return false;
    return result.fold((error) {
      _safeEmit(
        state.copyWith(
          isLoading: false,
          requestOtpLoadingStateStatus: StateStatus.error,
          errorMessage: error,
        ),
      );
      return false;
    }, (_) {
      _startOtpTimer();
      _safeEmit(_otpRequestedSuccessState());
      return true;
    });
  }

  Future<_VerifyOtpOutcome> verifyOtp(String otp) async {
    _safeEmit(
      state.copyWith(
        isLoading: true,
        verifyOtpLoadingStateStatus: StateStatus.loading,
        errorMessage: null,
      ),
    );

    final result = await _verifyOtpUseCase(
      VerifyOtpParams(
        phoneNumber: state.phoneNumber,
        otp: otp,
      ),
    );
    if (isClosed) return const _VerifyOtpOutcome(isSuccess: false, goToHome: false);
    return result.fold((error) {
      _safeEmit(
        state.copyWith(
          isLoading: false,
          verifyOtpLoadingStateStatus: StateStatus.error,
          errorMessage: error,
        ),
      );
      return const _VerifyOtpOutcome(isSuccess: false, goToHome: false);
    }, (entity) async {
      await _saveUserSession(entity: entity);
      if (isClosed) {
        return const _VerifyOtpOutcome(isSuccess: false, goToHome: false);
      }
      _safeEmit(
        state.copyWith(
          isLoading: false,
          verifyOtpLoadingStateStatus: StateStatus.success,
          errorMessage: null,
        ),
      );
      return _VerifyOtpOutcome(
        isSuccess: true,
        goToHome: entity.isOnboardingCompleted,
      );
    });
  }

  void clearError() {
    if (state.errorMessage == null) return;
    _safeEmit(state.copyWith(errorMessage: null));
  }

  void setPhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty || phoneNumber == state.phoneNumber) return;
    _safeEmit(
      state.copyWith(
        phoneNumber: phoneNumber,
        otpRequested: false,
        errorMessage: null,
      ),
    );
  }

  void hideOtpSection() {
    _timer?.cancel();
    _safeEmit(
      state.copyWith(
        otpRequested: false,
        otpSecondsRemaining: 30,
        errorMessage: null,
      ),
    );
  }

  // ---------- Private helpers ----------
  AuthState _otpRequestedSuccessState() {
    return state.copyWith(
      isLoading: false,
      requestOtpLoadingStateStatus: StateStatus.success,
      otpSecondsRemaining: 30,
      otpRequested: true,
      errorMessage: null,
    );
  }

  Future<void> _saveUserSession({required AuthEntity entity}) async {
    await _appPref.setLoginStatus(true);
    await _appPref.setUserId(entity.userId ?? state.phoneNumber);
    await _appPref.setString('profile_phone', state.phoneNumber);
    await _appPref.setToken(entity.token ?? '');
    await _appPref.setOnboardingCompleted(entity.isOnboardingCompleted == true);

    if (entity.isOnboardingCompleted == true) {
      await _appPref.setProfileCompleted(true);
      await _appPref.setString(
        'profile_first_name',
        entity.firstName ?? '',
      );
      await _appPref.setString(
        'profile_last_name',
        entity.lastName ?? '',
      );
      await _appPref.setString('profile_gender', entity.gender ?? '');
      await _appPref.setString('profile_email', entity.email ?? '');
      await _appPref.setString(
        'profile_address',
        entity.address ?? '',
      );
      await _appPref.setString(
        'profile_dob',
        entity.dateOfBirth ?? '',
      );
    } else {
      await _appPref.setProfileCompleted(false);
    }
  }

  void _startOtpTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final nextValue = state.otpSecondsRemaining - 1;
      if (nextValue <= 0) {
        _safeEmit(state.copyWith(otpSecondsRemaining: 0));
        timer.cancel();
      } else {
        _safeEmit(state.copyWith(otpSecondsRemaining: nextValue));
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

class _VerifyOtpOutcome {
  const _VerifyOtpOutcome({
    required this.isSuccess,
    required this.goToHome,
  });

  final bool isSuccess;
  final bool goToHome;
}
