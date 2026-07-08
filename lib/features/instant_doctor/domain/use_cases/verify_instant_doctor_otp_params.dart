class VerifyInstantDoctorOtpParams {
  const VerifyInstantDoctorOtpParams({
    required this.msisdn,
    required this.productId,
    required this.otp,
    required this.uuid,
  });

  final String msisdn;
  final int productId;
  final String otp;
  final String uuid;
}
