class LabTestViewDetailsData {
  const LabTestViewDetailsData({
    required this.patientName,
    required this.orderNo,
    required this.bookingDate,
    required this.status,
    required this.note,
  });

  final String patientName;
  final String orderNo;
  final String bookingDate;
  final String status;
  final String note;

  factory LabTestViewDetailsData.fromMap(Map<String, dynamic> map) {
    return LabTestViewDetailsData(
      patientName: (map['patientName'] ?? '').toString(),
      orderNo: (map['orderNo'] ?? '').toString(),
      bookingDate: (map['bookingDate'] ?? '').toString(),
      status: (map['status'] ?? '').toString(),
      note: (map['note'] ?? '').toString(),
    );
  }
}
