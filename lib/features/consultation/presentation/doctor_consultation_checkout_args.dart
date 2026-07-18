import '../domain/entities/consultation_booking_attachment_entity.dart';
import '../domain/entities/consultation_selected_slot_entity.dart';
import '../data/models/doctor_consultation_checkout_model.dart';
import 'widgets/results_doctor_item.dart';

class DoctorConsultationCheckoutArgs {
  const DoctorConsultationCheckoutArgs({
    required this.doctor,
    required this.issueDescription,
    required this.selectedSlot,
    required this.attachments,
    this.paymentOptions = const [],
  });

  final ResultsDoctorItem doctor;
  final String issueDescription;
  final ConsultationSelectedSlotEntity selectedSlot;
  final List<ConsultationBookingAttachmentEntity> attachments;

  /// Prefetched via payment-provider API before opening checkout.
  final List<DoctorConsultationPaymentOptionModel> paymentOptions;

  String get doctorName => doctor.name;
  String get specialty => doctor.specialty;
  String get qualification => doctor.qualification;
  String get doctorImageUrl => doctor.imageUrl;
}
