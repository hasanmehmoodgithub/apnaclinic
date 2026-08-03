class PharmacyBookingEntity {
  const PharmacyBookingEntity({
    required this.orderId,
    required this.productName,
    required this.imageUrl,
    required this.quantity,
    required this.unitPrice,
    required this.total,
    required this.currency,
    required this.status,
    required this.createdAt,
  });

  final String orderId;
  final String productName;
  final String imageUrl;
  final int quantity;
  final double unitPrice;
  final double total;
  final String currency;
  final String status;
  final String createdAt;

  String get quantityPriceLabel =>
      '${quantity}x Rs ${unitPrice.toStringAsFixed(0)}/-';

  String get totalLabel => 'Rs ${total.toStringAsFixed(0)}/-';
}

class PharmacyBookingsPageEntity {
  const PharmacyBookingsPageEntity({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
  });

  final List<PharmacyBookingEntity> items;
  final int page;
  final int limit;
  final int total;
}
