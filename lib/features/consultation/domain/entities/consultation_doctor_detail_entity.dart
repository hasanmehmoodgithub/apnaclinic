/// Profile from `GET …/web/doctor-consultation/doctor/{id}`.
class ConsultationDoctorDetailEntity {
  const ConsultationDoctorDetailEntity({
    required this.id,
    required this.publicId,
    required this.displayName,
    required this.specialtyName,
    this.yearsOfExperience,
    required this.profileImageUrl,
    required this.consultationFee,
    required this.discountPercent,
    required this.isFree,
    this.ratingScore,
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
}
