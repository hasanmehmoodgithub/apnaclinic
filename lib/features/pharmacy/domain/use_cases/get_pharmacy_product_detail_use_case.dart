import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/pharmacy_product_detail_entity.dart';
import '../repositories/pharmacy_repository.dart';

class GetPharmacyProductDetailParams {
  const GetPharmacyProductDetailParams({required this.productId});

  final String productId;
}

class GetPharmacyProductDetailUseCase
    implements UseCase<PharmacyProductDetailEntity, GetPharmacyProductDetailParams> {
  GetPharmacyProductDetailUseCase({required this.repository});

  final PharmacyRepository repository;

  @override
  Future<Either<ErrorMsg, PharmacyProductDetailEntity>> call(
    GetPharmacyProductDetailParams params,
  ) async {
    return repository.getPharmacyProductDetail(productId: params.productId);
  }
}
