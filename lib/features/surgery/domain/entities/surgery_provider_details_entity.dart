class SurgeryPackageEntity {
  const SurgeryPackageEntity({
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
}

class SurgeryProviderDoctorEntity {
  const SurgeryProviderDoctorEntity({
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

  static const empty = SurgeryProviderDoctorEntity(
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
}

class SurgeryProviderDetailsEntity {
  const SurgeryProviderDetailsEntity({
    required this.doctor,
    required this.packages,
  });

  final SurgeryProviderDoctorEntity doctor;
  final List<SurgeryPackageEntity> packages;

  static const empty = SurgeryProviderDetailsEntity(
    doctor: SurgeryProviderDoctorEntity.empty,
    packages: [],
  );
}
