import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  const AuthState({
    this.phoneNumber = '',
    this.isLoading = false,
    this.errorMessage,
    this.otpSecondsRemaining = 30,
    this.otpRequested = false,
  });

  final String phoneNumber;
  final bool isLoading;
  final String? errorMessage;
  final int otpSecondsRemaining;
  final bool otpRequested;

  bool get canResendOtp => otpSecondsRemaining <= 0;

  AuthState copyWith({
    String? phoneNumber,
    bool? isLoading,
    String? errorMessage,
    int? otpSecondsRemaining,
    bool? otpRequested,
    bool clearError = false,
  }) {
    return AuthState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      otpSecondsRemaining: otpSecondsRemaining ?? this.otpSecondsRemaining,
      otpRequested: otpRequested ?? this.otpRequested,
    );
  }

  @override
  List<Object?> get props => [
    phoneNumber,
    isLoading,
    errorMessage,
    otpSecondsRemaining,
    otpRequested,
  ];
}
