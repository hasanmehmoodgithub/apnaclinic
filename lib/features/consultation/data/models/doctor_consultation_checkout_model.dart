class DoctorConsultationPaymentOptionModel {
  const DoctorConsultationPaymentOptionModel({
    required this.code,
    required this.name,
    required this.iconUrl,
  });

  final String code;
  final String name;
  final String iconUrl;
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
