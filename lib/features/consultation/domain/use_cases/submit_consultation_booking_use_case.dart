import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../../../payment/domain/entities/payment_initiation_result.dart';
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
    this.issue = '',
    this.attachments = const [],
    this.promoCode,
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
  final String issue;
  final List<ConsultationBookingAttachmentEntity> attachments;
  final String? promoCode;
}

class SubmitConsultationBookingUseCase
    implements
        UseCase<PaymentInitiationResult, SubmitConsultationBookingParams> {
  SubmitConsultationBookingUseCase({required this.repository});

  final ConsultationRepository repository;

  @override
  Future<Either<ErrorMsg, PaymentInitiationResult>> call(
    SubmitConsultationBookingParams params,
  ) {
    return repository.submitBooking(params);
  }
}
