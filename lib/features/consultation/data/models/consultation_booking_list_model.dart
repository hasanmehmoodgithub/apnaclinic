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
    required this.originalFee,
    required this.discountPercent,
    required this.patientRelation,
    required this.issue,
    required this.doctorName,
    required this.specialty,
    required this.yearsOfExperience,
    required this.qualifications,
    required this.education,
    required this.doctorImageUrl,
    required this.consultationLink,
    required this.partnerRefNo,
    required this.ratings,
    required this.pmdcVerified,
    required this.partnerTenantId,
    required this.partnerLogoUrl,
    required this.attachments,
    required this.patientReview,
  });

  final String bookingId;
  final String status;
  final String slotDate;
  final String slotStartTime;
  final String slotEndTime;
  final int consultationFee;
  final int discountAmount;
  final int originalFee;
  final double discountPercent;
  final String patientRelation;
  final String issue;
  final String doctorName;
  final String specialty;
  final int? yearsOfExperience;
  final List<String> qualifications;
  final String education;
  final String doctorImageUrl;
  final String consultationLink;
  final String partnerRefNo;
  final double? ratings;
  final bool pmdcVerified;
  final String partnerTenantId;
  final String partnerLogoUrl;
  final List<String> attachments;
  final ConsultationBookingPatientReviewEntity? patientReview;

  factory ConsultationBookingListItemModel.fromJson(Map<String, dynamic> json) {
    final doctor = _resolveDoctor(json);
    final partner = _resolvePartner(doctor);
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
      consultationFee: fees.payable,
      discountAmount: fees.discount,
      originalFee: fees.original,
      discountPercent: fees.percent,
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
      partnerRefNo: _readString(json, const [
        'partnerRefNo',
        'partner_ref_no',
        'referenceNo',
        'reference_no',
      ]),
      ratings: _readNullableDouble(
        doctor?['ratings'] ?? doctor?['ratingScore'] ?? json['ratings'],
      ),
      pmdcVerified: _readBool(
        doctor?['pmdcVerified'] ??
            doctor?['pmdc_verified'] ??
            json['pmdcVerified'],
      ),
      partnerTenantId: _readString(
        json,
        const ['tenantId', 'tenant_id'],
        nested: partner,
        nestedKeys: const ['tenantId', 'tenant_id', 'id'],
      ),
      partnerLogoUrl: _readString(
        json,
        const ['partnerLogoUrl', 'partner_logo_url'],
        nested: partner,
        nestedKeys: const ['logoUrl', 'logo_url'],
      ),
      attachments: _parseAttachments(json['attachments']),
      patientReview: _parsePatientReview(json['patientReview']),
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
      originalFee: originalFee,
      discountPercent: discountPercent,
      patientRelation: patientRelation,
      issue: issue,
      doctorName: doctorName,
      specialty: specialty,
      yearsOfExperience: yearsOfExperience,
      qualifications: qualifications,
      education: education,
      doctorImageUrl: doctorImageUrl,
      consultationLink: consultationLink,
      partnerRefNo: partnerRefNo,
      ratings: ratings,
      pmdcVerified: pmdcVerified,
      partnerTenantId: partnerTenantId,
      partnerLogoUrl: partnerLogoUrl,
      attachments: attachments,
      patientReview: patientReview,
    );
  }

  static Map<String, dynamic>? _resolveDoctor(Map<String, dynamic> json) {
    for (final key in const ['doctorInfo', 'doctor', 'doctor_info']) {
      final value = json[key];
      if (value is Map) return Map<String, dynamic>.from(value);
    }
    return null;
  }

  static Map<String, dynamic>? _resolvePartner(Map<String, dynamic>? doctor) {
    if (doctor == null) return null;
    final value = doctor['partner'];
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static String _resolveBookingId({
    required Map<String, dynamic> json,
    required String doctorId,
  }) {
    final partnerRef = _readString(json, const [
      'partnerRefNo',
      'partner_ref_no',
    ]);
    if (partnerRef.isNotEmpty) return partnerRef;

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

  static ({int payable, int discount, int original, double percent})
      _resolveFees(
    Map<String, dynamic>? doctor,
    Map<String, dynamic> json,
  ) {
    if (doctor != null) {
      if (doctor['isFree'] == true) {
        final original = _readDouble(doctor['consultationFee']).round();
        return (
          payable: 0,
          discount: original,
          original: original,
          percent: 100,
        );
      }

      final original = _readDouble(doctor['consultationFee']);
      final discountPercent = _readDouble(doctor['discountPercent']);
      if (original > 0) {
        if (discountPercent <= 0) {
          final amount = original.round();
          return (
            payable: amount,
            discount: 0,
            original: amount,
            percent: 0,
          );
        }
        final discount = (original * discountPercent / 100).round();
        return (
          payable: (original - discount).round(),
          discount: discount,
          original: original.round(),
          percent: discountPercent,
        );
      }
    }

    final payable = _readInt(json, const [
      'consultationFee',
      'consultation_fee',
      'fee',
      'payableAmount',
      'payable_amount',
    ]);
    final discount = _readInt(json, const [
      'discountAmount',
      'discount_amount',
      'discount',
    ]);
    return (
      payable: payable,
      discount: discount,
      original: payable + discount,
      percent: 0,
    );
  }

  static List<String> _parseAttachments(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .map((item) {
          if (item is String) return item.trim();
          if (item is Map) {
            final map = Map<String, dynamic>.from(item);
            return (map['url'] ??
                    map['fileUrl'] ??
                    map['file_url'] ??
                    map['path'] ??
                    '')
                .toString()
                .trim();
          }
          return item.toString().trim();
        })
        .where((url) => url.isNotEmpty)
        .toList(growable: false);
  }

  static ConsultationBookingPatientReviewEntity? _parsePatientReview(
    dynamic raw,
  ) {
    if (raw is! Map) return null;
    final map = Map<String, dynamic>.from(raw);
    final review = (map['review'] ?? map['comment'] ?? map['feedback'] ?? '')
        .toString()
        .trim();
    final rating = _readNullableDouble(map['rating'] ?? map['score']);
    final date = (map['date'] ?? map['createdAt'] ?? map['created_at'] ?? '')
        .toString()
        .trim();
    if (rating == null && review.isEmpty) return null;
    return ConsultationBookingPatientReviewEntity(
      rating: rating ?? 0,
      review: review,
      date: date,
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

  static double? _readNullableDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().trim());
  }

  static int? _readNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static bool _readBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final text = value?.toString().trim().toLowerCase();
    return text == 'true' || text == '1' || text == 'yes';
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
        data is Map ? Map<String, dynamic>.from(data) : null;
    final rawItems = pageData?['data'] is List
        ? pageData!['data'] as List<dynamic>
        : (data is List ? data : const <dynamic>[]);

    final items = rawItems
        .whereType<Map>()
        .map((item) => ConsultationBookingListItemModel.fromJson(
              Map<String, dynamic>.from(item),
            ))
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
