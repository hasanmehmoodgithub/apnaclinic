class InstantDoctorVerifyOtpEntity {
  const InstantDoctorVerifyOtpEntity({
    required this.resultCode,
    required this.status,
    required this.transactionId,
    required this.description,
    required this.redirectUrl,
  });

  final String resultCode;
  final String status;
  final String transactionId;
  final String description;
  final String redirectUrl;
}
