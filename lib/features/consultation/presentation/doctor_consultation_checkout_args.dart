class DoctorConsultationCheckoutArgs {
  const DoctorConsultationCheckoutArgs({
    required this.doctorName,
    required this.specialty,
    required this.qualification,
    required this.doctorImageUrl,
  });

  final String doctorName;
  final String specialty;
  final String qualification;
  final String doctorImageUrl;
}
