import '../domain/entities/consultation_selected_slot_entity.dart';
import 'widgets/results_doctor_item.dart';

class DoctorConsultationBookDoctorArgs {
  const DoctorConsultationBookDoctorArgs({
    required this.doctor,
    this.moduleSource,
    this.initialSelectedSlot,
    this.hydrateDoctorFromDetailApi = false,
  });

  final ResultsDoctorItem doctor;
  final String? moduleSource;
  /// Prefill from AI / deep link (`date`, `start`, `end`).
  final ConsultationSelectedSlotEntity? initialSelectedSlot;
  /// When true (Care Companion deep link), apply profile from
  /// `GET …/doctor-consultation/doctor/{id}` after slots load. Normal browse
  /// already has a full doctor card — leave false so that path is unchanged.
  final bool hydrateDoctorFromDetailApi;
}
