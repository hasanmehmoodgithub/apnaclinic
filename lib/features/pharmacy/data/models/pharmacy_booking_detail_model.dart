class PharmacyBookingTimelineStepModel {
  const PharmacyBookingTimelineStepModel({
    required this.label,
    required this.completed,
  });

  final String label;
  final bool completed;

  factory PharmacyBookingTimelineStepModel.fromJson(Map<String, dynamic> json) {
    return PharmacyBookingTimelineStepModel(
      label: (json['label'] ?? json['name'] ?? '').toString().trim(),
      completed: json['completed'] == true ||
          json['isCompleted'] == true ||
          json['done'] == true,
    );
  }
}

class PharmacyBookingLineItemModel {
  const PharmacyBookingLineItemModel({
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

  factory PharmacyBookingLineItemModel.fromJson(Map<String, dynamic> json) {
    return PharmacyBookingLineItemModel(
      productName: (json['productName'] ??
              json['product_name'] ??
              json['display_name'] ??
              '')
          .toString()
          .trim(),
      quantity: _asInt(json['quantity']) ?? 1,
      unitPrice: _asDouble(json['unitPrice'] ?? json['unit_price']) ?? 0,
      lineTotal: _asDouble(
            json['lineTotal'] ?? json['line_total'] ?? json['total'],
          ) ??
          0,
      imageUrl: (json['imageUrl'] ?? json['image_url'] ?? '').toString().trim(),
    );
  }

  static int? _asInt(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString().trim());
  }

  static double? _asDouble(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().trim());
  }
}

class PharmacyBookingDetailModel {
  const PharmacyBookingDetailModel({
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
  final List<PharmacyBookingTimelineStepModel> statusTimeline;
  final List<PharmacyBookingLineItemModel> items;
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

  factory PharmacyBookingDetailModel.fromJson(Map<String, dynamic> json) {
    final root = json['data'];
    final payload = root is Map
        ? Map<String, dynamic>.from(root)
        : Map<String, dynamic>.from(json);

    final itemsRaw = payload['items'] ?? payload['products'];

    return PharmacyBookingDetailModel(
      type: (payload['type'] ?? 'pharmacy').toString().trim(),
      orderId: _fetchOrderId(payload),
      orderNo: _displayOrderNo(payload),
      status: _readStatus(payload),
      statusTimeline: _readStatusTimeline(payload),
      items: (itemsRaw is List ? itemsRaw : const <dynamic>[])
          .whereType<Map>()
          .map(
            (item) => PharmacyBookingLineItemModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .where((item) => item.productName.isNotEmpty)
          .toList(growable: false),
      subtotal: PharmacyBookingLineItemModel._asDouble(payload['subtotal']) ?? 0,
      deliveryCharge: PharmacyBookingLineItemModel._asDouble(
            payload['deliveryCharge'] ?? payload['delivery_charge'],
          ) ??
          0,
      discount: PharmacyBookingLineItemModel._asDouble(payload['discount']) ?? 0,
      discountPercent: PharmacyBookingLineItemModel._asDouble(
            payload['discountPercent'] ?? payload['discount_percent'],
          ) ??
          0,
      total: PharmacyBookingLineItemModel._asDouble(payload['total']) ?? 0,
      currency: (payload['currency'] ?? 'PKR').toString().trim(),
      paymentMethod:
          (payload['paymentMethod'] ?? payload['payment_method'] ?? '')
              .toString()
              .trim(),
      deliveryAddress:
          (payload['deliveryAddress'] ?? payload['delivery_address'] ?? '')
              .toString()
              .trim(),
      city: (payload['city'] ?? '').toString().trim(),
      invoiceUrl: _nullableString(
        payload['invoiceUrl'] ?? payload['invoice_url'] ?? payload['invoice'],
      ),
      messageAlert: _nullableString(
        payload['messageAlert'] ?? payload['message_alert'],
      ),
    );
  }

  /// Prefer `statusV2` so cancelled / failed / invoice rules match the list.
  static String _readStatus(Map<String, dynamic> payload) {
    for (final key in const ['statusV2', 'status_v2', 'status']) {
      final raw = payload[key];
      if (raw == null) continue;
      final value = raw.toString().trim();
      if (value.isEmpty || value.toLowerCase() == 'null') continue;
      return value;
    }
    return '';
  }

  /// Prefer `statusTimelineV2` (Pending / In Progress / …); fall back to legacy.
  static List<PharmacyBookingTimelineStepModel> _readStatusTimeline(
    Map<String, dynamic> payload,
  ) {
    for (final key in const [
      'statusTimelineV2',
      'status_timeline_v2',
      'statusTimeline',
      'status_timeline',
    ]) {
      final raw = payload[key];
      if (raw is! List || raw.isEmpty) continue;
      final steps = raw
          .whereType<Map>()
          .map(
            (item) => PharmacyBookingTimelineStepModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .where((step) => step.label.isNotEmpty)
          .toList(growable: false);
      if (steps.isNotEmpty) return steps;
    }
    return const [];
  }

  static String? _nullableString(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty || text.toLowerCase() == 'null') return null;
    return text;
  }

  /// GET path id: `publicId` (UUID) when present, else `orderId`.
  static String _fetchOrderId(Map<String, dynamic> payload) {
    final publicId =
        (payload['publicId'] ?? payload['public_id'] ?? '').toString().trim();
    if (publicId.isNotEmpty) return publicId;
    return (payload['orderId'] ?? payload['order_id'] ?? '').toString().trim();
  }

  /// App-bar number: `unified_order_id` first, then `orderNo`. Never a UUID.
  static String _displayOrderNo(Map<String, dynamic> payload) {
    for (final key in const [
      'unifiedOrderId',
      'unified_order_id',
      'orderNo',
      'order_no',
    ]) {
      final raw = payload[key];
      if (raw == null) continue;
      final value = raw.toString().trim();
      if (value.isEmpty || value.toLowerCase() == 'null') continue;
      if (_looksLikeUuid(value)) continue;
      return value;
    }
    final orderId =
        (payload['orderId'] ?? payload['order_id'] ?? '').toString().trim();
    if (orderId.isNotEmpty && !_looksLikeUuid(orderId)) return orderId;
    return '';
  }

  static bool _looksLikeUuid(String value) {
    return RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    ).hasMatch(value);
  }
}
