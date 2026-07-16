class LabOrderTestEntity {
  const LabOrderTestEntity({
    required this.name,
    required this.price,
    required this.status,
  });

  final String name;
  final int price;
  final String status;
}

class LabOrderPricingEntity {
  const LabOrderPricingEntity({
    required this.subtotal,
    required this.discount,
    required this.homeSamplingFee,
    required this.total,
    required this.currency,
  });

  final int subtotal;
  final int discount;
  final int homeSamplingFee;
  final int total;
  final String currency;
}

class LabOrderEntity {
  const LabOrderEntity({
    required this.orderId,
    required this.publicId,
    required this.orderType,
    required this.status,
    required this.reportStatus,
    required this.paymentMethod,
    required this.discountCode,
    required this.labName,
    required this.labLogoUrl,
    required this.partnerName,
    required this.partnerLogoUrl,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.patientPhone,
    required this.tests,
    required this.pricing,
    required this.reports,
    required this.placedAt,
    required this.createdAt,
  });

  final String orderId;
  final String publicId;
  final String orderType;
  final String status;
  final String reportStatus;
  final String paymentMethod;
  final String? discountCode;
  final String labName;
  final String labLogoUrl;
  final String partnerName;
  final String partnerLogoUrl;
  final String patientName;
  final int patientAge;
  final String patientGender;
  final String patientPhone;
  final List<LabOrderTestEntity> tests;
  final LabOrderPricingEntity pricing;
  final List<String> reports;
  final String placedAt;
  final String createdAt;
}

class LabOrdersPageEntity {
  const LabOrdersPageEntity({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
  });

  final List<LabOrderEntity> items;
  final int page;
  final int limit;
  final int total;

  bool get hasMore => items.length + ((page - 1) * limit) < total;
}
