import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/consultation_booking_list_entity.dart';
import '../repositories/consultation_repository.dart';

class GetConsultationBookingsParams {
  const GetConsultationBookingsParams({
    this.page = 1,
    this.limit = 20,
  });

  final int page;
  final int limit;
}

class GetConsultationBookingsUseCase
    implements UseCase<ConsultationBookingsPageEntity, GetConsultationBookingsParams> {
  GetConsultationBookingsUseCase({required this.repository});

  final ConsultationRepository repository;

  @override
  Future<Either<ErrorMsg, ConsultationBookingsPageEntity>> call(
    GetConsultationBookingsParams params,
  ) {
    return repository.getBookings(page: params.page, limit: params.limit);
  }
}
