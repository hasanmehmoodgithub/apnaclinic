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
      partnerLogoUrl: (partner?['logoUrl'] ?? '').toString().trim(),
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
    final tenantId = partner['tenantId'];
    return switch (tenantId) {
      1 => 'MedIQ',
      2 => 'Doctors World',
      _ => 'Partner',
    };
  }
}

class ConsultationDoctorsResponseModel {
  const ConsultationDoctorsResponseModel({
    required this.success,
    required this.message,
    required this.doctors,
  });

  final bool success;
  final String message;
  final List<ConsultationDoctorModel> doctors;

  factory ConsultationDoctorsResponseModel.fromJson(Map<String, dynamic> json) {
    final code = json['code'];
    final success = json['success'] == true || (code is num && code.toInt() == 200);
    final data = json['data'];
    final List<dynamic> rawDoctors;
    if (data is Map<String, dynamic>) {
      rawDoctors = data['data'] is List
          ? data['data'] as List<dynamic>
          : (data['doctors'] is List ? data['doctors'] as List<dynamic> : const []);
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

    return ConsultationDoctorsResponseModel(
      success: success,
      message: (json['message'] ?? '').toString(),
      doctors: doctors,
    );
  }
}
