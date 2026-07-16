/// Persisted lab test cart line (shared by booking and cart screens).
class LabTestCartItem {
  const LabTestCartItem({
    required this.testId,
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

  final int testId;
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
      testId: (json['testId'] as num?)?.toInt() ?? 0,
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
      'testId': testId,
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
}
