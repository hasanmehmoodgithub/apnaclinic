import '../../domain/entities/consultation_doctors_page_entity.dart';
import '../../presentation/widgets/results_doctor_item.dart';

class ConsultationDoctorModel {
  const ConsultationDoctorModel({
    required this.id,
    required this.publicId,
    required this.displayName,
    required this.specialtyName,
    required this.yearsOfExperience,
    required this.profileImageUrl,
    required this.consultationFee,
    required this.discountPercent,
    required this.isFree,
    required this.ratingScore,
    required this.qualifications,
    required this.education,
    required this.bio,
    required this.partnerLabel,
    required this.partnerLogoUrl,
    required this.hospitalId,
    required this.partnerDoctorId,
    required this.tenantId,
  });

  final String id;
  final String publicId;
  final String displayName;
  final String specialtyName;
  final int? yearsOfExperience;
  final String profileImageUrl;
  final String consultationFee;
  final String discountPercent;
  final bool isFree;
  final double? ratingScore;
  final List<String> qualifications;
  final String education;
  final String bio;
  final String partnerLabel;
  final String partnerLogoUrl;
  final String hospitalId;
  final String partnerDoctorId;
  final String tenantId;

  factory ConsultationDoctorModel.fromJson(Map<String, dynamic> json) {
    final partnerRaw = json['partner'];
    final partner = partnerRaw is Map<String, dynamic> ? partnerRaw : null;
    final qualificationsRaw = json['qualifications'];

    return ConsultationDoctorModel(
      id: (json['id'] ?? '').toString(),
      publicId: (json['publicId'] ?? json['public_id'] ?? '').toString(),
      displayName: (json['displayName'] ?? json['name'] ?? '').toString().trim(),
      specialtyName:
          (json['specialtyName'] ?? json['specialty'] ?? '').toString().trim(),
      yearsOfExperience: _readInt(json['yearsOfExperience']),
      profileImageUrl: (json['profileImageUrl'] ??
              json['imageUrl'] ??
              json['image'] ??
              '')
          .toString()
          .trim(),
      consultationFee:
          (json['consultationFee'] ?? json['fee'] ?? '').toString(),
      discountPercent: (json['discountPercent'] ?? '0').toString(),
      isFree: json['isFree'] == true,
      ratingScore: _readDouble(json['ratingScore'] ?? json['rating']),
      qualifications: (qualificationsRaw is List ? qualificationsRaw : const [])
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList(growable: false),
      education: (json['education'] ?? '').toString().trim(),
      bio: (json['bio'] ?? json['description'] ?? '').toString().trim(),
      partnerLabel: _partnerLabel(partner),
      partnerLogoUrl: (partner?['logoUrl'] ?? partner?['logo_url'] ?? '')
          .toString()
          .trim(),
      hospitalId: _readString(json, const [
        'hospitalId',
        'hospital_id',
        'defaultHospitalId',
        'default_hospital_id',
      ], partner: partner),
      partnerDoctorId: _readString(json, const [
        'partnerDoctorId',
        'partner_doctor_id',
        'slotsDoctorId',
        'slots_doctor_id',
        'externalDoctorId',
        'external_doctor_id',
      ], partner: partner),
      tenantId: _readString(json, const [
        'tenantId',
        'tenant_id',
      ], partner: partner),
    );
  }

  ResultsDoctorItem toResultsDoctorItem() {
    final fees = _resolveFees();
    final experienceText = yearsOfExperience == null
        ? ''
        : '$yearsOfExperience ${yearsOfExperience == 1 ? 'Year' : 'Years'} Experience';
    final qualificationText = qualifications.isNotEmpty
        ? qualifications.join(', ')
        : education;
    final ratingText = ratingScore == null
        ? '0 / 5'
        : '${_formatRatingScore(ratingScore!)} / 5';

    return ResultsDoctorItem(
      id: publicId.isNotEmpty ? publicId : id,
      apiDoctorId: id,
      partnerDoctorId: partnerDoctorId,
      hospitalId: hospitalId,
      tenantId: tenantId,
      name: displayName,
      specialty: specialtyName,
      experience: experienceText,
      qualification: qualificationText,
      fee: fees.$1,
      oldFee: fees.$2,
      partner: partnerLabel,
      rating: ratingText,
      imageUrl: profileImageUrl,
      description: bio,
      partnerLogoUrl: partnerLogoUrl,
    );
  }

  (String fee, String oldFee) _resolveFees() {
    if (isFree) return ('Free', '');
    final original = double.tryParse(consultationFee) ?? 0;
    final discount = double.tryParse(discountPercent) ?? 0;
    if (original <= 0) return ('', '');
    if (discount <= 0) return (_formatRs(original), '');
    final discounted = original * (1 - (discount / 100));
    return (_formatRs(discounted), _formatRs(original));
  }

  static String _formatRs(double amount) => 'Rs. ${amount.round()}/-';

  static String _formatRatingScore(double value) {
    if (value % 1 == 0) return value.toInt().toString();
    return value
        .toStringAsFixed(2)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }

  static int? _readInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static double? _readDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static String _partnerLabel(Map<String, dynamic>? partner) {
    if (partner == null) return '';
    return (partner['name'] ??
            partner['displayName'] ??
            partner['label'] ??
            partner['title'] ??
            '')
        .toString()
        .trim();
  }

  static String _readString(
    Map<String, dynamic> json,
    List<String> keys, {
    Map<String, dynamic>? partner,
  }) {
    for (final key in keys) {
      final rootValue = json[key];
      if (rootValue != null && rootValue.toString().trim().isNotEmpty) {
        return rootValue.toString().trim();
      }
    }

    if (partner != null) {
      for (final key in keys) {
        final partnerValue = partner[key];
        if (partnerValue != null && partnerValue.toString().trim().isNotEmpty) {
          return partnerValue.toString().trim();
        }
      }
      for (final key in const ['doctorId', 'doctor_id', 'externalId']) {
        final partnerValue = partner[key];
        if (partnerValue != null && partnerValue.toString().trim().isNotEmpty) {
          return partnerValue.toString().trim();
        }
      }
    }

    return '';
  }
}

class ConsultationDoctorsResponseModel {
  const ConsultationDoctorsResponseModel({
    required this.success,
    required this.message,
    required this.doctors,
    required this.page,
    required this.limit,
    required this.total,
  });

  final bool success;
  final String message;
  final List<ConsultationDoctorModel> doctors;
  final int page;
  final int limit;
  final int total;

  bool get hasMore => page * limit < total;

  factory ConsultationDoctorsResponseModel.fromJson(Map<String, dynamic> json) {
    final code = json['code'];
    final success = json['success'] == true || (code is num && code.toInt() == 200);
    final data = json['data'];
    final Map<String, dynamic>? pageData =
        data is Map<String, dynamic> ? data : null;
    final List<dynamic> rawDoctors;
    if (pageData?['data'] is List) {
      rawDoctors = pageData!['data'] as List<dynamic>;
    } else if (data is List) {
      rawDoctors = data;
    } else {
      rawDoctors = json['doctors'] is List
          ? json['doctors'] as List<dynamic>
          : const [];
    }

    final doctors = rawDoctors
        .whereType<Map<String, dynamic>>()
        .map(ConsultationDoctorModel.fromJson)
        .where((doctor) => doctor.displayName.isNotEmpty)
        .toList(growable: false);

    final page = _readInt(pageData ?? json, 'page', fallback: 1);
    final limit = _readInt(pageData ?? json, 'limit', fallback: 20);
    final total = _readInt(pageData ?? json, 'total', fallback: doctors.length);

    return ConsultationDoctorsResponseModel(
      success: success,
      message: (json['message'] ?? '').toString(),
      doctors: doctors,
      page: page,
      limit: limit,
      total: total,
    );
  }

  ConsultationDoctorsPageEntity toPageEntity() {
    return ConsultationDoctorsPageEntity(
      doctors: doctors.map((doctor) => doctor.toResultsDoctorItem()).toList(),
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
