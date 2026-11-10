import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/pharmacy_city_entity.dart';
import '../repositories/pharmacy_repository.dart';

class GetPharmacyCitiesUseCase
    implements UseCaseNoParams<List<PharmacyCityEntity>> {
  GetPharmacyCitiesUseCase({required this.repository});

  final PharmacyRepository repository;

  @override
  Future<Either<ErrorMsg, List<PharmacyCityEntity>>> call() {
    return repository.getPharmacyCities();
  }
}
