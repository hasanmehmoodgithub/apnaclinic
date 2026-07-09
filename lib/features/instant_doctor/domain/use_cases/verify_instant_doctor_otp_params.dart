import '../enums/instant_doctor_otp_action.dart';

class VerifyInstantDoctorOtpParams {
  const VerifyInstantDoctorOtpParams({
    required this.msisdn,
    required this.productId,
    required this.otp,
    required this.uuid,
    required this.action,
  });

  final String msisdn;
  final int productId;
  final String otp;
  final String uuid;
  final InstantDoctorOtpAction action;
}
