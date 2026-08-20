class PharmacyCheckoutResultEntity {
  const PharmacyCheckoutResultEntity({
    required this.orderNo,
    this.orderId,
    this.unifiedOrderId,
    this.bookingId,
    this.status = 'confirmed',
    this.paymentUrl,
  });

  final String orderNo;
  /// Partner / pharmacy order id used by abandon API (`order_id`).
  final String? orderId;
  /// Aggregator unified order id used by abandon API (`unified_order_id`).
  final int? unifiedOrderId;
  final String? bookingId;
  final String status;
  final String? paymentUrl;

  bool get requiresCardPayment {
    final url = paymentUrl?.trim() ?? '';
    return url.isNotEmpty;
  }

  /// Prefers explicit `order_id`, then display `orderNo`.
  String get abandonOrderId {
    final id = orderId?.trim() ?? '';
    if (id.isNotEmpty) return id;
    return orderNo.trim();
  }
}
