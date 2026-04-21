class LabTestBookingPartnerOption {
  const LabTestBookingPartnerOption({
    required this.id,
    required this.name,
    required this.logoUrl,
  });

  final String id;
  final String name;
  final String logoUrl;
}

class LabTestBookingVendorOption {
  const LabTestBookingVendorOption({
    required this.id,
    required this.name,
    required this.logoUrl,
    this.markUrl,
  });

  final String id;
  final String name;
  final String logoUrl;
  final String? markUrl;
}

class LabTestBookingArgs {
  const LabTestBookingArgs({
    required this.city,
    required this.testTitle,
    required this.sampleType,
    this.requirementLabel,
    required this.requirementLines,
    required this.partners,
    required this.vendors,
    required this.discountedFee,
    required this.originalFee,
    required this.discountPercent,
    required this.discountAmount,
    required this.discountCode,
    required this.totalAmount,
  });

  final String city;
  final String testTitle;
  final String sampleType;
  final String? requirementLabel;
  final List<String> requirementLines;
  final List<LabTestBookingPartnerOption> partners;
  final List<LabTestBookingVendorOption> vendors;
  final String discountedFee;
  final String originalFee;
  final int discountPercent;
  final String discountAmount;
  final String discountCode;
  final String totalAmount;
}

class LabTestCheckoutArgs {
  const LabTestCheckoutArgs({
    required this.city,
    required this.testTitle,
    required this.labDisplayName,
    required this.labLogoUrl,
    required this.partnerLogoUrl,
    required this.sampleType,
    this.requirementLabel,
    required this.discountedFee,
    required this.originalFee,
    required this.discountPercent,
    required this.discountAmount,
    required this.discountCode,
    required this.totalAmount,
    this.bookingMethodIsHomeSample = false,
    required this.requirementLines,
  });

  final String city;
  final String testTitle;
  final String labDisplayName;
  final String labLogoUrl;
  final String partnerLogoUrl;
  final String sampleType;
  final String? requirementLabel;
  final String discountedFee;
  final String originalFee;
  final int discountPercent;
  final String discountAmount;
  final String discountCode;
  final String totalAmount;
  final bool bookingMethodIsHomeSample;
  final List<String> requirementLines;
}
