class PharmacyCheckoutResultEntity {
  const PharmacyCheckoutResultEntity({
    required this.orderNo,
    this.bookingId,
    this.status = 'confirmed',
  });

  final String orderNo;
  final String? bookingId;
  final String status;
}
