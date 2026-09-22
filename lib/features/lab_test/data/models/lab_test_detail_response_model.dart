class LabTestDetailPricingOptionModel {
  const LabTestDetailPricingOptionModel({
    required this.price,
    required this.discountPct,
    required this.finalPrice,
  });

  final int price;
  final int discountPct;
  final int finalPrice;

  factory LabTestDetailPricingOptionModel.fromJson(Map<String, dynamic> json) {
    return LabTestDetailPricingOptionModel(
      price: (json['price'] as num?)?.toInt() ?? 0,
      discountPct: (json['discountPct'] as num?)?.toInt() ?? 0,
      finalPrice: (json['finalPrice'] as num?)?.toInt() ?? 0,
    );
  }
}

class LabTestDetailLabModel {
  const LabTestDetailLabModel({
    required this.labId,
    required this.labName,
    required this.labSlug,
    this.logoUrl,
    required this.rating,
    required this.estimatedReportHours,
    required this.supportsHomeSampling,
    required this.supportsWalkIn,
    required this.homeSamplingFee,
    required this.pricing,
  });

  final int labId;
  final String labName;
  final String labSlug;
  final String? logoUrl;
  final String rating;
  final int estimatedReportHours;
  final bool supportsHomeSampling;
  final bool supportsWalkIn;
  final String homeSamplingFee;
  final Map<String, LabTestDetailPricingOptionModel> pricing;

  factory LabTestDetailLabModel.fromJson(Map<String, dynamic> json) {
    final rawPricing = json['pricing'];
    final pricing = <String, LabTestDetailPricingOptionModel>{};
    if (rawPricing is Map<String, dynamic>) {
      for (final entry in rawPricing.entries) {
        if (entry.value is Map<String, dynamic>) {
          pricing[entry.key] = LabTestDetailPricingOptionModel.fromJson(
            entry.value as Map<String, dynamic>,
          );
        }
      }
    }

    return LabTestDetailLabModel(
      labId: (json['labId'] as num?)?.toInt() ?? 0,
      labName: (json['labName'] ?? '').toString(),
      labSlug: (json['labSlug'] ?? '').toString(),
      logoUrl: json['logoUrl']?.toString(),
      rating: (json['rating'] ?? '').toString(),
      estimatedReportHours: (json['estimatedReportHours'] as num?)?.toInt() ?? 0,
      supportsHomeSampling: _toBool(json['supportsHomeSampling']),
      supportsWalkIn: _toBool(json['supportsWalkIn']),
      homeSamplingFee: (json['homeSamplingFee'] ?? '0').toString(),
      pricing: pricing,
    );
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    return false;
  }
}

class LabTestDetailPartnerModel {
  const LabTestDetailPartnerModel({
    required this.partnerId,
    required this.partnerName,
    this.partnerLogoUrl,
    required this.labs,
  });

  final int partnerId;
  final String partnerName;
  final String? partnerLogoUrl;
  final List<LabTestDetailLabModel> labs;

  factory LabTestDetailPartnerModel.fromJson(Map<String, dynamic> json) {
    final rawLabs = json['labs'];
    final labs = (rawLabs is List ? rawLabs : const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(LabTestDetailLabModel.fromJson)
        .toList(growable: false);

    return LabTestDetailPartnerModel(
      partnerId: (json['partnerId'] as num?)?.toInt() ?? 0,
      partnerName: (json['partnerName'] ?? '').toString(),
      partnerLogoUrl: json['partnerLogoUrl']?.toString(),
      labs: labs,
    );
  }
}

class LabTestDetailDataModel {
  const LabTestDetailDataModel({
    required this.id,
    required this.name,
    required this.description,
    required this.sampleType,
    required this.fastingRequired,
    required this.turnaroundHours,
    required this.partners,
  });

  final int id;
  final String name;
  final String description;
  final String sampleType;
  final bool fastingRequired;
  final int turnaroundHours;
  final List<LabTestDetailPartnerModel> partners;

  factory LabTestDetailDataModel.fromJson(Map<String, dynamic> json) {
    final rawPartners = json['partners'];
    final partners = (rawPartners is List ? rawPartners : const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(LabTestDetailPartnerModel.fromJson)
        .toList(growable: false);

    return LabTestDetailDataModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      sampleType: (json['sampleType'] ?? '').toString(),
      fastingRequired: _asBool(
        json['fastingRequired'] ?? json['fasting_required'],
      ),
      turnaroundHours: (json['turnaroundHours'] as num?)?.toInt() ?? 0,
      partners: partners,
    );
  }
}

bool _asBool(dynamic value) {
  if (value == true || value == 1) return true;
  if (value == false || value == 0 || value == null) return false;
  final text = value.toString().trim().toLowerCase();
  return text == '1' || text == 'true' || text == 'yes';
}

class LabTestDetailResponseModel {
  const LabTestDetailResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final LabTestDetailDataModel data;

  factory LabTestDetailResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return LabTestDetailResponseModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      data: rawData is Map<String, dynamic>
          ? LabTestDetailDataModel.fromJson(rawData)
          : const LabTestDetailDataModel(
              id: 0,
              name: '',
              description: '',
              sampleType: '',
              fastingRequired: false,
              turnaroundHours: 0,
              partners: [],
            ),
    );
  }
}
