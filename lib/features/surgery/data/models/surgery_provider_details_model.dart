class SurgeryPackageModel {
  const SurgeryPackageModel({
    required this.packageId,
    required this.packageName,
    required this.price,
    required this.oldPrice,
    required this.tatMessage,
    required this.hospitalId,
    required this.hospitalName,
  });

  final String packageId;
  final String packageName;
  final String price;
  final String oldPrice;
  final String tatMessage;
  final String hospitalId;
  final String hospitalName;

  factory SurgeryPackageModel.fromJson(Map<String, dynamic> json) {
    final discounted = json['discountedPrice'] ?? json['discounted_price'];
    final original = json['price'] ?? json['oldPrice'] ?? json['old_price'];

    return SurgeryPackageModel(
      packageId: (json['packageId'] ?? json['package_id'] ?? json['id'] ?? '')
          .toString(),
      packageName:
          (json['packageName'] ?? json['package_name'] ?? json['name'] ?? '')
              .toString(),
      price: _formatPrice(discounted ?? original),
      oldPrice: _formatOriginalPrice(original, discounted),
      tatMessage: (json['tatMessage'] ?? json['tat_message'] ?? '').toString(),
      hospitalId: (json['hospitalId'] ?? json['hospital_id'] ?? '').toString(),
      hospitalName:
          (json['hospitalName'] ?? json['hospital_name'] ?? '').toString(),
    );
  }

  static String _formatPrice(dynamic amount) {
    if (amount == null) return '';
    if (amount is num) {
      return 'Rs. ${amount.round()}/-';
    }
    final text = amount.toString().trim();
    if (text.isEmpty) return '';
    if (text.toLowerCase().startsWith('rs')) return text;
    return 'Rs. $text/-';
  }

  static String _formatOriginalPrice(dynamic original, dynamic discounted) {
    if (original == null) return '';
    if (discounted != null && original == discounted) return '';
    return _formatPrice(original);
  }
}

class SurgeryProviderDoctorModel {
  const SurgeryProviderDoctorModel({
    required this.id,
    required this.name,
    required this.profileImageUrl,
    required this.yearsOfExperience,
    required this.education,
    required this.bio,
    required this.specialty,
    required this.partnerId,
    required this.partnerName,
    required this.partnerLogoUrl,
  });

  final String id;
  final String name;
  final String profileImageUrl;
  final String yearsOfExperience;
  final String education;
  final String bio;
  final String specialty;
  final String partnerId;
  final String partnerName;
  final String partnerLogoUrl;

  factory SurgeryProviderDoctorModel.fromJson(Map<String, dynamic> json) {
    final years = json['yearsOfExperience'] ?? json['years_of_experience'];
    String experienceText = '';
    if (years != null) {
      if (years is num) {
        final value = years.toInt();
        experienceText = value == 1 ? '1 year' : '$value years';
      } else {
        final text = years.toString().trim();
        if (text.isNotEmpty) {
          experienceText =
              text.toLowerCase().contains('year') ? text : '$text years';
        }
      }
    }

    return SurgeryProviderDoctorModel(
      id: (json['id'] ?? json['doctorId'] ?? json['doctor_id'] ?? '')
          .toString(),
      name: (json['name'] ?? json['doctorName'] ?? json['doctor_name'] ?? '')
          .toString(),
      profileImageUrl: (json['profileImageUrl'] ??
              json['profile_image_url'] ??
              json['imageUrl'] ??
              json['image_url'] ??
              '')
          .toString(),
      yearsOfExperience: experienceText,
      education: (json['education'] ?? json['qualifications'] ?? '').toString(),
      bio: (json['bio'] ?? '').toString(),
      specialty: (json['specialty'] ?? json['speciality'] ?? '').toString(),
      partnerId: (json['partnerId'] ?? json['partner_id'] ?? '').toString(),
      partnerName:
          (json['partnerName'] ?? json['partner_name'] ?? '').toString(),
      partnerLogoUrl:
          (json['partnerLogoUrl'] ?? json['partner_logo_url'] ?? '').toString(),
    );
  }
}

class SurgeryProviderDetailsModel {
  const SurgeryProviderDetailsModel({
    required this.doctor,
    required this.packages,
  });

  final SurgeryProviderDoctorModel doctor;
  final List<SurgeryPackageModel> packages;

  factory SurgeryProviderDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final payload = data is Map<String, dynamic> ? data : json;

    final doctorRaw = payload['doctor'];
    final doctor = doctorRaw is Map<String, dynamic>
        ? SurgeryProviderDoctorModel.fromJson(doctorRaw)
        : const SurgeryProviderDoctorModel(
            id: '',
            name: '',
            profileImageUrl: '',
            yearsOfExperience: '',
            education: '',
            bio: '',
            specialty: '',
            partnerId: '',
            partnerName: '',
            partnerLogoUrl: '',
          );

    final packagesRaw = payload['packages'] ?? payload['items'];
    final packages = packagesRaw is List
        ? packagesRaw
            .whereType<Map<String, dynamic>>()
            .map(SurgeryPackageModel.fromJson)
            .where((item) => item.packageName.isNotEmpty)
            .toList()
        : const <SurgeryPackageModel>[];

    return SurgeryProviderDetailsModel(doctor: doctor, packages: packages);
  }
}
