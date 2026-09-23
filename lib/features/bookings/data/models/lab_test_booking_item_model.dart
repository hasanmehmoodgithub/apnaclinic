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

enum LabTestBookingStatusKind {
  pending,
  confirmed,
  failed;

  static LabTestBookingStatusKind fromStatus(String raw) {
    final normalized = raw
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
        .trim();
    if (normalized.contains('cancel') ||
        normalized.contains('reject') ||
        normalized.contains('fail')) {
      return LabTestBookingStatusKind.failed;
    }
    if (normalized.contains('pending') ||
        normalized == 'placed' ||
        normalized.contains('unpaid') ||
        normalized.contains('awaiting')) {
      return LabTestBookingStatusKind.pending;
    }
    if (normalized.contains('confirm') ||
        normalized.contains('ready') ||
        normalized.contains('available') ||
        normalized == 'completed' ||
        normalized == 'paid') {
      return LabTestBookingStatusKind.confirmed;
    }
    return LabTestBookingStatusKind.pending;
  }
}

class LabTestBookingItemModel {
  const LabTestBookingItemModel({
    required this.orderId,
    required this.publicId,
    required this.orderType,
    required this.sampleType,
    required this.reportTitle,
    required this.statusLabel,
    required this.reportStatus,
    required this.paymentMethod,
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
    this.partnerRef,
    this.invoice,
  });

  final String orderId;
  final String publicId;
  /// API `orderType`: `WALK_IN` / `HOME_SAMPLING`.
  final String orderType;
  /// API biological `sampleType` (e.g. Blood, Urine).
  final String sampleType;
  final String reportTitle;
  final String statusLabel;
  final String reportStatus;
  final String paymentMethod;
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
  final String? partnerRef;
  final String? invoice;

  /// Order number shown on cards, e.g. `85048960`.
  String get orderNo => orderId.isNotEmpty ? orderId : publicId;

  /// Code shown to lab staff: discount code, partner ref, or order id.
  String get displayCode =>
      (discountCode?.trim().isNotEmpty == true
          ? discountCode!.trim()
          : null) ??
      (partnerRef?.trim().isNotEmpty == true ? partnerRef!.trim() : null) ??
      orderNo;
}
