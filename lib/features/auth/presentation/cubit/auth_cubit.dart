import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository) : super(const AuthState());

  final AuthRepository _authRepository;
  Timer? _timer;

  void setPhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty || phoneNumber == state.phoneNumber) return;
    emit(
      state.copyWith(
        phoneNumber: phoneNumber,
        otpRequested: false,
        clearError: true,
      ),
    );
  }

  Future<bool> requestOtp(String phoneNumber) async {
    emit(
      state.copyWith(
        isLoading: true,
        phoneNumber: phoneNumber,
        clearError: true,
      ),
    );

    final result = await _authRepository.requestOtp(phoneNumber: phoneNumber);

    if (!result.success) {
      emit(state.copyWith(isLoading: false, errorMessage: result.message));
      return false;
    }

    _startOtpTimer();
    emit(
      state.copyWith(
        isLoading: false,
        otpSecondsRemaining: 30,
        otpRequested: true,
        clearError: true,
      ),
    );
    return true;
  }

  Future<bool> verifyOtp(String otp) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await _authRepository.verifyOtp(
      phoneNumber: state.phoneNumber,
      otp: otp,
    );

    if (!result.success) {
      emit(state.copyWith(isLoading: false, errorMessage: result.message));
      return false;
    }

    emit(state.copyWith(isLoading: false, clearError: true));
    return true;
  }

  void clearError() {
    if (state.errorMessage == null) return;
    emit(state.copyWith(clearError: true));
  }

  void hideOtpSection() {
    _timer?.cancel();
    emit(
      state.copyWith(
        otpRequested: false,
        otpSecondsRemaining: 30,
        clearError: true,
      ),
    );
  }

  void _startOtpTimer() {
    _timer?.cancel();
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

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
