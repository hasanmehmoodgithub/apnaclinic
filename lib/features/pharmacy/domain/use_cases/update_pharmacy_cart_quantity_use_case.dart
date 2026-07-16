import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/pharmacy_add_to_cart_result_entity.dart';
import '../repositories/pharmacy_repository.dart';

class UpdatePharmacyCartQuantityParams {
  const UpdatePharmacyCartQuantityParams({
    required this.productId,
    required this.quantity,
  });

  final String productId;
  final String quantity;
}

class UpdatePharmacyCartQuantityUseCase
    implements
        UseCase<PharmacyAddToCartResultEntity, UpdatePharmacyCartQuantityParams> {
  UpdatePharmacyCartQuantityUseCase({required this.repository});

  final PharmacyRepository repository;

  @override
  Future<Either<ErrorMsg, PharmacyAddToCartResultEntity>> call(
    UpdatePharmacyCartQuantityParams params,
  ) async {
    return repository.updateCartQuantity(
      productId: params.productId,
      quantity: params.quantity,
    );
  }
}
