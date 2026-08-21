class PharmacyCartApiFailure implements Exception {
  const PharmacyCartApiFailure({
    required this.message,
    this.failedPaymentUnifiedOrderId,
  });

  final String message;
  final int? failedPaymentUnifiedOrderId;

  @override
  String toString() => message;
}
