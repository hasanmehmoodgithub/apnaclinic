class ResultsDoctorItem {
  final String id;
  final String apiDoctorId;
  final String partnerDoctorId;
  final String hospitalId;
  /// Doctor partner tenant (`partner.tenantId` from doctors API); used for booking.
  final String tenantId;
  final String name;
  final String specialty;
  final String experience;
  final String qualification;
  final String fee;
  final String oldFee;
  final String partner;
  final String rating;
  final String imageUrl;
  final String verifiedPatientsCount;
  final String satisfiedText;
  final String description;
  final String partnerLogoUrl;

  const ResultsDoctorItem({
    required this.id,
    required this.apiDoctorId,
    this.partnerDoctorId = '',
    this.hospitalId = '',
    this.tenantId = '',
    required this.name,
    required this.specialty,
    required this.experience,
    required this.qualification,
    required this.fee,
    required this.oldFee,
    required this.partner,
    required this.rating,
    required this.imageUrl,
    this.verifiedPatientsCount = '0',
    this.satisfiedText = '0',
    this.description = '',
    this.partnerLogoUrl = '',
  });

  factory ResultsDoctorItem.fromMap(Map<String, dynamic> map) {
    return ResultsDoctorItem(
      id: map['id'] as String? ?? '',
      apiDoctorId: (map['apiDoctorId'] ?? map['id'] ?? '').toString(),
      partnerDoctorId: (map['partnerDoctorId'] ?? '').toString(),
      hospitalId: (map['hospitalId'] ?? '').toString(),
      tenantId: (map['tenantId'] ?? map['partnerTenantId'] ?? '').toString(),
      name: map['name'] as String? ?? '',
      specialty: map['specialty'] as String? ?? '',
      experience: map['experience'] as String? ?? '',
      qualification: map['qualification'] as String? ?? '',
      fee: map['fee'] as String? ?? '',
      oldFee: map['oldFee'] as String? ?? '',
      partner: map['partner'] as String? ?? '',
      rating: map['rating'] as String? ?? '0 / 5',
      imageUrl: map['imageUrl'] as String? ?? '',
      verifiedPatientsCount: map['verifiedPatientsCount'] as String? ?? '0',
      satisfiedText: map['satisfiedText'] as String? ?? '0',
      description: (map['description'] ?? map['bio'] ?? '').toString(),
      partnerLogoUrl: (map['partnerLogoUrl'] ?? '').toString(),
    );
  }
}
