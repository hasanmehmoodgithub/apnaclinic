import '../../../../core/failure/exceptions.dart';
import '../../../../core/functional/functional_export.dart';
import '../entities/pharmacy_medicine_entity.dart';

abstract class PharmacyRepository {
  Future<Either<ErrorMsg, List<PharmacyMedicineEntity>>> getPharmacyMedicines();
}
