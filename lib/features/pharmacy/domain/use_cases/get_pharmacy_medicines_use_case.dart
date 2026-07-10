import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/pharmacy_products_page_entity.dart';
import '../repositories/pharmacy_repository.dart';

class GetPharmacyMedicinesParams {
  const GetPharmacyMedicinesParams({
    this.page = 1,
    this.displayName = '',
  });

  final int page;
  final String displayName;
}

class GetPharmacyMedicinesUseCase
    implements
        UseCase<PharmacyProductsPageEntity, GetPharmacyMedicinesParams> {
  GetPharmacyMedicinesUseCase({required this.repository});

  final PharmacyRepository repository;

  @override
  Future<Either<ErrorMsg, PharmacyProductsPageEntity>> call(
    GetPharmacyMedicinesParams params,
  ) async {
    return repository.getPharmacyProducts(
      page: params.page,
      displayName: params.displayName,
    );
  }
}
