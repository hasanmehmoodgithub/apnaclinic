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

class LabTestViewDetailsArgs {
  const LabTestViewDetailsArgs({
    required this.testTitle,
    required this.labName,
    required this.labLogoUrl,
    required this.partnerLogoUrl,
    required this.sampleType,
    required this.discountedFee,
    required this.originalFee,
    required this.discountCode,
  });

  final String testTitle;
  final String labName;
  final String labLogoUrl;
  final String partnerLogoUrl;
  final String sampleType;
  final String discountedFee;
  final String originalFee;
  final String discountCode;
}

class LabTestCartItem {
  const LabTestCartItem({
    required this.testTitle,
    required this.city,
    required this.labId,
    required this.labDisplayName,
    required this.labLogoUrl,
    required this.partnerId,
    required this.partnerLogoUrl,
    required this.sampleType,
    this.requirementLabel,
    required this.requirementLines,
    required this.discountedFee,
    required this.originalFee,
    required this.discountPercent,
    required this.discountAmount,
    required this.discountCode,
    required this.totalAmount,
    required this.bookingMethodIsHomeSample,
  });

  final String testTitle;
  final String city;
  final String labId;
  final String labDisplayName;
  final String labLogoUrl;
  final String partnerId;
  final String partnerLogoUrl;
  final String sampleType;
  final String? requirementLabel;
  final List<String> requirementLines;
  final String discountedFee;
  final String originalFee;
  final int discountPercent;
  final String discountAmount;
  final String discountCode;
  final String totalAmount;
  final bool bookingMethodIsHomeSample;

  factory LabTestCartItem.fromJson(Map<String, dynamic> json) {
    return LabTestCartItem(
      testTitle: (json['testTitle'] ?? '').toString(),
      city: (json['city'] ?? '').toString(),
      labId: (json['labId'] ?? '').toString(),
      labDisplayName: (json['labDisplayName'] ?? '').toString(),
      labLogoUrl: (json['labLogoUrl'] ?? '').toString(),
      partnerId: (json['partnerId'] ?? '').toString(),
      partnerLogoUrl: (json['partnerLogoUrl'] ?? '').toString(),
      sampleType: (json['sampleType'] ?? '').toString(),
      requirementLabel: json['requirementLabel']?.toString(),
      requirementLines:
          (json['requirementLines'] is List
                  ? json['requirementLines'] as List<dynamic>
                  : const <dynamic>[])
              .map((e) => e.toString())
              .toList(growable: false),
      discountedFee: (json['discountedFee'] ?? '').toString(),
      originalFee: (json['originalFee'] ?? '').toString(),
      discountPercent: (json['discountPercent'] as num?)?.toInt() ?? 0,
      discountAmount: (json['discountAmount'] ?? '').toString(),
      discountCode: (json['discountCode'] ?? '').toString(),
      totalAmount: (json['totalAmount'] ?? '').toString(),
      bookingMethodIsHomeSample: json['bookingMethodIsHomeSample'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'testTitle': testTitle,
      'city': city,
      'labId': labId,
      'labDisplayName': labDisplayName,
      'labLogoUrl': labLogoUrl,
      'partnerId': partnerId,
      'partnerLogoUrl': partnerLogoUrl,
      'sampleType': sampleType,
      'requirementLabel': requirementLabel,
      'requirementLines': requirementLines,
      'discountedFee': discountedFee,
      'originalFee': originalFee,
      'discountPercent': discountPercent,
      'discountAmount': discountAmount,
      'discountCode': discountCode,
      'totalAmount': totalAmount,
      'bookingMethodIsHomeSample': bookingMethodIsHomeSample,
    };
  }

  LabTestCheckoutArgs toCheckoutArgs() {
    return LabTestCheckoutArgs(
      city: city,
      testTitle: testTitle,
      labDisplayName: labDisplayName,
      labLogoUrl: labLogoUrl,
      partnerLogoUrl: partnerLogoUrl,
      sampleType: sampleType,
      requirementLabel: requirementLabel,
      discountedFee: discountedFee,
      originalFee: originalFee,
      discountPercent: discountPercent,
      discountAmount: discountAmount,
      discountCode: discountCode,
      totalAmount: totalAmount,
      bookingMethodIsHomeSample: bookingMethodIsHomeSample,
      requirementLines: requirementLines,
    );
  }
}
