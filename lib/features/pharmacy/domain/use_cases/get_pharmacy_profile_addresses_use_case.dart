import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/pharmacy_cart_address_entity.dart';
import '../repositories/pharmacy_repository.dart';

class GetPharmacyProfileAddressesUseCase
    implements UseCaseNoParams<List<PharmacyCartAddressEntity>> {
  GetPharmacyProfileAddressesUseCase({required this.repository});

  final PharmacyRepository repository;

  @override
  Future<Either<ErrorMsg, List<PharmacyCartAddressEntity>>> call() {
    return repository.getProfileAddresses();
  }
}
