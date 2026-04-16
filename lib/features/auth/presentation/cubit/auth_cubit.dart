import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/app_enums.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/preference/app_pref.dart';
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

    final success = await verifyOtp(otpCode);
    return success ? AuthSubmitResult.verified : AuthSubmitResult.failed;
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

  Future<bool> verifyOtp(String otp) async {
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
    if (isClosed) return false;
    return result.fold((error) {
      _safeEmit(
        state.copyWith(
          isLoading: false,
          verifyOtpLoadingStateStatus: StateStatus.error,
          errorMessage: error,
        ),
      );
      return false;
    }, (entity) async {
      await _saveUserSession(entity.userId, entity.token);
      if (isClosed) return false;
      _safeEmit(
        state.copyWith(
          isLoading: false,
          verifyOtpLoadingStateStatus: StateStatus.success,
          errorMessage: null,
        ),
      );
      return true;
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

  Future<void> _saveUserSession(String? userId, String? token) async {
    await _appPref.setLoginStatus(true);
    await _appPref.setUserId(userId ?? state.phoneNumber);
    await _appPref.setString('profile_phone', state.phoneNumber);
    await _appPref.setToken(token ?? '');
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
