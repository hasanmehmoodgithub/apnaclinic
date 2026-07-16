class LabTestBookingTestItem {
  const LabTestBookingTestItem({
    required this.name,
    required this.price,
    required this.status,
  });

  final String name;
  final int price;
  final String status;
}

class LabTestBookingItemModel {
  const LabTestBookingItemModel({
    required this.orderId,
    required this.publicId,
    required this.orderType,
    required this.reportTitle,
    required this.statusLabel,
    required this.reportStatus,
    required this.paymentMethod,
    required this.isConfirmed,
    required this.totalFee,
    required this.discountedFee,
    required this.originalFee,
    required this.dateLabel,
    required this.labName,
    required this.labLogoUrl,
    required this.partnerName,
    required this.partnerLogoUrl,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.patientPhone,
    required this.tests,
    required this.discountCode,
  });

  final String orderId;
  final String publicId;
  final String orderType;
  final String reportTitle;
  final String statusLabel;
  final String reportStatus;
  final String paymentMethod;
  final bool isConfirmed;
  final String totalFee;
  final String discountedFee;
  final String originalFee;
  final String dateLabel;
  final String labName;
  final String labLogoUrl;
  final String partnerName;
  final String partnerLogoUrl;
  final String patientName;
  final int patientAge;
  final String patientGender;
  final String patientPhone;
  final List<LabTestBookingTestItem> tests;
  final String? discountCode;

  /// Order number shown on cards, e.g. `85048960`.
  String get orderNo => orderId.isNotEmpty ? orderId : publicId;
}
