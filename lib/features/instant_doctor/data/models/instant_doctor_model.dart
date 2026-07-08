class InstantDoctorProductModel {
  const InstantDoctorProductModel({
    required this.productId,
    required this.productCode,
    required this.productType,
    required this.productTitle,
    required this.priceDisplay,
    required this.benefits,
    required this.redirectUrl,
  });

  final int productId;
  final String productCode;
  final String productType;
  final String productTitle;
  final String priceDisplay;
  final List<String> benefits;
  final String redirectUrl;

  factory InstantDoctorProductModel.fromJson(Map<String, dynamic> json) {
    return InstantDoctorProductModel(
      productId: _parseInt(json['productId']),
      productCode: (json['productCode'] ?? '').toString(),
      productType: (json['productType'] ?? '').toString(),
      productTitle: (json['productTitle'] ?? '').toString(),
      priceDisplay: (json['priceDisplay'] ?? '').toString(),
      benefits: (json['benefits'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .where((e) => e.isNotEmpty)
          .toList(),
      redirectUrl: (json['redirectUrl'] ?? '').toString(),
    );
  }
}

class InstantDoctorProviderModel {
  const InstantDoctorProviderModel({
    required this.providerId,
    required this.providerName,
    required this.logoUrl,
    required this.isSubscribed,
    required this.product,
  });

  final int providerId;
  final String providerName;
  final String? logoUrl;
  final bool isSubscribed;
  final InstantDoctorProductModel product;

  factory InstantDoctorProviderModel.fromJson(Map<String, dynamic> json) {
    final productJson = json['product'];
    return InstantDoctorProviderModel(
      providerId: _parseInt(json['providerId']),
      providerName: (json['providerName'] ?? '').toString(),
      logoUrl: json['logoUrl']?.toString(),
      isSubscribed: json['isSubscribed'] == true,
      product: productJson is Map<String, dynamic>
          ? InstantDoctorProductModel.fromJson(productJson)
          : const InstantDoctorProductModel(
              productId: 0,
              productCode: '',
              productType: '',
              productTitle: '',
              priceDisplay: '',
              benefits: [],
              redirectUrl: '',
            ),
    );
  }
}

class InstantDoctorResponseModel {
  const InstantDoctorResponseModel({
    required this.success,
    required this.message,
    required this.providers,
  });

  final bool success;
  final String message;
  final List<InstantDoctorProviderModel> providers;

  factory InstantDoctorResponseModel.fromJson(Map<String, dynamic> json) {
    return InstantDoctorResponseModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      providers: _providersFromJson(json['data']),
    );
  }

  static List<InstantDoctorProviderModel> _providersFromJson(dynamic data) {
    if (data is! List<dynamic>) return const [];

    return data
        .whereType<Map<String, dynamic>>()
        .map(InstantDoctorProviderModel.fromJson)
        .where((provider) => provider.providerName.isNotEmpty)
        .toList();
  }
}

int _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
