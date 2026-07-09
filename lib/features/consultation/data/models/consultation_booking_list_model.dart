import '../../domain/entities/consultation_booking_list_entity.dart';

class ConsultationBookingListItemModel {
  const ConsultationBookingListItemModel({
    required this.bookingId,
    required this.status,
    required this.slotDate,
    required this.slotStartTime,
    required this.slotEndTime,
    required this.consultationFee,
    required this.discountAmount,
    required this.patientRelation,
    required this.issue,
    required this.doctorName,
    required this.specialty,
    required this.yearsOfExperience,
    required this.qualifications,
    required this.education,
    required this.doctorImageUrl,
    required this.consultationLink,
  });

  final String bookingId;
  final String status;
  final String slotDate;
  final String slotStartTime;
  final String slotEndTime;
  final int consultationFee;
  final int discountAmount;
  final String patientRelation;
  final String issue;
  final String doctorName;
  final String specialty;
  final int? yearsOfExperience;
  final List<String> qualifications;
  final String education;
  final String doctorImageUrl;
  final String consultationLink;

  factory ConsultationBookingListItemModel.fromJson(Map<String, dynamic> json) {
    final doctor = _resolveDoctor(json);
    final qualificationsRaw =
        doctor?['qualifications'] ?? json['qualifications'];
    final fees = _resolveFees(doctor, json);
    final doctorId = _readString(
      json,
      const ['doctorId', 'doctor_id'],
      nested: doctor,
      nestedKeys: const ['doctorid', 'doctorId', 'doctor_id', 'id'],
    );

    return ConsultationBookingListItemModel(
      bookingId: _resolveBookingId(
        json: json,
        doctorId: doctorId,
      ),
      status: _readString(json, const [
        'status',
        'bookingStatus',
        'booking_status',
        'success',
      ]),
      slotDate: _readString(json, const [
        'slotDate',
        'slot_date',
        'appointmentDate',
        'appointment_date',
      ]),
      slotStartTime: _readString(json, const [
        'slotStartTime',
        'slot_start_time',
        'startTime',
        'start_time',
      ]),
      slotEndTime: _readString(json, const [
        'slotEndTime',
        'slot_end_time',
        'endTime',
        'end_time',
      ]),
      consultationFee: fees.$1,
      discountAmount: fees.$2,
      patientRelation: _readString(json, const [
        'patientRelation',
        'patient_relation',
        'relation',
      ]),
      issue: _readString(json, const [
        'issue',
        'issueDescription',
        'issue_description',
        'chiefComplaint',
        'chief_complaint',
        'reason',
        'description',
      ]),
      doctorName: _readString(json, const [
        'doctorName',
        'doctor_name',
      ], nested: doctor, nestedKeys: const [
        'displayName',
        'name',
      ]),
      specialty: _readString(json, const [
        'specialty',
        'specialtyName',
        'specialty_name',
      ], nested: doctor, nestedKeys: const [
        'specialtyName',
        'specialty',
      ]),
      yearsOfExperience: _readNullableInt(
        doctor?['yearsOfExperience'] ?? json['yearsOfExperience'],
      ),
      qualifications: (qualificationsRaw is List ? qualificationsRaw : const [])
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList(growable: false),
      education: _readString(
        json,
        const ['education'],
        nested: doctor,
        nestedKeys: const ['education'],
      ),
      doctorImageUrl: _readString(json, const [
        'doctorImageUrl',
        'doctor_image_url',
        'profileImageUrl',
        'profile_image_url',
        'imageUrl',
        'image',
      ], nested: doctor, nestedKeys: const [
        'profileImageUrl',
        'profile_image_url',
        'imageUrl',
        'image',
      ]),
      consultationLink: _readString(json, const [
        'consultationLink',
        'consultation_link',
      ]),
    );
  }

  ConsultationBookingListItemEntity toEntity() {
    return ConsultationBookingListItemEntity(
      bookingId: bookingId,
      status: status,
      slotDate: slotDate,
      slotStartTime: slotStartTime,
      slotEndTime: slotEndTime,
      consultationFee: consultationFee,
      discountAmount: discountAmount,
      patientRelation: patientRelation,
      issue: issue,
      doctorName: doctorName,
      specialty: specialty,
      yearsOfExperience: yearsOfExperience,
      qualifications: qualifications,
      education: education,
      doctorImageUrl: doctorImageUrl,
      consultationLink: consultationLink,
    );
  }

  static Map<String, dynamic>? _resolveDoctor(Map<String, dynamic> json) {
    for (final key in const ['doctorInfo', 'doctor', 'doctor_info']) {
      final value = json[key];
      if (value is Map<String, dynamic>) return value;
    }
    return null;
  }

  static String _resolveBookingId({
    required Map<String, dynamic> json,
    required String doctorId,
  }) {
    final explicitId = _readString(json, const [
      'id',
      'bookingId',
      'booking_id',
      'publicId',
      'public_id',
    ]);
    if (explicitId.isNotEmpty) return explicitId;

    final consultationLink = _readString(json, const [
      'consultationLink',
      'consultation_link',
    ]);
    if (consultationLink.isNotEmpty) {
      final uri = Uri.tryParse(consultationLink);
      final lastSegment = uri?.pathSegments.isNotEmpty == true
          ? uri!.pathSegments.last
          : '';
      if (lastSegment.isNotEmpty) return lastSegment;
      return consultationLink;
    }

    final slotDate = _readString(json, const ['slotDate', 'slot_date']);
    final slotStartTime =
        _readString(json, const ['slotStartTime', 'slot_start_time']);
    if (doctorId.isNotEmpty && slotDate.isNotEmpty && slotStartTime.isNotEmpty) {
      return '${doctorId}_${slotDate}_$slotStartTime';
    }

    return '';
  }

  static (int payable, int discount) _resolveFees(
    Map<String, dynamic>? doctor,
    Map<String, dynamic> json,
  ) {
    if (doctor != null) {
      if (doctor['isFree'] == true) {
        final original = _readDouble(doctor['consultationFee']).round();
        return (0, original);
      }

      final original = _readDouble(doctor['consultationFee']);
      final discountPercent = _readDouble(doctor['discountPercent']);
      if (original > 0) {
        if (discountPercent <= 0) {
          return (original.round(), 0);
        }
        final discount = (original * discountPercent / 100).round();
        return ((original - discount).round(), discount);
      }
    }

    return (
      _readInt(json, const [
        'consultationFee',
        'consultation_fee',
        'fee',
        'payableAmount',
        'payable_amount',
      ]),
      _readInt(json, const [
        'discountAmount',
        'discount_amount',
        'discount',
      ]),
    );
  }

  static String _readString(
    Map<String, dynamic> json,
    List<String> keys, {
    Map<String, dynamic>? nested,
    List<String> nestedKeys = const [],
  }) {
    for (final key in keys) {
      final value = json[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }

    if (nested != null) {
      for (final key in nestedKeys) {
        final value = nested[key];
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString().trim();
        }
      }
    }

    return '';
  }

  static int _readInt(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value == null) continue;
      if (value is num) return value.round();
      final parsed = int.tryParse(value.toString());
      if (parsed != null) return parsed;
      final asDouble = double.tryParse(value.toString());
      if (asDouble != null) return asDouble.round();
    }
    return 0;
  }

  static double _readDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  static int? _readNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }
}

class ConsultationBookingsPageModel {
  const ConsultationBookingsPageModel({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
  });

  final List<ConsultationBookingListItemModel> items;
  final int page;
  final int limit;
  final int total;

  factory ConsultationBookingsPageModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final Map<String, dynamic>? pageData =
        data is Map<String, dynamic> ? data : null;
    final rawItems = pageData?['data'] is List
        ? pageData!['data'] as List<dynamic>
        : (data is List ? data : const <dynamic>[]);

    final items = rawItems
        .whereType<Map<String, dynamic>>()
        .map(ConsultationBookingListItemModel.fromJson)
        .where(_isRenderableItem)
        .toList(growable: false);

    return ConsultationBookingsPageModel(
      items: items,
      page: _readInt(pageData ?? json, 'page', fallback: 1),
      limit: _readInt(pageData ?? json, 'limit', fallback: 20),
      total: _readInt(pageData ?? json, 'total', fallback: items.length),
    );
  }

  static bool _isRenderableItem(ConsultationBookingListItemModel item) {
    return item.bookingId.isNotEmpty &&
        (item.doctorName.isNotEmpty || item.slotDate.isNotEmpty);
  }

  ConsultationBookingsPageEntity toEntity() {
    return ConsultationBookingsPageEntity(
      items: items.map((item) => item.toEntity()).toList(growable: false),
      page: page,
      limit: limit,
      total: total,
    );
  }

  static int _readInt(
    Map<String, dynamic> json,
    String key, {
    required int fallback,
  }) {
    final value = json[key];
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
