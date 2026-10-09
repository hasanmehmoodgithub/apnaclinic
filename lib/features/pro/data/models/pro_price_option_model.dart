class ProPriceOptionModel {
  const ProPriceOptionModel({
    required this.code,
    required this.title,
    required this.durationLabel,
    required this.durationDays,
    required this.amount,
    required this.currency,
  });

  final String code;
  final String title;
  final String durationLabel;
  final int durationDays;
  final String amount;
  final String currency;

  factory ProPriceOptionModel.fromJson(Map<String, dynamic> json) {
    final daysRaw = json['durationDays'] ?? json['duration_days'];
    return ProPriceOptionModel(
      code: (json['code'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      durationLabel:
          (json['durationLabel'] ?? json['duration_label'] ?? '').toString(),
      durationDays: daysRaw is num
          ? daysRaw.toInt()
          : int.tryParse(daysRaw?.toString() ?? '') ?? 0,
      amount: (json['amount'] ?? '').toString(),
      currency: (json['currency'] ?? 'PKR').toString(),
    );
  }
}
