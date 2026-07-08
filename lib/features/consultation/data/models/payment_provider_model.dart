class PaymentProviderModel {
  const PaymentProviderModel({
    required this.name,
    required this.code,
    required this.isActive,
    required this.iconUrl,
  });

  final String name;
  final String code;
  final bool isActive;
  final String iconUrl;

  factory PaymentProviderModel.fromJson(Map<String, dynamic> json) {
    return PaymentProviderModel(
      name: (json['name'] ?? '').toString().trim(),
      code: (json['code'] ?? '').toString().trim().toUpperCase(),
      isActive: json['isActive'] == true,
      iconUrl: (json['iconUrl'] ?? json['icon_url'] ?? '').toString().trim(),
    );
  }
}

class PaymentProvidersResponseModel {
  const PaymentProvidersResponseModel({
    required this.providers,
  });

  final List<PaymentProviderModel> providers;

  factory PaymentProvidersResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final rawProviders = data is List ? data : const <dynamic>[];

    final providers = rawProviders
        .whereType<Map<String, dynamic>>()
        .map(PaymentProviderModel.fromJson)
        .where(
          (provider) =>
              provider.isActive &&
              provider.code.isNotEmpty &&
              provider.name.isNotEmpty,
        )
        .toList(growable: false);

    return PaymentProvidersResponseModel(providers: providers);
  }
}
