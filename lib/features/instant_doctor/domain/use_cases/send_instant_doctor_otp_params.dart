class SendInstantDoctorOtpParams {
  const SendInstantDoctorOtpParams({
    required this.msisdn,
    required this.productId,
    required this.uuid,
  });

  final String msisdn;
  final int productId;
  final String uuid;
}
