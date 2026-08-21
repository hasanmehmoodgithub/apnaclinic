class PharmacyPaymentBreakdownEntity {
  const PharmacyPaymentBreakdownEntity({
    required this.deliveryCharges,
    required this.discount,
    required this.total,
    required this.subtotal,
    this.discountPercent,
    this.freeDeliveryMessage,
  });

  final double deliveryCharges;
  final double discount;
  final double total;
  final double subtotal;
  final double? discountPercent;
  final String? freeDeliveryMessage;

  /// Keeps API delivery/discount and recomputes `total = subtotal - discount + delivery`.
  PharmacyPaymentBreakdownEntity withSubtotal(double subtotal) {
    final nextSubtotal = subtotal < 0 ? 0.0 : subtotal;
    return PharmacyPaymentBreakdownEntity(
      deliveryCharges: deliveryCharges,
      discount: discount,
      discountPercent: discountPercent,
      freeDeliveryMessage: freeDeliveryMessage,
      subtotal: nextSubtotal,
      total: (nextSubtotal - discount) + deliveryCharges,
    );
  }
}
