import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/pharmacy_add_to_cart_result_entity.dart';
import '../repositories/pharmacy_repository.dart';

class AddToCartParams {
  const AddToCartParams({
    required this.medicineId,
    required this.quantity,
    this.bookingId,
  });

  final String medicineId;
  final int quantity;
  final String? bookingId;
}

class AddToCartUseCase
    implements UseCase<PharmacyAddToCartResultEntity, AddToCartParams> {
  AddToCartUseCase({required this.repository});

  final PharmacyRepository repository;

  @override
  Future<Either<ErrorMsg, PharmacyAddToCartResultEntity>> call(
    AddToCartParams params,
  ) async {
    return await repository.addToCart(
      medicineId: params.medicineId,
      quantity: params.quantity,
      bookingId: params.bookingId,
    );
  }
}
