class PharmacyBookingItemModel {
  const PharmacyBookingItemModel({
    required this.orderId,
    required this.orderNo,
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
  final String orderNo;
  final String productName;
  final String imageUrl;
  final int quantity;
  final double unitPrice;
  final double total;
  final String currency;
  final String status;
  final String createdAt;

  factory PharmacyBookingItemModel.fromJson(Map<String, dynamic> json) {
    final orderId =
        (json['orderId'] ?? json['order_id'] ?? '').toString().trim();
    final orderNo =
        (json['orderNo'] ?? json['order_no'] ?? '').toString().trim();
    return PharmacyBookingItemModel(
      orderId: orderId.isNotEmpty ? orderId : orderNo,
      orderNo: orderNo.isNotEmpty ? orderNo : orderId,
      productName: (json['productName'] ??
              json['product_name'] ??
              json['title'] ??
              '')
          .toString()
          .trim(),
      imageUrl: (json['imageUrl'] ?? json['image_url'] ?? '').toString().trim(),
      quantity: _asInt(json['quantity']) ?? 1,
      unitPrice: _asDouble(json['unitPrice'] ?? json['unit_price']) ?? 0,
      total: _asDouble(json['total']) ?? 0,
      currency: (json['currency'] ?? 'PKR').toString().trim(),
      status: (json['status'] ?? '').toString().trim(),
      createdAt:
          (json['createdAt'] ?? json['created_at'] ?? '').toString().trim(),
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

class PharmacyBookingsPageModel {
  const PharmacyBookingsPageModel({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
  });

  final List<PharmacyBookingItemModel> items;
  final int page;
  final int limit;
  final int total;

  factory PharmacyBookingsPageModel.fromJson(Map<String, dynamic> json) {
    final root = json['data'];
    Map<String, dynamic> payload;
    if (root is Map) {
      payload = Map<String, dynamic>.from(root);
    } else {
      payload = json;
    }

    // Aggregator: data.data[] ; legacy: bookings[] / data[]
    final listRaw = payload['data'] ??
        payload['bookings'] ??
        payload['items'] ??
        (root is List ? root : null);

    final items = (listRaw is List ? listRaw : const <dynamic>[])
        .whereType<Map>()
        .map(
          (item) => PharmacyBookingItemModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .where((item) => item.orderId.isNotEmpty || item.productName.isNotEmpty)
        .toList(growable: false);

    return PharmacyBookingsPageModel(
      items: items,
      page: PharmacyBookingItemModel._asInt(payload['page']) ?? 1,
      limit: PharmacyBookingItemModel._asInt(payload['limit']) ?? items.length,
      total: PharmacyBookingItemModel._asInt(payload['total']) ?? items.length,
    );
  }
}
