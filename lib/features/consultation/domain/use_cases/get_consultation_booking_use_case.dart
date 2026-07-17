import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/consultation_booking_list_entity.dart';
import '../repositories/consultation_repository.dart';

class GetConsultationBookingParams {
  const GetConsultationBookingParams({required this.appointmentId});

  final int appointmentId;
}

class GetConsultationBookingUseCase
    implements
        UseCase<ConsultationBookingListItemEntity, GetConsultationBookingParams> {
  GetConsultationBookingUseCase({required this.repository});

  final ConsultationRepository repository;

  @override
  Future<Either<ErrorMsg, ConsultationBookingListItemEntity>> call(
    GetConsultationBookingParams params,
  ) {
    return repository.getBooking(appointmentId: params.appointmentId);
  }
}
