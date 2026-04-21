class LabTestItemModel {
  const LabTestItemModel({
    required this.id,
    required this.title,
    required this.sampleType,
    this.requirement,
  });

  final String id;
  final String title;
  final String sampleType;
  final String? requirement;

  factory LabTestItemModel.fromJson(Map<String, dynamic> json) {
    return LabTestItemModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      sampleType: (json['sampleType'] ?? '').toString(),
      requirement: json['requirement']?.toString(),
    );
  }
}

class LabTestPartnerModel {
  const LabTestPartnerModel({
    required this.id,
    required this.name,
    required this.logoUrl,
  });

  final String id;
  final String name;
  final String logoUrl;

  factory LabTestPartnerModel.fromJson(Map<String, dynamic> json) {
    return LabTestPartnerModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      logoUrl: (json['logoUrl'] ?? '').toString(),
    );
  }
}

class LabTestVendorModel {
  const LabTestVendorModel({
    required this.id,
    required this.name,
    required this.logoUrl,
    this.markUrl,
  });

  final String id;
  final String name;
  final String logoUrl;
  final String? markUrl;

  factory LabTestVendorModel.fromJson(Map<String, dynamic> json) {
    return LabTestVendorModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      logoUrl: (json['logoUrl'] ?? '').toString(),
      markUrl: json['markUrl']?.toString(),
    );
  }
}

class LabTestPricingModel {
  const LabTestPricingModel({
    required this.discountedFee,
    required this.originalFee,
    required this.discountPercent,
    required this.discountAmount,
    required this.discountCode,
    required this.totalAmount,
  });

  final String discountedFee;
  final String originalFee;
  final int discountPercent;
  final String discountAmount;
  final String discountCode;
  final String totalAmount;

  factory LabTestPricingModel.fromJson(Map<String, dynamic> json) {
    return LabTestPricingModel(
      discountedFee: (json['discountedFee'] ?? '').toString(),
      originalFee: (json['originalFee'] ?? '').toString(),
      discountPercent: (json['discountPercent'] as num?)?.toInt() ?? 0,
      discountAmount: (json['discountAmount'] ?? '').toString(),
      discountCode: (json['discountCode'] ?? '').toString(),
      totalAmount: (json['totalAmount'] ?? '').toString(),
    );
  }
}

class LabTestCatalogResponseModel {
  const LabTestCatalogResponseModel({
    required this.success,
    required this.message,
    required this.cities,
    required this.items,
    required this.requirementLines,
    required this.partners,
    required this.vendors,
    required this.pricing,
  });

  final bool success;
  final String message;
  final List<String> cities;
  final List<LabTestItemModel> items;
  final List<String> requirementLines;
  final List<LabTestPartnerModel> partners;
  final List<LabTestVendorModel> vendors;
  final LabTestPricingModel pricing;

  factory LabTestCatalogResponseModel.fromJson(Map<String, dynamic> json) {
    final rawCities = json['cities'];
    final cities = (rawCities is List ? rawCities : const <dynamic>[])
        .map((e) => e.toString())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);

    final rawItems = json['items'];
    final items = (rawItems is List ? rawItems : const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(LabTestItemModel.fromJson)
        .toList(growable: false);

    final rawRequirementLines = json['requirementLines'];
    final requirementLines =
        (rawRequirementLines is List ? rawRequirementLines : const <dynamic>[])
            .map((e) => e.toString())
            .where((e) => e.isNotEmpty)
            .toList(growable: false);

    final rawPartners = json['partners'];
    final partners = (rawPartners is List ? rawPartners : const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(LabTestPartnerModel.fromJson)
        .toList(growable: false);

    final rawVendors = json['vendors'];
    final vendors = (rawVendors is List ? rawVendors : const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(LabTestVendorModel.fromJson)
        .toList(growable: false);

    final rawPricing = json['pricing'];
    final pricing = LabTestPricingModel.fromJson(
      rawPricing is Map<String, dynamic>
          ? rawPricing
          : const <String, dynamic>{},
    );

    return LabTestCatalogResponseModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      cities: cities,
      items: items,
      requirementLines: requirementLines,
      partners: partners,
      vendors: vendors,
      pricing: pricing,
    );
  }
}
