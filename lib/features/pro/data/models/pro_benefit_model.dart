class ProBenefitModel {
  const ProBenefitModel({
    required this.key,
    required this.title,
    required this.basicValue,
    required this.proValue,
    required this.highlightPro,
  });

  final String key;
  final String title;
  final String basicValue;
  final String proValue;
  final bool highlightPro;

  factory ProBenefitModel.fromJson(Map<String, dynamic> json) {
    return ProBenefitModel(
      key: (json['key'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      basicValue: (json['basicValue'] ?? json['basic_value'] ?? '').toString(),
      proValue: (json['proValue'] ?? json['pro_value'] ?? '').toString(),
      highlightPro: json['highlightPro'] == true ||
          json['highlight_pro'] == true,
    );
  }
}
