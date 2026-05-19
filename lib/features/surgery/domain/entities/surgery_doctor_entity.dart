class SurgeryDoctorEntity {
  const SurgeryDoctorEntity({
    required this.id,
    required this.doctorName,
    required this.speciality,
    required this.experience,
    required this.qualifications,
    required this.hospitalName,
    required this.procedureName,
    required this.price,
    required this.oldPrice,
    required this.imageUrl,
    required this.partnerLogoUrl,
  });

  final String id;
  final String doctorName;
  final String speciality;
  final String experience;
  final String qualifications;
  final String hospitalName;
  final String procedureName;
  final String price;
  final String oldPrice;
  final String imageUrl;
  final String partnerLogoUrl;
}

class SurgeryDoctorsEntity {
  const SurgeryDoctorsEntity({
    required this.procedureName,
    required this.city,
    required this.hospitals,
    required this.specialties,
    required this.doctors,
  });

  final String procedureName;
  final String city;
  final List<String> hospitals;
  final List<String> specialties;
  final List<SurgeryDoctorEntity> doctors;
}
