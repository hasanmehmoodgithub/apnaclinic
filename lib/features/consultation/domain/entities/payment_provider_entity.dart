class PaymentProviderEntity {
  const PaymentProviderEntity({
    required this.name,
    required this.code,
    required this.iconUrl,
    this.subtitle = '',
    this.label = '',
    this.labelColor = '',
    this.termsTitle = '',
    this.termsDescription = '',
  });

  final String name;
  final String code;
  final String iconUrl;
  final String subtitle;
  final String label;
  final String labelColor;
  final String termsTitle;
  final String termsDescription;

  String get displayTitle => name.trim();

  String get displaySubtitle {
    final value = subtitle.trim();
    if (value.isEmpty) return '';
    if (value.toLowerCase() == displayTitle.toLowerCase()) return '';
    return value;
  }

  String get displayLabel => label.trim();

  String get displayLabelColor => labelColor.trim();

  String get displayTermsTitle => termsTitle.trim();

  String get displayTermsDescription => termsDescription.trim();

  bool get hasTerms =>
      displayTermsTitle.isNotEmpty || displayTermsDescription.isNotEmpty;
}
