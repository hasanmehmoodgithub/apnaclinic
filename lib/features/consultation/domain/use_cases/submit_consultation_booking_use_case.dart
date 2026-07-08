import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/consultation_booking_attachment_entity.dart';
import '../repositories/consultation_repository.dart';

class SubmitConsultationBookingParams {
  const SubmitConsultationBookingParams({
    required this.doctorId,
    required this.tenantId,
    required this.consultationFee,
    required this.patientId,
    required this.patientRelation,
    required this.slotDate,
    required this.slotStartTime,
    required this.slotEndTime,
    required this.paymentMethod,
    required this.msisdn,
    this.attachments = const [],
  });

  final int doctorId;
  final int tenantId;
  final int consultationFee;
  final int patientId;
  final String patientRelation;
  final String slotDate;
  final String slotStartTime;
  final String slotEndTime;
  final String paymentMethod;
  final String msisdn;
  final List<ConsultationBookingAttachmentEntity> attachments;
}

class SubmitConsultationBookingUseCase
    implements UseCase<void, SubmitConsultationBookingParams> {
  SubmitConsultationBookingUseCase({required this.repository});

  final ConsultationRepository repository;

  @override
  Future<Either<ErrorMsg, void>> call(SubmitConsultationBookingParams params) {
    return repository.submitBooking(params);
  }
}
