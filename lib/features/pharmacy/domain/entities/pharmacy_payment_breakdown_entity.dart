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

  /// Keeps API delivery/discount and recomputes `total = subtotal - discount + delivery`.
  PharmacyPaymentBreakdownEntity withSubtotal(double subtotal) {
    final nextSubtotal = subtotal < 0 ? 0.0 : subtotal;
    return PharmacyPaymentBreakdownEntity(
      deliveryCharges: deliveryCharges,
      discount: discount,
      discountPercent: discountPercent,
      subtotal: nextSubtotal,
      total: (nextSubtotal - discount) + deliveryCharges,
    );
  }
}
