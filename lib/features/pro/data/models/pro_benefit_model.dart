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
    final proValue =
        (json['proValue'] ?? json['pro_value'] ?? json['pro'] ?? '').toString();
    final hasHighlightFlag =
        json.containsKey('highlightPro') || json.containsKey('highlight_pro');
    return ProBenefitModel(
      key: (json['key'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      basicValue: (json['basicValue'] ?? json['basic_value'] ?? json['basic'] ?? '')
          .toString(),
      proValue: proValue,
      highlightPro: hasHighlightFlag
          ? (json['highlightPro'] == true || json['highlight_pro'] == true)
          : proValue.trim().isNotEmpty,
    );
  }
}
