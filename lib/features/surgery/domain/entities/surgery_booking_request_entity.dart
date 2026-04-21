class SurgeryBookingRequestEntity {
  const SurgeryBookingRequestEntity({
    required this.patientName,
    required this.age,
    required this.contactNumber,
    required this.emergencyContact,
    required this.surgeryName,
    required this.doctorName,
    required this.hospitalName,
  });

  final String patientName;
  final String age;
  final String contactNumber;
  final String emergencyContact;
  final String surgeryName;
  final String doctorName;
  final String hospitalName;
}
