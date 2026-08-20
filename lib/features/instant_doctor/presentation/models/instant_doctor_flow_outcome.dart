import '../../domain/enums/instant_doctor_otp_action.dart';

enum InstantDoctorProviderTapOutcome {
  consultationOpened,
  consultationFailed,
  otpFlowStarted,
  otpSendFailed,
}

class InstantDoctorOtpVerifyOutcome {
  const InstantDoctorOtpVerifyOutcome._({
    required this.isSuccess,
    this.action,
    this.redirectUrl,
    this.errorMessage,
  });

  const InstantDoctorOtpVerifyOutcome.success({
    required InstantDoctorOtpAction action,
    String? redirectUrl,
  }) : this._(
          isSuccess: true,
          action: action,
          redirectUrl: redirectUrl,
        );

  const InstantDoctorOtpVerifyOutcome.failure({
    InstantDoctorOtpAction? action,
    String? errorMessage,
  }) : this._(
          isSuccess: false,
          action: action,
          errorMessage: errorMessage,
        );

  final bool isSuccess;
  final InstantDoctorOtpAction? action;
  final String? redirectUrl;
  final String? errorMessage;
}
