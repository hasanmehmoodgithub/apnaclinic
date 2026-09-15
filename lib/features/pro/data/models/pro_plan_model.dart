class ProPlanModel {
  const ProPlanModel({
    required this.planId,
    required this.price,
    required this.currency,
    required this.currencySymbol,
    required this.durationValue,
    required this.durationUnit,
    required this.priceDisplay,
    required this.durationDisplay,
    required this.isRecommended,
    required this.isCurrent,
  });

  final String planId;
  final double price;
  final String currency;
  final String currencySymbol;
  final int durationValue;
  final String durationUnit;
  final String priceDisplay;
  final String durationDisplay;
  final bool isRecommended;
  final bool isCurrent;

  factory ProPlanModel.fromJson(Map<String, dynamic> json) {
    final priceRaw = json['price'];
    final durationRaw = json['durationValue'] ?? json['duration_value'];
    return ProPlanModel(
      planId: (json['planId'] ?? json['plan_id'] ?? '').toString(),
      price: priceRaw is num
          ? priceRaw.toDouble()
          : double.tryParse(priceRaw?.toString() ?? '') ?? 0,
      currency: (json['currency'] ?? 'PKR').toString(),
      currencySymbol:
          (json['currencySymbol'] ?? json['currency_symbol'] ?? 'Rs.')
              .toString(),
      durationValue: durationRaw is num
          ? durationRaw.toInt()
          : int.tryParse(durationRaw?.toString() ?? '') ?? 0,
      durationUnit:
          (json['durationUnit'] ?? json['duration_unit'] ?? '').toString(),
      priceDisplay:
          (json['priceDisplay'] ?? json['price_display'] ?? '').toString(),
      durationDisplay:
          (json['durationDisplay'] ?? json['duration_display'] ?? '')
              .toString(),
      isRecommended: json['isRecommended'] == true ||
          json['is_recommended'] == true,
      isCurrent:
          json['isCurrent'] == true || json['is_current'] == true,
    );
  }
}
