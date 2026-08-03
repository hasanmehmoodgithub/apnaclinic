class SurgeryPatientDetailsArgs {
  const SurgeryPatientDetailsArgs({
    required this.surgeryId,
    required this.cityId,
    required this.doctorId,
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

  final String surgeryId;
  final String cityId;
  final String doctorId;
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
