import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/pharmacy_booking_entity.dart';
import '../repositories/pharmacy_repository.dart';

class GetPharmacyBookingsParams {
  const GetPharmacyBookingsParams({
    this.page = 1,
    this.limit = 20,
  });

  final int page;
  final int limit;
}

class GetPharmacyBookingsUseCase
    implements UseCase<PharmacyBookingsPageEntity, GetPharmacyBookingsParams> {
  GetPharmacyBookingsUseCase({required this.repository});

  final PharmacyRepository repository;

  @override
  Future<Either<ErrorMsg, PharmacyBookingsPageEntity>> call(
    GetPharmacyBookingsParams params,
  ) {
    return repository.getPharmacyBookings(
      page: params.page,
      limit: params.limit,
    );
  }
}
