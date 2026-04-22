class LabTestBookingItemModel {
  const LabTestBookingItemModel({
    required this.orderNo,
    required this.reportTitle,
    required this.statusLabel,
    required this.totalFee,
    required this.dateLabel,
    required this.isConfirmed,
  });

  final String orderNo;
  final String reportTitle;
  final String statusLabel;
  final String totalFee;
  final String dateLabel;
  final bool isConfirmed;

  factory LabTestBookingItemModel.fromJson(Map<String, dynamic> json) {
    return LabTestBookingItemModel(
      orderNo: (json['orderNo'] ?? '').toString(),
      reportTitle: (json['reportTitle'] ?? '').toString(),
      statusLabel: (json['statusLabel'] ?? '').toString(),
      totalFee: (json['totalFee'] ?? '').toString(),
      dateLabel: (json['dateLabel'] ?? '').toString(),
      isConfirmed: json['isConfirmed'] == true,
    );
  }
}
