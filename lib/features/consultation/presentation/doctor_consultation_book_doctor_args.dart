import 'widgets/results_doctor_item.dart';

class DoctorConsultationBookDoctorArgs {
  const DoctorConsultationBookDoctorArgs({
    required this.doctor,
    this.moduleSource,
  });

  final ResultsDoctorItem doctor;
  final String? moduleSource;
}
