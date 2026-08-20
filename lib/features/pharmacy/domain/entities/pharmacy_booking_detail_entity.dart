class PharmacyBookingTimelineStepEntity {
  const PharmacyBookingTimelineStepEntity({
    required this.label,
    required this.completed,
  });

  final String label;
  final bool completed;
}

class PharmacyBookingLineItemEntity {
  const PharmacyBookingLineItemEntity({
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    required this.imageUrl,
  });

  final String productName;
  final int quantity;
  final double unitPrice;
  final double lineTotal;
  final String imageUrl;

  String get quantityPriceLabel =>
      '${quantity}x Rs ${unitPrice.toStringAsFixed(0)}/-';
}

class PharmacyBookingDetailEntity {
  const PharmacyBookingDetailEntity({
    required this.type,
    required this.orderId,
    required this.orderNo,
    required this.status,
    required this.statusTimeline,
    required this.items,
    required this.subtotal,
    required this.deliveryCharge,
    required this.discount,
    required this.discountPercent,
    required this.total,
    required this.currency,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.city,
    this.invoiceUrl,
    this.messageAlert,
  });

  final String type;
  final String orderId;
  final String orderNo;
  final String status;
  final List<PharmacyBookingTimelineStepEntity> statusTimeline;
  final List<PharmacyBookingLineItemEntity> items;
  final double subtotal;
  final double deliveryCharge;
  final double discount;
  final double discountPercent;
  final double total;
  final String currency;
  final String paymentMethod;
  final String deliveryAddress;
  final String city;
  final String? invoiceUrl;
  final String? messageAlert;

  String get displayOrderNo {
    if (orderNo.isNotEmpty) return orderNo;
    return orderId;
  }

  String get deliveryChargeLabel => deliveryCharge.toStringAsFixed(0);

  String get discountLabel => discount.toStringAsFixed(0);

  bool get hasDiscount => discount > 0;

  String get totalLabel => total.toStringAsFixed(0);

  bool get hasInvoiceUrl {
    final url = invoiceUrl?.trim() ?? '';
    return url.isNotEmpty;
  }

  bool get hasMessageAlert {
    final message = messageAlert?.trim() ?? '';
    return message.isNotEmpty;
  }

  bool get isCancelled {
    final key = status.trim().toUpperCase().replaceAll(RegExp(r'[\s\-]+'), '_');
    return key == 'CANCELLED' ||
        key == 'CANCELED' ||
        key == 'FAILED' ||
        key == 'PAYMENT_FAILED' ||
        key == 'REJECTED';
  }

  bool get isCompleted {
    final key = status.trim().toUpperCase().replaceAll(RegExp(r'[\s\-]+'), '_');
    return key == 'COMPLETED' || key == 'DELIVERED';
  }

  String get paymentMethodLabel {
    switch (paymentMethod.trim().toUpperCase()) {
      case 'JAZZCASH':
        return 'JazzCash';
      case 'COD':
      case 'CASH_ON_DELIVERY':
        return 'Cash on Delivery';
      case 'CARD':
        return 'Card';
      default:
        return paymentMethod.trim().isEmpty ? '—' : paymentMethod.trim();
    }
  }
}
