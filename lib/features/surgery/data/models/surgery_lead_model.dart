class SurgeryLeadModel {
  const SurgeryLeadModel({
    required this.leadId,
    required this.surgeryId,
    required this.surgeryType,
    required this.subSurgeryType,
    required this.providerId,
    required this.providerName,
    required this.providerLogoUrl,
    required this.doctorId,
    required this.doctorName,
    required this.specialty,
    required this.education,
    required this.hospitalName,
    required this.status,
    required this.paymentAllowed,
    required this.leadCreatedDate,
    required this.leadCreatedTime,
    required this.leadCreatedAt,
    required this.confirmedDate,
    required this.scheduledDate,
    required this.scheduledStartTime,
    required this.scheduledEndTime,
    required this.patientName,
    required this.age,
    required this.gender,
    required this.phone,
    required this.emergencyPhone,
    required this.fee,
    required this.discount,
    required this.total,
    required this.currency,
    this.discountCode = '',
  });

  final String leadId;
  final String surgeryId;
  final String surgeryType;
  final String subSurgeryType;
  final String providerId;
  final String providerName;
  final String providerLogoUrl;
  final String doctorId;
  final String doctorName;
  final String specialty;
  final String education;
  final String hospitalName;
  final String status;
  final bool paymentAllowed;
  final String leadCreatedDate;
  final String leadCreatedTime;
  final String leadCreatedAt;
  final String? confirmedDate;
  final String? scheduledDate;
  final String? scheduledStartTime;
  final String? scheduledEndTime;
  final String patientName;
  final int age;
  final String gender;
  final String phone;
  final String emergencyPhone;
  final int fee;
  final int discount;
  final int total;
  final String currency;

  /// Optional `pricing.discountCode`; empty hides the checkout discount strip.
  final String discountCode;

  factory SurgeryLeadModel.fromJson(Map<String, dynamic> json) {
    final provider = json['provider'];
    final doctor = json['doctor'];
    final patient = json['patient'];
    final pricing = json['pricing'];

    final providerMap = provider is Map
        ? Map<String, dynamic>.from(provider)
        : <String, dynamic>{};
    final doctorMap =
        doctor is Map ? Map<String, dynamic>.from(doctor) : <String, dynamic>{};
    final patientMap = patient is Map
        ? Map<String, dynamic>.from(patient)
        : <String, dynamic>{};
    final pricingMap = pricing is Map
        ? Map<String, dynamic>.from(pricing)
        : <String, dynamic>{};

    final status = _asString(
      json['status'] ?? json['leadStatus'] ?? json['lead_status'],
    );

    final fee = _asInt(pricingMap['fee']);
    final discount = _resolveDiscount(pricingMap, fee);
    final total = _resolveTotal(pricingMap, fee, discount);

    return SurgeryLeadModel(
      leadId: _asString(json['leadId'] ?? json['lead_id']),
      surgeryId: _asString(json['surgeryId'] ?? json['surgery_id']),
      surgeryType: _asString(json['surgeryType'] ?? json['surgery_type']),
      subSurgeryType: _asString(
        json['subSurgeryType'] ?? json['sub_surgery_type'],
      ),
      providerId: _asString(providerMap['id']),
      providerName: _asString(providerMap['name']),
      providerLogoUrl: _asString(
        providerMap['logoUrl'] ??
            providerMap['logo_url'] ??
            providerMap['partnerLogoUrl'] ??
            providerMap['partner_logo_url'],
      ),
      doctorId: _asString(doctorMap['id']),
      doctorName: _asString(doctorMap['name']),
      specialty: _asString(doctorMap['specialty'] ?? doctorMap['speciality']),
      education: _asString(doctorMap['education']),
      hospitalName: _asString(
        json['hospitalName'] ??
            json['hospital_name'] ??
            doctorMap['hospitalName'] ??
            doctorMap['hospital_name'] ??
            patientMap['hospitalName'],
      ),
      status: status,
      paymentAllowed: _asBool(
        json['paymentAllowed'] ?? json['payment_allowed'],
      ),
      leadCreatedDate: _asString(
        json['leadCreatedDate'] ?? json['lead_created_date'],
      ),
      leadCreatedTime: _asString(
        json['leadCreatedTime'] ?? json['lead_created_time'],
      ),
      leadCreatedAt: _asString(
        json['leadCreatedAt'] ?? json['lead_created_at'],
      ),
      confirmedDate: _nullableString(
        json['confirmedDate'] ?? json['confirmed_date'],
      ),
      scheduledDate: _normalizeScheduledDate(
        _nullableString(json['scheduledDate'] ?? json['scheduled_date']),
      ),
      scheduledStartTime: _nullableString(
        json['scheduledStartTime'] ?? json['scheduled_start_time'],
      ),
      scheduledEndTime: _nullableString(
        json['scheduledEndTime'] ?? json['scheduled_end_time'],
      ),
      patientName: _asString(patientMap['name']),
      age: _asInt(patientMap['age']),
      gender: _asString(patientMap['gender']),
      phone: _asString(patientMap['phone']),
      emergencyPhone: _asString(
        patientMap['emergencyPhone'] ?? patientMap['emergency_phone'],
      ),
      fee: fee,
      discount: discount,
      total: total,
      currency: _asString(pricingMap['currency'], fallback: 'PKR'),
      discountCode: _asString(
        pricingMap['discountCode'] ??
            pricingMap['discount_code'] ??
            json['discountCode'] ??
            json['discount_code'],
      ),
    );
  }

  /// New API: `discount` amount. Legacy: `discountFee` as payable, or fee − payable.
  static int _resolveDiscount(Map<String, dynamic> pricing, int fee) {
    if (pricing.containsKey('discount') && pricing['discount'] != null) {
      return _asInt(pricing['discount']);
    }
    final discountFee = _asInt(
      pricing['discountFee'] ?? pricing['discount_fee'],
    );
    final quoted = _asInt(pricing['quotedPrice'] ?? pricing['quoted_price']);
    final finalPrice = _nullableInt(
      pricing['finalPrice'] ?? pricing['final_price'],
    );
    final payable = finalPrice ?? (quoted > 0 ? quoted : discountFee);
    if (fee > payable && payable > 0) return fee - payable;
    return 0;
  }

  static int _resolveTotal(Map<String, dynamic> pricing, int fee, int discount) {
    if (pricing.containsKey('total') && pricing['total'] != null) {
      return _asInt(pricing['total']);
    }
    final finalPrice = _nullableInt(
      pricing['finalPrice'] ?? pricing['final_price'],
    );
    if (finalPrice != null) return finalPrice;
    final quoted = _asInt(pricing['quotedPrice'] ?? pricing['quoted_price']);
    if (quoted > 0) return quoted;
    if (fee > 0 && discount >= 0) return (fee - discount).clamp(0, fee);
    return fee;
  }

  static String _asString(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    final text = value.toString().trim();
    if (text.toLowerCase() == 'null') return fallback;
    return text;
  }

  static String? _nullableString(dynamic value) {
    final text = _asString(value);
    return text.isEmpty ? null : text;
  }

  /// API now sends date-only (`2025-10-14`); legacy values may include midnight time.
  static String? _normalizeScheduledDate(String? raw) {
    if (raw == null) return null;
    final text = raw.trim();
    if (text.isEmpty) return null;
    final match = RegExp(r'^(\d{4}-\d{2}-\d{2})').firstMatch(text);
    return match?.group(1) ?? text;
  }

  static int _asInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int? _nullableInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static bool _asBool(dynamic value) {
    if (value is bool) return value;
    final text = value?.toString().trim().toLowerCase();
    return text == 'true' || text == '1';
  }
}

class SurgeryLeadsPageModel {
  const SurgeryLeadsPageModel({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  final List<SurgeryLeadModel> items;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  factory SurgeryLeadsPageModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final dataMap =
        data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{};
    final rawItems = dataMap['items'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map>()
            .map((item) => SurgeryLeadModel.fromJson(
                  Map<String, dynamic>.from(item),
                ))
            .toList(growable: false)
        : const <SurgeryLeadModel>[];

    return SurgeryLeadsPageModel(
      items: items,
      page: _asInt(dataMap['page'], fallback: 1),
      limit: _asInt(dataMap['limit'], fallback: 20),
      total: _asInt(dataMap['total']),
      totalPages: _asInt(dataMap['totalPages'] ?? dataMap['total_pages']),
    );
  }

  static int _asInt(dynamic value, {int fallback = 0}) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
