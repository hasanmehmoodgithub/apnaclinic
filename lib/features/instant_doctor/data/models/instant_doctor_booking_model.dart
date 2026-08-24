class InstantDoctorBookingItemModel {
  const InstantDoctorBookingItemModel({
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

  factory InstantDoctorBookingItemModel.fromJson(Map<String, dynamic> json) {
    return InstantDoctorBookingItemModel(
      orderId: _asString(json['orderId'] ?? json['order_id']),
      status: _asString(json['status']),
      createdAt: _asString(json['createdAt'] ?? json['created_at']),
      bookingAt: _asString(json['bookingAt'] ?? json['booking_at']),
      imageUrl: _asString(json['imageUrl'] ?? json['image_url']),
      doctorName: _asString(json['doctorName'] ?? json['doctor_name']),
      specialty: _asString(json['specialty'] ?? json['speciality']),
      fee: _asDouble(json['fee']) ?? 0,
      currency: _asString(json['currency'], fallback: 'PKR'),
      partnerId: _asInt(json['partnerId'] ?? json['partner_id']) ?? 0,
      partnerName: _asString(json['partnerName'] ?? json['partner_name']),
      partnerImageUrl: _asString(
        json['partnerImageUrl'] ?? json['partner_image_url'],
      ),
      prescription: _asPrescription(json['prescription']),
    );
  }

  static String _asString(Object? value, {String fallback = ''}) {
    if (value == null) return fallback;
    final text = value.toString().trim();
    return text.isEmpty ? fallback : text;
  }

  static int? _asInt(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString().trim());
  }

  static double? _asDouble(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().trim());
  }

  static String _asPrescription(Object? value) {
    if (value == null) return '';
    if (value is List) {
      return value
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .join('\n');
    }
    return value.toString().trim();
  }
}

class InstantDoctorBookingsPageModel {
  const InstantDoctorBookingsPageModel({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
  });

  final List<InstantDoctorBookingItemModel> items;
  final int page;
  final int limit;
  final int total;

  factory InstantDoctorBookingsPageModel.fromJson(Map<String, dynamic> json) {
    final root = json['data'];
    Map<String, dynamic> payload;
    if (root is Map) {
      payload = Map<String, dynamic>.from(root);
    } else {
      payload = json;
    }

    final listRaw = payload['data'] ??
        payload['bookings'] ??
        payload['items'] ??
        (root is List ? root : null);

    final items = (listRaw is List ? listRaw : const <dynamic>[])
        .whereType<Map>()
        .map(
          (item) => InstantDoctorBookingItemModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .where(
          (item) =>
              item.orderId.isNotEmpty ||
              item.doctorName.isNotEmpty ||
              item.partnerName.isNotEmpty,
        )
        .toList(growable: false);

    return InstantDoctorBookingsPageModel(
      items: items,
      page: InstantDoctorBookingItemModel._asInt(payload['page']) ?? 1,
      limit: InstantDoctorBookingItemModel._asInt(payload['limit']) ??
          items.length,
      total: InstantDoctorBookingItemModel._asInt(payload['total']) ??
          items.length,
    );
  }
}
