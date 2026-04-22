import '../../../../core/failure/exceptions.dart';
import '../../../../core/functional/functional_export.dart';
import '../entities/pharmacy_cart_item_entity.dart';
import '../entities/pharmacy_medicine_entity.dart';

abstract class PharmacyRepository {
  Future<Either<ErrorMsg, List<PharmacyMedicineEntity>>> getPharmacyMedicines();
  Future<Either<ErrorMsg, List<PharmacyCartItemEntity>>> getPharmacyCart();
  Future<Either<ErrorMsg, String>> addToCart({
    required String medicineId,
    required int quantity,
  });
}
