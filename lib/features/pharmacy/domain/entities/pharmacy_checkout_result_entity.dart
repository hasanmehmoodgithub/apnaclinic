class PharmacyCheckoutResultEntity {
  const PharmacyCheckoutResultEntity({
    required this.orderNo,
    this.bookingId,
    this.status = 'confirmed',
    this.paymentUrl,
  });

  final String orderNo;
  final String? bookingId;
  final String status;
  final String? paymentUrl;

  bool get requiresCardPayment {
    final url = paymentUrl?.trim() ?? '';
    return url.isNotEmpty;
  }
}
