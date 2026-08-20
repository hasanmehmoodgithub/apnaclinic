String _asString(dynamic value, {String fallback = ''}) {
  if (value == null) return fallback;
  final text = value.toString().trim();
  if (text.toLowerCase() == 'null') return fallback;
  return text;
}

String? _nullableString(dynamic value) {
  final text = _asString(value);
  return text.isEmpty ? null : text;
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

class LabOrderLabModel {
  const LabOrderLabModel({
    required this.id,
    required this.name,
    required this.logoUrl,
  });

  final String id;
  final String name;
  final String logoUrl;

  factory LabOrderLabModel.fromJson(Map<String, dynamic> json) {
    return LabOrderLabModel(
      id: _asString(json['id']),
      name: _asString(json['name']),
      logoUrl: _asString(json['logoUrl'] ?? json['logo_url']),
    );
  }

  static const empty = LabOrderLabModel(id: '', name: '', logoUrl: '');
}

class LabOrderPartnerModel {
  const LabOrderPartnerModel({
    required this.id,
    required this.name,
    required this.logoUrl,
  });

  final String id;
  final String name;
  final String logoUrl;

  factory LabOrderPartnerModel.fromJson(Map<String, dynamic> json) {
    return LabOrderPartnerModel(
      id: _asString(json['id']),
      name: _asString(json['name']),
      logoUrl: _asString(json['logoUrl'] ?? json['logo_url']),
    );
  }

  static const empty = LabOrderPartnerModel(id: '', name: '', logoUrl: '');
}

class LabOrderPatientModel {
  const LabOrderPatientModel({
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
  });

  final String name;
  final int age;
  final String gender;
  final String phone;

  factory LabOrderPatientModel.fromJson(Map<String, dynamic> json) {
    return LabOrderPatientModel(
      name: _asString(json['name']),
      age: _asInt(json['age']),
      gender: _asString(json['gender']),
      phone: _asString(json['phone']),
    );
  }

  static const empty = LabOrderPatientModel(
    name: '',
    age: 0,
    gender: '',
    phone: '',
  );
}

class LabOrderTestModel {
  const LabOrderTestModel({
    required this.name,
    required this.price,
    required this.status,
  });

  final String name;
  final int price;
  final String status;

  factory LabOrderTestModel.fromJson(Map<String, dynamic> json) {
    return LabOrderTestModel(
      name: _asString(json['name']),
      price: _asInt(json['price']),
      status: _asString(json['status']),
    );
  }
}

class LabOrderPricingModel {
  const LabOrderPricingModel({
    required this.subtotal,
    required this.discount,
    required this.homeSamplingFee,
    required this.total,
    required this.currency,
  });

  final int subtotal;
  final int discount;
  final int homeSamplingFee;
  final int total;
  final String currency;

  factory LabOrderPricingModel.fromJson(Map<String, dynamic> json) {
    return LabOrderPricingModel(
      subtotal: _asInt(json['subtotal']),
      discount: _asInt(json['discount']),
      homeSamplingFee: _asInt(json['homeSamplingFee'] ?? json['home_sampling_fee']),
      total: _asInt(json['total']),
      currency: _asString(json['currency'], fallback: 'PKR'),
    );
  }

  static const empty = LabOrderPricingModel(
    subtotal: 0,
    discount: 0,
    homeSamplingFee: 0,
    total: 0,
    currency: 'PKR',
  );
}

class LabOrderModel {
  const LabOrderModel({
    required this.orderId,
    required this.publicId,
    required this.orderType,
    required this.status,
    required this.reportStatus,
    required this.paymentMethod,
    required this.partnerRef,
    required this.discountCode,
    required this.lab,
    required this.partner,
    required this.patient,
    required this.tests,
    required this.pricing,
    required this.reports,
    this.invoice,
    required this.placedAt,
    required this.createdAt,
  });

  final String orderId;
  final String publicId;
  final String orderType;

  /// e.g. `Confirmed`, `Payment Pending`, `PLACED`.
  final String status;

  /// e.g. `NOT_AVAILABLE`, `AVAILABLE`.
  final String reportStatus;
  final String paymentMethod;
  final String? partnerRef;
  final String? discountCode;
  final LabOrderLabModel lab;
  final LabOrderPartnerModel partner;
  final LabOrderPatientModel patient;
  final List<LabOrderTestModel> tests;
  final LabOrderPricingModel pricing;
  final List<String> reports;

  /// PDF download URL for the order invoice, when available.
  final String? invoice;
  final String placedAt;
  final String createdAt;

  factory LabOrderModel.fromJson(Map<String, dynamic> json) {
    final lab = json['lab'];
    final partner = json['partner'];
    final patient = json['patient'];
    final pricing = json['pricing'];

    final rawTests = json['tests'];
    final tests = rawTests is List
        ? rawTests
            .whereType<Map>()
            .map((t) => LabOrderTestModel.fromJson(Map<String, dynamic>.from(t)))
            .toList(growable: false)
        : const <LabOrderTestModel>[];

    final rawReports = json['reports'];
    final reports = _parseReports(rawReports);
    final invoice =
        _usableHttpUrl(_nullableString(json['invoice'])) ??
        _firstUsableUrl(reports);

    return LabOrderModel(
      orderId: _asString(json['orderId'] ?? json['order_id'] ?? json['id']),
      publicId: _asString(json['publicId'] ?? json['public_id']),
      orderType: _asString(json['orderType'] ?? json['order_type']),
      status: _parseStatus(json),
      reportStatus: _asString(json['reportStatus'] ?? json['report_status']),
      paymentMethod: _asString(json['paymentMethod'] ?? json['payment_method']),
      partnerRef: _nullableString(json['partnerRef'] ?? json['partner_ref']),
      discountCode: _nullableString(json['discountCode'] ?? json['discount_code']),
      lab: lab is Map
          ? LabOrderLabModel.fromJson(Map<String, dynamic>.from(lab))
          : LabOrderLabModel.empty,
      partner: partner is Map
          ? LabOrderPartnerModel.fromJson(Map<String, dynamic>.from(partner))
          : LabOrderPartnerModel.empty,
      patient: patient is Map
          ? LabOrderPatientModel.fromJson(Map<String, dynamic>.from(patient))
          : LabOrderPatientModel.empty,
      tests: tests,
      pricing: pricing is Map
          ? LabOrderPricingModel.fromJson(Map<String, dynamic>.from(pricing))
          : LabOrderPricingModel.empty,
      reports: reports,
      invoice: invoice,
      placedAt: _asString(json['placedAt'] ?? json['placed_at']),
      createdAt: _asString(json['createdAt'] ?? json['created_at']),
    );
  }

  static String _parseStatus(Map<String, dynamic> json) {
    final raw = json['status'] ??
        json['orderStatus'] ??
        json['order_status'] ??
        json['paymentStatus'] ??
        json['payment_status'];
    if (raw is Map) {
      return _asString(
        raw['label'] ??
            raw['name'] ??
            raw['value'] ??
            raw['code'] ??
            raw['status'],
      );
    }
    return _asString(raw);
  }

  static List<String> _parseReports(dynamic raw) {
    if (raw is! List) return const <String>[];
    return raw
        .map(_reportUrl)
        .where((url) => url.isNotEmpty)
        .toList(growable: false);
  }

  static String _reportUrl(dynamic raw) {
    if (raw == null) return '';
    if (raw is String) return _usableHttpUrl(_asString(raw)) ?? '';
    if (raw is Map) {
      return _usableHttpUrl(
            _asString(
              raw['url'] ??
                  raw['fileUrl'] ??
                  raw['file_url'] ??
                  raw['reportUrl'] ??
                  raw['pdfUrl'],
            ),
          ) ??
          '';
    }
    return _usableHttpUrl(_asString(raw)) ?? '';
  }

  static String? _usableHttpUrl(String? raw) {
    final value = raw?.trim() ?? '';
    if (!value.startsWith('http')) return null;
    final host = Uri.tryParse(value)?.host.toLowerCase() ?? '';
    if (host.isEmpty || host == 'localhost' || host == '127.0.0.1') {
      return null;
    }
    return value;
  }

  static String? _firstUsableUrl(List<String> urls) {
    for (final url in urls) {
      final usable = _usableHttpUrl(url);
      if (usable != null) return usable;
    }
    return null;
  }

  /// Parses `GET /lab-orders/{id}` envelope (`data` is a single order object).
  factory LabOrderModel.fromDetailResponse(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map) {
      return LabOrderModel.fromJson(Map<String, dynamic>.from(data));
    }
    return LabOrderModel.fromJson(json);
  }
}

class LabOrdersPageModel {
  const LabOrdersPageModel({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
  });

  final List<LabOrderModel> items;
  final int page;
  final int limit;
  final int total;

  factory LabOrdersPageModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is List) {
      final items = data
          .whereType<Map>()
          .map((item) => LabOrderModel.fromJson(Map<String, dynamic>.from(item)))
          .toList(growable: false);
      return LabOrdersPageModel(
        items: items,
        page: _asInt(json['page'], fallback: 1),
        limit: _asInt(json['limit'], fallback: items.length),
        total: _asInt(json['total'], fallback: items.length),
      );
    }

    final dataMap =
        data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{};
    final rawItems = dataMap['data'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map>()
            .map((item) => LabOrderModel.fromJson(Map<String, dynamic>.from(item)))
            .toList(growable: false)
        : const <LabOrderModel>[];

    return LabOrdersPageModel(
      items: items,
      page: _asInt(dataMap['page'], fallback: 1),
      limit: _asInt(dataMap['limit'], fallback: 20),
      total: _asInt(dataMap['total'], fallback: items.length),
    );
  }
}
