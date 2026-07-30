import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/pharmacy_add_address_result_entity.dart';
import '../repositories/pharmacy_repository.dart';

class AddPharmacyProfileAddressParams {
  const AddPharmacyProfileAddressParams({
    required this.address,
    required this.region,
    required this.line1,
    required this.cityId,
    this.lat = '0',
    this.long = '0',
  });

  final String address;
  final String region;
  final String line1;
  final String cityId;
  final String lat;
  final String long;
}

class AddPharmacyProfileAddressUseCase
    implements
        UseCase<PharmacyAddAddressResultEntity, AddPharmacyProfileAddressParams> {
  AddPharmacyProfileAddressUseCase({required this.repository});

  final PharmacyRepository repository;

  @override
  Future<Either<ErrorMsg, PharmacyAddAddressResultEntity>> call(
    AddPharmacyProfileAddressParams params,
  ) {
    return repository.addProfileAddress(
      address: params.address,
      region: params.region,
      line1: params.line1,
      cityId: params.cityId,
      lat: params.lat,
      long: params.long,
    );
  }
}
