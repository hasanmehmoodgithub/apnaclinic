class PharmacyMedicineModel {
  const PharmacyMedicineModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.companyUrl,
    required this.price,
    required this.oldPrice,
  });

  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String companyUrl;
  final double price;
  final double oldPrice;

  factory PharmacyMedicineModel.fromJson(Map<String, dynamic> json) {
    final media = json['media'];
    final imageFromMedia = media is Map
        ? (media['file'] ?? '').toString()
        : '';
    final manufacturer = json['manufacturer'];
    final manufacturerName = manufacturer is Map
        ? (manufacturer['name'] ?? '').toString()
        : '';

    return PharmacyMedicineModel(
      id: (json['id'] ?? '').toString(),
      name: (json['display_name'] ?? json['name'] ?? '').toString(),
      description: (json['description'] ?? manufacturerName).toString(),
      imageUrl: imageFromMedia.isNotEmpty
          ? imageFromMedia
          : (json['imageUrl'] ?? '').toString(),
      companyUrl: (json['companyUrl'] ?? '').toString(),
      price: _parsePrice(json['price']),
      oldPrice: _parsePrice(json['old_price'] ?? json['oldPrice']),
    );
  }

  factory PharmacyMedicineModel.fromProductDetailJson(
    Map<String, dynamic> json,
  ) {
    final base = PharmacyMedicineModel.fromJson(json);
    final generic = json['generic'];
    final genericName = generic is Map ? (generic['name'] ?? '').toString() : '';
    final dosage = json['dosage'];
    final dosageName = dosage is Map ? (dosage['name'] ?? '').toString() : '';

    final descriptionParts = <String>[
      if (base.description.trim().isNotEmpty) base.description.trim(),
      if (genericName.trim().isNotEmpty) genericName.trim(),
      if (dosageName.trim().isNotEmpty) dosageName.trim(),
    ];

    return PharmacyMedicineModel(
      id: base.id,
      name: base.name,
      description: descriptionParts.join('\n'),
      imageUrl: base.imageUrl,
      companyUrl: base.companyUrl,
      price: base.price,
      oldPrice: base.oldPrice,
    );
  }

  static double _parsePrice(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}

class PharmacyProductsPageModel {
  const PharmacyProductsPageModel({
    required this.success,
    required this.message,
    required this.medicines,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  final bool success;
  final String message;
  final List<PharmacyMedicineModel> medicines;
  final int currentPage;
  final int lastPage;
  final int total;

  factory PharmacyProductsPageModel.fromJson(Map<String, dynamic> json) {
    final nestedData = json['data'];
    final pageData = nestedData is Map<String, dynamic>
        ? nestedData['data']
        : null;
    final payload = pageData is Map<String, dynamic> ? pageData : json;

    final rawList = payload['data'] ?? payload['medicines'] ?? <dynamic>[];
    final medicines = (rawList is List ? rawList : <dynamic>[])
        .whereType<Map>()
        .map((item) => PharmacyMedicineModel.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .toList(growable: false);

    return PharmacyProductsPageModel(
      success: json['success'] == true ||
          (json['code'] is num && (json['code'] as num).toInt() == 200),
      message: (json['message'] ?? '').toString(),
      medicines: medicines,
      currentPage: _parseInt(payload['current_page'], fallback: 1),
      lastPage: _parseInt(payload['last_page'], fallback: 1),
      total: _parseInt(payload['total'], fallback: medicines.length),
    );
  }

  static int _parseInt(dynamic value, {required int fallback}) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}

class PharmacyProductDetailModel {
  const PharmacyProductDetailModel({
    required this.success,
    required this.message,
    required this.product,
    required this.relatedItems,
  });

  final bool success;
  final String message;
  final PharmacyMedicineModel product;
  final List<PharmacyMedicineModel> relatedItems;

  factory PharmacyProductDetailModel.fromJson(Map<String, dynamic> json) {
    final nestedData = json['data'];
    final payload = nestedData is Map<String, dynamic>
        ? nestedData['data']
        : json;
    final productMap = payload is Map<String, dynamic> ? payload : <String, dynamic>{};

    final rawRelated = productMap['related_items'] ?? <dynamic>[];
    final relatedItems = (rawRelated is List ? rawRelated : <dynamic>[])
        .whereType<Map>()
        .map(
          (item) => PharmacyMedicineModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList(growable: false);

    return PharmacyProductDetailModel(
      success: json['success'] == true ||
          (json['code'] is num && (json['code'] as num).toInt() == 200),
      message: (json['message'] ?? '').toString(),
      product: PharmacyMedicineModel.fromProductDetailJson(productMap),
      relatedItems: relatedItems,
    );
  }
}

class PharmacyMedicinesResponseModel {
  const PharmacyMedicinesResponseModel({
    required this.success,
    required this.message,
    required this.medicines,
  });

  final bool success;
  final String message;
  final List<PharmacyMedicineModel> medicines;

  factory PharmacyMedicinesResponseModel.fromProductsPage(
    PharmacyProductsPageModel page,
  ) {
    return PharmacyMedicinesResponseModel(
      success: page.success,
      message: page.message,
      medicines: page.medicines,
    );
  }
}

class PharmacyCartItemModel {
  const PharmacyCartItemModel({required this.medicine, required this.quantity});

  final PharmacyMedicineModel medicine;
  final int quantity;

  factory PharmacyCartItemModel.fromJson(Map<String, dynamic> json) {
    final nestedProduct = json['product'];
    final productJson = nestedProduct is Map
        ? Map<String, dynamic>.from(nestedProduct)
        : Map<String, dynamic>.from(json);

    if (productJson['id'] == null && json['product_id'] != null) {
      productJson['id'] = json['product_id'];
    }

    final pivot = json['pivot'];
    final quantityRaw = json['quantity'] ??
        (pivot is Map ? pivot['quantity'] : null) ??
        json['qty'];

    return PharmacyCartItemModel(
      medicine: PharmacyMedicineModel.fromJson(productJson),
      quantity: _parseQuantity(quantityRaw),
    );
  }

  static int _parseQuantity(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 1;
  }
}

class PharmacyCartResponseModel {
  const PharmacyCartResponseModel({
    required this.success,
    required this.message,
    required this.bookingId,
    required this.items,
    this.hasProductList = false,
    this.paymentBreakdown,
  });

  final bool success;
  final String message;
  final String? bookingId;
  final List<PharmacyCartItemModel> items;
  final bool hasProductList;
  final PharmacyPaymentBreakdownModel? paymentBreakdown;

  factory PharmacyCartResponseModel.fromJson(Map<String, dynamic> json) {
    final payload = _unwrapCartPayload(json);

    final rawList = payload['products'] ??
        payload['items'] ??
        json['cart'] ??
        <dynamic>[];
    final list = (rawList is List ? rawList : <dynamic>[])
        .whereType<Map>()
        .map(
          (item) => PharmacyCartItemModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList(growable: false);

    return PharmacyCartResponseModel(
      success: json['success'] == true ||
          (json['code'] is num && (json['code'] as num).toInt() == 200),
      message: (json['message'] ?? '').toString(),
      bookingId: _resolveBookingId(payload, list.isEmpty ? null : rawList),
      items: list,
      hasProductList: payload.containsKey('products') ||
          payload.containsKey('items') ||
          json.containsKey('cart'),
      paymentBreakdown: PharmacyPaymentBreakdownModel.fromJson(
        payload['payment_breakdown'] ?? payload['paymentBreakdown'],
      ),
    );
  }

  /// Supports both flat `data` and nested aggregator `data.data`.
  static Map<String, dynamic> _unwrapCartPayload(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is! Map) return json;

    final outer = Map<String, dynamic>.from(data);
    final inner = outer['data'];
    if (inner is Map) {
      final nested = Map<String, dynamic>.from(inner);
      if (nested.containsKey('products') ||
          nested.containsKey('booking') ||
          nested.containsKey('booking_id') ||
          nested.containsKey('payment_breakdown')) {
        return nested;
      }
    }
    return outer;
  }

  static String? _resolveBookingId(
    Map<String, dynamic> payload,
    dynamic rawProducts,
  ) {
    final direct = payload['booking_id'] ?? payload['bookingId'];
    if (direct != null &&
        direct.toString().isNotEmpty &&
        direct.toString() != 'null') {
      return direct.toString();
    }

    final booking = payload['booking'];
    if (booking is Map && booking['id'] != null) {
      return booking['id'].toString();
    }

    if (rawProducts is List && rawProducts.isNotEmpty) {
      final first = rawProducts.first;
      if (first is Map && first['booking_id'] != null) {
        return first['booking_id'].toString();
      }
    }

    return null;
  }
}

class PharmacyPaymentBreakdownModel {
  const PharmacyPaymentBreakdownModel({
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

  static PharmacyPaymentBreakdownModel? fromJson(dynamic json) {
    if (json is! Map) return null;
    final map = Map<String, dynamic>.from(json);

    return PharmacyPaymentBreakdownModel(
      deliveryCharges: _parseAmount(
        map['delivery_charges'] ??
            map['deliveryCharges'] ??
            map['delivery_fee'] ??
            map['deliveryFee'] ??
            map['delivery'],
      ),
      discount: _parseAmount(
        map['discount'] ?? map['discount_amount'] ?? map['discountAmount'],
      ),
      total: _parseAmount(
        map['total'] ??
            map['grand_total'] ??
            map['grandTotal'] ??
            map['payable_amount'] ??
            map['payableAmount'] ??
            map['net_total'] ??
            map['netTotal'],
      ),
      subtotal: _parseAmount(
        map['sub_total'] ??
            map['subtotal'] ??
            map['products_total'] ??
            map['product_total'] ??
            map['productsTotal'],
      ),
      discountPercent: _parseOptionalAmount(
        map['discount_percentage'] ??
            map['discount_percent'] ??
            map['discountPercent'] ??
            map['discount_pct'],
      ),
    );
  }

  static double _parseAmount(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    final raw = value.toString().replaceAll(RegExp(r'[^\d.-]'), '');
    return double.tryParse(raw) ?? 0;
  }

  static double? _parseOptionalAmount(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    final raw = value.toString().replaceAll(RegExp(r'[^\d.-]'), '');
    return double.tryParse(raw);
  }
}
