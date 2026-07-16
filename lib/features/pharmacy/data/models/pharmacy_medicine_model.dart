String _asString(dynamic value, {String fallback = ''}) {
  if (value == null) return fallback;
  final text = value.toString().trim();
  if (text.toLowerCase() == 'null') return fallback;
  return text;
}

bool _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  final normalized = value?.toString().trim().toLowerCase();
  return normalized == 'true' || normalized == '1' || normalized == 'yes';
}

double _parsePrice(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}

int _parseInt(dynamic value, {required int fallback}) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

List<String> _parseStringList(dynamic value) {
  if (value is! List) return const [];
  return value.map((item) => item.toString()).toList(growable: false);
}

class PharmacyMedicineModel {
  const PharmacyMedicineModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.companyUrl,
    required this.price,
    required this.oldPrice,
    required this.manufacturer,
    required this.category,
    required this.prescriptionRequired,
    required this.genericName,
    required this.packageType,
    required this.indications,
    required this.contraIndications,
    required this.images,
  });

  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String companyUrl;
  final double price;
  final double oldPrice;
  final String manufacturer;
  final String category;
  final bool prescriptionRequired;
  final String genericName;
  final String packageType;
  final String indications;
  final String contraIndications;
  final List<String> images;

  factory PharmacyMedicineModel.fromJson(Map<String, dynamic> json) {
    final media = json['media'];
    final imageFromMedia = media is Map
        ? _asString(media['file'] ?? media['url'])
        : '';

    final manufacturerRaw = json['manufacturer'];
    final manufacturerName = manufacturerRaw is Map
        ? _asString(manufacturerRaw['name'])
        : _asString(manufacturerRaw);

    final genericRaw = json['generic'];
    final genericFromField = _asString(json['generic_name'] ?? json['genericName']);
    final genericName = genericFromField.isNotEmpty
        ? genericFromField
        : (genericRaw is Map ? _asString(genericRaw['name']) : '');

    final images = _parseStringList(json['images']);
    final imageUrl = _resolveImageUrl(
      imageFromMedia: imageFromMedia,
      imageUrl: _asString(json['image_url'] ?? json['imageUrl']),
      images: images,
    );

    final indications = _asString(json['indications']);
    final contraIndications = _asString(
      json['contra_indications'] ?? json['contraIndications'],
    );

    final description = _buildDescription(
      description: _asString(json['description']),
      manufacturerName: manufacturerName,
      genericName: genericName,
      indications: indications,
      contraIndications: contraIndications,
    );

    return PharmacyMedicineModel(
      id: _asString(json['product_id'] ?? json['productId'] ?? json['id']),
      name: _asString(json['display_name'] ?? json['name']),
      description: description,
      imageUrl: imageUrl,
      companyUrl: _asString(json['companyUrl'] ?? json['company_url']),
      price: _parsePrice(json['price']),
      oldPrice: _parsePrice(json['old_price'] ?? json['oldPrice']),
      manufacturer: manufacturerName,
      category: _asString(json['category']),
      prescriptionRequired: _asBool(
        json['prescription_required'] ?? json['prescriptionRequired'],
      ),
      genericName: genericName,
      packageType: _asString(json['package_type'] ?? json['packageType']),
      indications: indications,
      contraIndications: contraIndications,
      images: images,
    );
  }

  factory PharmacyMedicineModel.fromProductDetailJson(
    Map<String, dynamic> json,
  ) {
    final base = PharmacyMedicineModel.fromJson(json);
    final dosage = json['dosage'];
    final dosageName = dosage is Map ? _asString(dosage['name']) : '';

    final descriptionParts = <String>[
      if (base.description.trim().isNotEmpty) base.description.trim(),
      if (base.genericName.trim().isNotEmpty && !base.description.contains(base.genericName))
        base.genericName.trim(),
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
      manufacturer: base.manufacturer,
      category: base.category,
      prescriptionRequired: base.prescriptionRequired,
      genericName: base.genericName,
      packageType: base.packageType,
      indications: base.indications,
      contraIndications: base.contraIndications,
      images: base.images,
    );
  }

  static String _resolveImageUrl({
    required String imageFromMedia,
    required String imageUrl,
    required List<String> images,
  }) {
    if (imageFromMedia.isNotEmpty) return imageFromMedia;
    if (imageUrl.isNotEmpty) return imageUrl;
    if (images.isNotEmpty) return images.first;
    return '';
  }

  static String _buildDescription({
    required String description,
    required String manufacturerName,
    required String genericName,
    required String indications,
    required String contraIndications,
  }) {
    if (description.trim().isNotEmpty) return description.trim();

    final parts = <String>[
      if (genericName.trim().isNotEmpty) genericName.trim(),
      if (manufacturerName.trim().isNotEmpty) manufacturerName.trim(),
      if (indications.trim().isNotEmpty) indications.trim(),
      if (contraIndications.trim().isNotEmpty) contraIndications.trim(),
    ];
    return parts.join('\n');
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
    required this.limit,
    required this.hasNextPage,
  });

  final bool success;
  final String message;
  final List<PharmacyMedicineModel> medicines;
  final int currentPage;
  final int lastPage;
  final int total;
  final int limit;
  final bool hasNextPage;

  factory PharmacyProductsPageModel.fromJson(Map<String, dynamic> json) {
    final pagePayload = _resolvePagePayload(json);

    final rawList =
        pagePayload['data'] ?? pagePayload['medicines'] ?? <dynamic>[];
    final medicines = (rawList is List ? rawList : <dynamic>[])
        .whereType<Map>()
        .map(
          (item) => PharmacyMedicineModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList(growable: false);

    final currentPage = _parseInt(
      pagePayload['page'] ?? pagePayload['current_page'],
      fallback: 1,
    );
    final limit = _parseInt(pagePayload['limit'], fallback: medicines.length);
    final total = _parseInt(
      pagePayload['total'],
      fallback: medicines.length,
    );
    final lastPage = _parseInt(
      pagePayload['totalPages'] ??
          pagePayload['total_pages'] ??
          pagePayload['last_page'],
      fallback: limit > 0 ? (total / limit).ceil().clamp(1, 999999) : 1,
    );
    final hasNextPage = pagePayload.containsKey('hasNextPage') ||
        pagePayload.containsKey('has_next_page')
        ? _asBool(pagePayload['hasNextPage'] ?? pagePayload['has_next_page'])
        : currentPage < lastPage;

    return PharmacyProductsPageModel(
      success: json['success'] == true ||
          (json['code'] is num && (json['code'] as num).toInt() == 200),
      message: _asString(json['message']),
      medicines: medicines,
      currentPage: currentPage,
      lastPage: lastPage,
      total: total,
      limit: limit,
      hasNextPage: hasNextPage,
    );
  }

  static Map<String, dynamic> _resolvePagePayload(Map<String, dynamic> json) {
    final level1 = json['data'];
    if (level1 is! Map) return json;

    final map1 = Map<String, dynamic>.from(level1);

    // Current API: { data: { data: [...], page, limit, total, totalPages } }
    if (map1['data'] is List) {
      return map1;
    }

    // Legacy wrapper: { data: { data: { data: [...], current_page, ... } } }
    final level2 = map1['data'];
    if (level2 is Map) {
      final map2 = Map<String, dynamic>.from(level2);
      if (map2['data'] is List || map2['medicines'] is List) {
        return map2;
      }
    }

    return map1;
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
    final productMap = _resolveProductPayload(json);

    final rawRelated = productMap['related_items'] ??
        productMap['relatedItems'] ??
        (json['data'] is Map
            ? (json['data'] as Map)['related_items'] ??
                (json['data'] as Map)['relatedItems']
            : null) ??
        <dynamic>[];
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
      message: _asString(json['message']),
      product: PharmacyMedicineModel.fromProductDetailJson(productMap),
      relatedItems: relatedItems,
    );
  }

  /// Current API: `{ data: { product_id, display_name, ... } }`
  /// Legacy: `{ data: { data: { id, display_name, related_items, ... } } }`
  static Map<String, dynamic> _resolveProductPayload(
    Map<String, dynamic> json,
  ) {
    final data = json['data'];
    if (data is! Map) return json;

    final outer = Map<String, dynamic>.from(data);

    // New Partner shape: product fields live directly under `data`.
    if (outer.containsKey('product_id') ||
        outer.containsKey('productId') ||
        outer.containsKey('display_name') ||
        outer.containsKey('displayName')) {
      return outer;
    }

    // Legacy nested wrapper.
    final inner = outer['data'];
    if (inner is Map) {
      return Map<String, dynamic>.from(inner);
    }

    return outer;
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
  const PharmacyCartItemModel({
    required this.medicine,
    required this.quantity,
    this.lineId = '',
    this.unitPrice,
    this.lineTotal,
  });

  final PharmacyMedicineModel medicine;
  final int quantity;

  /// Cart-line id (not product id), when the API returns one.
  final String lineId;

  /// Unit price from the cart line (`price`), if present.
  final double? unitPrice;

  /// Line total from the cart (`total` / `subtotal`), if present.
  final double? lineTotal;

  factory PharmacyCartItemModel.fromJson(Map<String, dynamic> json) {
    final nestedProduct = json['product'];
    final Map<String, dynamic> productJson;
    if (nestedProduct is Map) {
      productJson = Map<String, dynamic>.from(nestedProduct);
    } else {
      // Flat cart line that already looks like a Partner product.
      productJson = Map<String, dynamic>.from(json)
        ..remove('quantity')
        ..remove('qty')
        ..remove('booking_id')
        ..remove('bookingId')
        ..remove('total')
        ..remove('subtotal')
        ..remove('line_total')
        ..remove('lineTotal')
        ..remove('unitPrice')
        ..remove('unit_price')
        ..remove('pivot');
    }

    // Cart line `product_id` is the medicine identity (prefer over line `id`).
    final lineProductId = json['product_id'] ?? json['productId'];
    if (lineProductId != null) {
      productJson['product_id'] = lineProductId;
      productJson['id'] ??= lineProductId;
    }

    // Prefer cart-line image when nested product omits it.
    final lineImage = json['image_url'] ?? json['imageUrl'];
    if (lineImage != null &&
        _asString(productJson['image_url'] ?? productJson['imageUrl']).isEmpty) {
      productJson['image_url'] = lineImage;
    }

    final unitPriceRaw =
        json['unitPrice'] ?? json['unit_price'] ?? json['price'];
    if (unitPriceRaw != null) {
      // Cart-line unit price wins over nested product price.
      productJson['price'] = unitPriceRaw;
    }

    final pivot = json['pivot'];
    final quantityRaw = json['quantity'] ??
        (pivot is Map ? pivot['quantity'] : null) ??
        json['qty'];

    final unitPrice =
        unitPriceRaw != null ? _parsePrice(unitPriceRaw) : null;
    final lineTotalRaw = json['line_total'] ??
        json['lineTotal'] ??
        json['total'] ??
        json['subtotal'];
    final lineTotal =
        lineTotalRaw != null ? _parsePrice(lineTotalRaw) : null;

    // Line `id` is the cart-row id when `product_id` is also present.
    final lineId = (json['product_id'] != null || json['productId'] != null)
        ? _asString(json['id'])
        : '';

    return PharmacyCartItemModel(
      medicine: PharmacyMedicineModel.fromJson(productJson),
      quantity: _parseQuantity(quantityRaw),
      lineId: lineId,
      unitPrice: unitPrice,
      lineTotal: lineTotal,
    );
  }

  static int _parseQuantity(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 1;
  }
}

class PharmacyCartAddressModel {
  const PharmacyCartAddressModel({
    required this.id,
    required this.address,
    this.region = '',
  });

  final String id;
  final String address;
  final String region;

  factory PharmacyCartAddressModel.fromJson(Map<String, dynamic> json) {
    return PharmacyCartAddressModel(
      id: (json['id'] ?? json['address_id'] ?? json['addressId'] ?? '')
          .toString()
          .trim(),
      address:
          (json['address'] ?? json['full_address'] ?? json['fullAddress'] ?? '')
              .toString()
              .trim(),
      region: (json['region'] ?? json['city'] ?? '').toString().trim(),
    );
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
    this.addresses = const [],
  });

  final bool success;
  final String message;
  final String? bookingId;
  final List<PharmacyCartItemModel> items;
  final bool hasProductList;
  final PharmacyPaymentBreakdownModel? paymentBreakdown;
  final List<PharmacyCartAddressModel> addresses;

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
      addresses: _parseFamilyMemberAddresses(payload),
    );
  }

  /// Collects addresses from `family_members[].addresses` (null → empty).
  static List<PharmacyCartAddressModel> _parseFamilyMemberAddresses(
    Map<String, dynamic> payload,
  ) {
    final members = payload['family_members'] ?? payload['familyMembers'];
    if (members is! List) return const [];

    final addresses = <PharmacyCartAddressModel>[];
    for (final member in members) {
      if (member is! Map) continue;
      final memberMap = Map<String, dynamic>.from(member);
      final rawAddresses = memberMap['addresses'];
      if (rawAddresses == null) continue;
      if (rawAddresses is! List) continue;

      for (final entry in rawAddresses) {
        if (entry is! Map) continue;
        final address = PharmacyCartAddressModel.fromJson(
          Map<String, dynamic>.from(entry),
        );
        if (address.address.trim().isEmpty && address.id.isEmpty) continue;
        addresses.add(address);
      }
    }
    return addresses;
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
          nested.containsKey('payment_breakdown') ||
          nested.containsKey('family_members')) {
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
