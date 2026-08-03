import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/pharmacy_booking_detail_entity.dart';
import '../repositories/pharmacy_repository.dart';

class GetPharmacyBookingDetailParams {
  const GetPharmacyBookingDetailParams({required this.orderId});

  final String orderId;
}

class GetPharmacyBookingDetailUseCase
    implements
        UseCase<PharmacyBookingDetailEntity, GetPharmacyBookingDetailParams> {
  GetPharmacyBookingDetailUseCase({required this.repository});

  final PharmacyRepository repository;

  @override
  Future<Either<ErrorMsg, PharmacyBookingDetailEntity>> call(
    GetPharmacyBookingDetailParams params,
  ) {
    return repository.getPharmacyBookingDetail(orderId: params.orderId);
  }
}
