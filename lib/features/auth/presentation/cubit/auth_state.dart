import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/state_status.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default('') String phoneNumber,
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default(30) int otpSecondsRemaining,
    @Default(false) bool otpRequested,
    @Default(StateStatus.idle) StateStatus requestOtpLoadingStateStatus,
    @Default(StateStatus.idle) StateStatus verifyOtpLoadingStateStatus,
  }) = _AuthState;
}

extension AuthStateX on AuthState {
  bool get canResendOtp => otpSecondsRemaining <= 0;
}
