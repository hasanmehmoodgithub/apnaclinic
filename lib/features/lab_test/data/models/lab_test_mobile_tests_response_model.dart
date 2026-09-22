class LabTestMobileLabModel {
  const LabTestMobileLabModel({
    required this.labId,
    required this.price,
    required this.labName,
    required this.labSlug,
    required this.orderType,
    this.finalPrice,
    required this.discountPct,
    required this.supportsWalkIn,
    required this.homeSamplingFee,
    required this.supportsHomeSampling,
    this.logoUrl,
  });

  final int labId;
  final int price;
  final String labName;
  final String labSlug;
  final String orderType;
  final int? finalPrice;
  final int discountPct;
  final bool supportsWalkIn;
  final int homeSamplingFee;
  final bool supportsHomeSampling;
  final String? logoUrl;

  factory LabTestMobileLabModel.fromJson(Map<String, dynamic> json) {
    return LabTestMobileLabModel(
      labId: (json['labId'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toInt() ?? 0,
      labName: (json['labName'] ?? '').toString(),
      labSlug: (json['labSlug'] ?? '').toString(),
      orderType: (json['orderType'] ?? '').toString(),
      finalPrice: (json['finalPrice'] as num?)?.toInt(),
      discountPct: (json['discountPct'] as num?)?.toInt() ?? 0,
      supportsWalkIn: _toBool(json['supportsWalkIn']),
      homeSamplingFee: (json['homeSamplingFee'] as num?)?.toInt() ?? 0,
      supportsHomeSampling: _toBool(json['supportsHomeSampling']),
      logoUrl: json['logoUrl']?.toString() ?? json['labLogoUrl']?.toString(),
    );
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    return false;
  }
}

class LabTestMobileItemModel {
  const LabTestMobileItemModel({
    required this.testId,
    required this.testName,
    required this.sampleType,
    required this.fastingRequired,
    required this.turnaroundHours,
    required this.description,
    required this.labs,
  });

  final int testId;
  final String testName;
  final String sampleType;
  final bool fastingRequired;
  final int turnaroundHours;
  final String description;
  final List<LabTestMobileLabModel> labs;

  factory LabTestMobileItemModel.fromJson(Map<String, dynamic> json) {
    final rawLabs = json['labs'];
    final labs = (rawLabs is List ? rawLabs : const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(LabTestMobileLabModel.fromJson)
        .toList(growable: false);

    return LabTestMobileItemModel(
      testId: (json['testId'] as num?)?.toInt() ?? 0,
      testName: (json['testName'] ?? '').toString(),
      sampleType: (json['sampleType'] ?? '').toString(),
      fastingRequired: _asBool(json['fastingRequired'] ?? json['fasting_required']),
      turnaroundHours: (json['turnaroundHours'] as num?)?.toInt() ?? 0,
      description: (json['description'] ?? '').toString(),
      labs: labs,
    );
  }
}

bool _asBool(dynamic value) {
  if (value == true || value == 1) return true;
  if (value == false || value == 0 || value == null) return false;
  final text = value.toString().trim().toLowerCase();
  return text == '1' || text == 'true' || text == 'yes';
}

class LabTestMobileTestsDataModel {
  const LabTestMobileTestsDataModel({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  final List<LabTestMobileItemModel> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  factory LabTestMobileTestsDataModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = (rawItems is List ? rawItems : const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(LabTestMobileItemModel.fromJson)
        .toList(growable: false);

    return LabTestMobileTestsDataModel(
      items: items,
      total: (json['total'] as num?)?.toInt() ?? items.length,
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
    );
  }
}

class LabTestMobileTestsResponseModel {
  const LabTestMobileTestsResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final LabTestMobileTestsDataModel data;

  factory LabTestMobileTestsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return LabTestMobileTestsResponseModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      data: rawData is Map<String, dynamic>
          ? LabTestMobileTestsDataModel.fromJson(rawData)
          : const LabTestMobileTestsDataModel(
              items: [],
              total: 0,
              page: 1,
              limit: 20,
              totalPages: 0,
            ),
    );
  }
}
