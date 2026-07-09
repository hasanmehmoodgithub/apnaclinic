import '../enums/instant_doctor_otp_action.dart';

class SendInstantDoctorOtpParams {
  const SendInstantDoctorOtpParams({
    required this.msisdn,
    required this.productId,
    required this.uuid,
    required this.action,
  });

  final String msisdn;
  final int productId;
  final String uuid;
  final InstantDoctorOtpAction action;
}
