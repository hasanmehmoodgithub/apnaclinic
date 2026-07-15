class SurgeryBookingRequestEntity {
  const SurgeryBookingRequestEntity({
    required this.doctorId,
    required this.surgeryId,
    required this.packageId,
    required this.cityId,
    required this.patientName,
    required this.age,
    required this.gender,
    required this.phone,
    required this.emergencyPhone,
  });

  /// Doctor offering the surgery.
  final String doctorId;

  /// Procedure id from surgery list.
  final String surgeryId;

  /// Selected package id from provider-details.
  final String packageId;

  final String cityId;
  final String patientName;
  final String age;
  final String gender;
  final String phone;
  final String emergencyPhone;
}
