class PharmacyPaymentBreakdownEntity {
  const PharmacyPaymentBreakdownEntity({
    required this.deliveryCharges,
    required this.discount,
    required this.total,
    required this.subtotal,
    this.discountPercent,
  });

  final double deliveryCharges;
  final double discount;
  final double total;
  final double subtotal;
  final double? discountPercent;
}
