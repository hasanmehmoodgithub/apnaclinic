import '../domain/entities/lab_test_detail_entity.dart';
import '../domain/entities/lab_test_lab_offer_entity.dart';

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
  const LabTestBookingArgs.pending({
    required this.testId,
    required this.city,
    required this.requirementLines,
    this.testTitle = '',
  })  : isPending = true,
        sampleType = '',
        requirementLabel = null,
        partners = const [],
        labOffers = const [];

  const LabTestBookingArgs({
    required this.city,
    required this.testTitle,
    required this.sampleType,
    this.requirementLabel,
    required this.requirementLines,
    required this.partners,
    required this.labOffers,
    this.testId,
  }) : isPending = false;

  factory LabTestBookingArgs.fromDetail({
    required LabTestDetailEntity detail,
    required String city,
    required List<String> requirementLines,
  }) {
    return LabTestBookingArgs(
      testId: detail.id,
      city: city,
      testTitle: detail.name,
      sampleType: detail.sampleType,
      requirementLabel: detail.fastingRequired ? 'Fasting' : null,
      requirementLines: requirementLines,
      partners: detail.partners
          .map(
            (p) => LabTestBookingPartnerOption(
              id: p.id,
              name: p.name,
              logoUrl: p.logoUrl,
            ),
          )
          .toList(growable: false),
      labOffers: detail.labOffers,
    );
  }

  final bool isPending;
  final int? testId;
  final String city;
  final String testTitle;
  final String sampleType;
  final String? requirementLabel;
  final List<String> requirementLines;
  final List<LabTestBookingPartnerOption> partners;
  final List<LabTestLabOfferEntity> labOffers;
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
    this.testIds = const <int>[],
    this.partnerId = '',
    this.labId = '',
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

  /// All test ids in the cart to book together (supports multiple tests).
  final List<int> testIds;
  final String partnerId;
  final String labId;
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
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.patientPhone,
    required this.orderNo,
    required this.bookingDate,
    required this.statusLabel,
    required this.note,
    this.invoiceUrl,
  });

  final String testTitle;
  final String labName;
  final String labLogoUrl;
  final String partnerLogoUrl;
  final String sampleType;
  final String discountedFee;
  final String originalFee;
  final String discountCode;
  final String patientName;
  final int patientAge;
  final String patientGender;
  final String patientPhone;
  final String orderNo;
  final String bookingDate;
  final String statusLabel;
  final String note;

  /// PDF URL from API `invoice` field; empty/null hides the invoice card.
  final String? invoiceUrl;
}
