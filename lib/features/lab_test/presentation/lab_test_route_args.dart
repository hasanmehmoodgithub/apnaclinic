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
  }) : isPending = true,
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

/// One cart test shown on checkout (Payment Details) before the totals card.
class LabTestCheckoutLineArgs {
  const LabTestCheckoutLineArgs({
    required this.testTitle,
    required this.labDisplayName,
    required this.labLogoUrl,
    required this.partnerLogoUrl,
    required this.sampleType,
    required this.discountedFee,
    required this.originalFee,
    required this.bookingMethodIsHomeSample,
  });

  final String testTitle;
  final String labDisplayName;
  final String labLogoUrl;
  final String partnerLogoUrl;
  final String sampleType;
  final String discountedFee;
  final String originalFee;
  final bool bookingMethodIsHomeSample;
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
    this.lines = const <LabTestCheckoutLineArgs>[],
  });

  final String city;
  final String testTitle;
  final String labDisplayName;
  final String labLogoUrl;
  final String partnerLogoUrl;
  final String sampleType;
  final String? requirementLabel;

  /// Aggregated discounted total across [lines] (shown as Payment Details Total).
  final String discountedFee;

  /// Aggregated original fee across [lines] (shown as Payment Details Fee).
  final String originalFee;
  final int discountPercent;

  /// Aggregated discount amount across [lines].
  final String discountAmount;
  final String discountCode;
  final String totalAmount;
  final bool bookingMethodIsHomeSample;
  final List<String> requirementLines;

  /// All test ids in the cart to book together (supports multiple tests).
  final List<int> testIds;
  final String partnerId;
  final String labId;

  /// Every cart test to render above the payment breakdown.
  final List<LabTestCheckoutLineArgs> lines;
}

class LabTestViewDetailsArgs {
  const LabTestViewDetailsArgs({required this.orderId});

  /// Lab order id for `GET /lab-orders/{id}`.
  final String orderId;
}

class LabTestReportViewerArgs {
  const LabTestReportViewerArgs({required this.filePath, this.title});

  final String filePath;
  final String? title;
}

class LabTestViewDetailsTestLine {
  const LabTestViewDetailsTestLine({
    required this.name,
    required this.fee,
    required this.status,
  });

  final String name;
  final String fee;
  final String status;
}

/// Mapped UI model for the view-details screen (built from order detail API).
class LabTestViewDetailsContent {
  const LabTestViewDetailsContent({
    required this.testTitle,
    required this.tests,
    required this.labName,
    required this.labLogoUrl,
    required this.partnerLogoUrl,
    required this.sampleType,
    required this.discountedFee,
    required this.originalFee,
    this.discountCode,
    required this.patientName,
    required this.orderId,
    required this.orderNo,
    required this.bookingDate,
    required this.statusLabel,
    required this.note,
    this.invoiceUrl,
    this.reportUrls = const [],
  });

  final String testTitle;
  final List<LabTestViewDetailsTestLine> tests;
  final String labName;
  final String labLogoUrl;
  final String partnerLogoUrl;
  final String sampleType;
  final String discountedFee;
  final String originalFee;

  /// API `discountCode` only; null/empty hides the discount strip.
  final String? discountCode;
  final String patientName;
  final String orderId;
  final String orderNo;
  final String bookingDate;
  final String statusLabel;
  final String note;
  final String? invoiceUrl;
  final List<String> reportUrls;

  bool get canDownloadReport => reportUrls.isNotEmpty;
}
