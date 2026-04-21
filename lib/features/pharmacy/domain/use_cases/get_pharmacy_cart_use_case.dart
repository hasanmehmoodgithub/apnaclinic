import '../../../../core/failure/exceptions.dart';
import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/pharmacy_cart_item_entity.dart';
import '../repositories/pharmacy_repository.dart';

class GetPharmacyCartParams {
  const GetPharmacyCartParams();
}

class GetPharmacyCartUseCase
    implements UseCase<List<PharmacyCartItemEntity>, GetPharmacyCartParams> {
  GetPharmacyCartUseCase({required this.repository});

  final PharmacyRepository repository;

  @override
  Future<Either<ErrorMsg, List<PharmacyCartItemEntity>>> call(
    GetPharmacyCartParams params,
  ) async {
    return await repository.getPharmacyCart();
  }
}
