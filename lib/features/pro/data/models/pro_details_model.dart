import 'pro_benefit_model.dart';
import 'pro_price_option_model.dart';

/// `GET /acs-aggregator/api/v1/mobile/pro/details` → `data`.
class ProDetailsModel {
  const ProDetailsModel({
    required this.isActive,
    required this.planCode,
    required this.planName,
    required this.status,
    required this.renewsOn,
    required this.bannerUrl,
    required this.title,
    required this.subtitle,
    required this.priceOptions,
    required this.benefits,
  });

  final bool isActive;
  final String? planCode;
  final String? planName;
  final String? status;
  final String? renewsOn;
  final String? bannerUrl;
  final String title;
  final String subtitle;
  final List<ProPriceOptionModel> priceOptions;
  final List<ProBenefitModel> benefits;

  factory ProDetailsModel.fromJson(Map<String, dynamic> json) {
    final optionsRaw = json['priceOptions'] ?? json['price_options'];
    final benefitsRaw = json['benefits'];
    return ProDetailsModel(
      isActive: json['isActive'] == true,
      planCode: _nullable(json['planCode']),
      planName: _nullable(json['planName']),
      status: _nullable(json['status']),
      renewsOn: _nullable(json['renewsOn']),
      bannerUrl: _nullableUrl(json['bannerUrl']),
      title: (json['title'] ?? '').toString(),
      subtitle: (json['subtitle'] ?? '').toString(),
      priceOptions: optionsRaw is List
          ? optionsRaw
              .whereType<Map>()
              .map(
                (e) => ProPriceOptionModel.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList()
          : const [],
      benefits: benefitsRaw is List
          ? benefitsRaw
              .whereType<Map>()
              .map(
                (e) => ProBenefitModel.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList()
          : const [],
    );
  }

  static String? _nullable(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static String? _nullableUrl(Object? value) {
    final text = _nullable(value);
    if (text == null) return null;
    if (!text.startsWith('http://') && !text.startsWith('https://')) {
      return null;
    }
    return text;
  }
}
