import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/instant_doctor_booking_entity.dart';
import '../repositories/instant_doctor_repository.dart';
import 'get_instant_doctor_bookings_params.dart';

class GetInstantDoctorBookingsUseCase
    implements
        UseCase<InstantDoctorBookingsPageEntity, GetInstantDoctorBookingsParams> {
  GetInstantDoctorBookingsUseCase({required this.repository});

  final InstantDoctorRepository repository;

  @override
  Future<Either<ErrorMsg, InstantDoctorBookingsPageEntity>> call(
    GetInstantDoctorBookingsParams params,
  ) {
    return repository.getBookings(params);
  }
}
