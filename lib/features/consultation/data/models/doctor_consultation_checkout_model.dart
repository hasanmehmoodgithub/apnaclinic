import '../../domain/entities/payment_provider_entity.dart';

class DoctorConsultationPaymentOptionModel {
  const DoctorConsultationPaymentOptionModel({
    required this.code,
    required this.name,
    required this.iconUrl,
    this.subtitle = '',
    this.label = '',
    this.labelColor = '',
    this.termsTitle = '',
    this.termsDescription = '',
  });

  factory DoctorConsultationPaymentOptionModel.fromProvider(
    PaymentProviderEntity provider,
  ) {
    return DoctorConsultationPaymentOptionModel(
      code: provider.code,
      name: provider.name,
      iconUrl: provider.iconUrl,
      subtitle: provider.subtitle,
      label: provider.label,
      labelColor: provider.labelColor,
      termsTitle: provider.termsTitle,
      termsDescription: provider.termsDescription,
    );
  }

  final String code;
  final String name;
  final String iconUrl;
  final String subtitle;
  final String label;
  final String labelColor;
  final String termsTitle;
  final String termsDescription;

  String get displaySubtitle {
    final value = subtitle.trim();
    if (value.isEmpty) return '';
    if (value.toLowerCase() == name.trim().toLowerCase()) return '';
    return value;
  }

  String get displayLabel => label.trim();

  String get displayLabelColor => labelColor.trim();

  String get displayTermsTitle => termsTitle.trim();

  String get displayTermsDescription => termsDescription.trim();

  bool get hasTerms =>
      displayTermsTitle.isNotEmpty || displayTermsDescription.isNotEmpty;
}

class DoctorConsultationCheckoutModel {
  const DoctorConsultationCheckoutModel({
    required this.consultationFee,
    required this.discount,
    required this.paymentOptions,
  });

  final int consultationFee;
  final int discount;
  final List<DoctorConsultationPaymentOptionModel> paymentOptions;

  int get total => consultationFee - discount;
}
