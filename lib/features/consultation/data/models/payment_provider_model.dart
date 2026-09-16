class PaymentProviderModel {
  const PaymentProviderModel({
    required this.name,
    required this.code,
    required this.isActive,
    required this.iconUrl,
    this.subtitle = '',
    this.label = '',
    this.labelColor = '',
    this.termsTitle = '',
    this.termsDescription = '',
  });

  final String name;
  final String code;
  final bool isActive;
  final String iconUrl;
  final String subtitle;
  final String label;
  final String labelColor;
  final String termsTitle;
  final String termsDescription;

  factory PaymentProviderModel.fromJson(Map<String, dynamic> json) {
    final label = _readLabel(json['label']);
    final terms = _readTerms(
      json['termsAndCondition'] ??
          json['terms_and_condition'] ??
          json['termsAndConditions'],
    );
    return PaymentProviderModel(
      name: _readString(json, const ['title', 'name']),
      code: _readString(json, const ['code']).toUpperCase(),
      isActive: _readIsActive(json),
      iconUrl: _readString(json, const ['logo', 'iconUrl', 'icon_url']),
      subtitle: _readString(json, const ['subtitle']),
      label: label.$1,
      labelColor: label.$2,
      termsTitle: terms.$1,
      termsDescription: terms.$2,
    );
  }

  static (String, String) _readLabel(dynamic value) {
    if (value == null) return ('', '');
    if (value is String) return (_clean(value), '');
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      return (
        _clean(map['text'] ?? map['label'] ?? map['title']),
        _clean(map['color'] ?? map['bgColor'] ?? map['backgroundColor']),
      );
    }
    return ('', '');
  }

  static (String, String) _readTerms(dynamic value) {
    if (value == null) return ('', '');
    if (value is String) return ('', _clean(value));
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      return (
        _clean(map['title']),
        _clean(map['description'] ?? map['body'] ?? map['text']),
      );
    }
    return ('', '');
  }

  static String _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final text = _clean(json[key]);
      if (text.isNotEmpty) return text;
    }
    return '';
  }

  static String _clean(dynamic value) {
    if (value == null) return '';
    final text = value.toString().trim();
    if (text.isEmpty || text.toLowerCase() == 'null') return '';
    return text;
  }

  static bool _readIsActive(Map<String, dynamic> json) {
    final value = json['isActive'] ?? json['is_active'];
    if (value == null) return true;
    if (value is bool) return value;
    final text = value.toString().trim().toLowerCase();
    if (text.isEmpty) return true;
    return text == 'true' || text == '1';
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
