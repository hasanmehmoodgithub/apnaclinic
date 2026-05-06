class DoctorConsultationPaymentOptionModel {
  const DoctorConsultationPaymentOptionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconAsset,
  });

  final String id;
  final String title;
  final String description;
  final String iconAsset;
}

class DoctorConsultationCheckoutModel {
  const DoctorConsultationCheckoutModel({
    required this.consultationFee,
    required this.discount,
    required this.paymentOptions,
    required this.selectedPaymentMethodId,
  });

  final int consultationFee;
  final int discount;
  final List<DoctorConsultationPaymentOptionModel> paymentOptions;
  final String selectedPaymentMethodId;

  int get total => consultationFee - discount;
}
