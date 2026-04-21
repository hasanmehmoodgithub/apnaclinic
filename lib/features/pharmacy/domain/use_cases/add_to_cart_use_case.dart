import '../../../../core/failure/exceptions.dart';
import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../repositories/pharmacy_repository.dart';

class AddToCartParams {
  const AddToCartParams({
    required this.medicineId,
    required this.quantity,
  });

  final String medicineId;
  final int quantity;
}

class AddToCartUseCase implements UseCase<String, AddToCartParams> {
  AddToCartUseCase({required this.repository});

  final PharmacyRepository repository;

  @override
  Future<Either<ErrorMsg, String>> call(AddToCartParams params) async {
    return await repository.addToCart(
      medicineId: params.medicineId,
      quantity: params.quantity,
    );
  }
}
