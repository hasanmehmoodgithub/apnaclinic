class InstantDoctorBookingEntity {
  const InstantDoctorBookingEntity({
    required this.orderId,
    required this.status,
    required this.createdAt,
    required this.bookingAt,
    required this.imageUrl,
    required this.doctorName,
    required this.specialty,
    required this.fee,
    required this.currency,
    required this.partnerId,
    required this.partnerName,
    required this.partnerImageUrl,
    required this.prescription,
    this.prescriptionUrl = '',
    required this.listDate,
    required this.feeLabel,
  });

  final String orderId;
  final String status;
  final String createdAt;
  final String bookingAt;
  final String imageUrl;
  final String doctorName;
  final String specialty;
  final double fee;
  final String currency;
  final int partnerId;
  final String partnerName;
  final String partnerImageUrl;
  final String prescription;
  final String prescriptionUrl;
  final String listDate;
  final String feeLabel;

  bool get isFree => fee <= 0;

  String get displayDoctorName =>
      doctorName.trim().isNotEmpty ? doctorName.trim() : partnerName.trim();

  String get photoUrl {
    final image = imageUrl.trim();
    if (image.isNotEmpty) return image;
    return partnerImageUrl.trim();
  }

  List<String> get prescriptionLines => prescription
      .split(RegExp(r'[\r\n]+'))
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList(growable: false);

  bool get hasPrescriptionText => prescriptionLines.isNotEmpty;

  bool get hasPrescriptionUrl {
    final url = prescriptionUrl.trim();
    if (url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  bool get hasPrescription => hasPrescriptionText || hasPrescriptionUrl;
}

class InstantDoctorBookingsPageEntity {
  const InstantDoctorBookingsPageEntity({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
  });

  final List<InstantDoctorBookingEntity> items;
  final int page;
  final int limit;
  final int total;

  bool get hasMore => page * limit < total;
}
