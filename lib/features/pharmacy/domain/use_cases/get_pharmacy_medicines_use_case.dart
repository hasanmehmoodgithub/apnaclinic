import '../../../../core/failure/exceptions.dart';
import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/pharmacy_medicine_entity.dart';
import '../repositories/pharmacy_repository.dart';

class GetPharmacyMedicinesParams {
  const GetPharmacyMedicinesParams();
}

class GetPharmacyMedicinesUseCase
    implements UseCase<List<PharmacyMedicineEntity>, GetPharmacyMedicinesParams> {
  GetPharmacyMedicinesUseCase({required this.repository});

  final PharmacyRepository repository;

  @override
  Future<Either<ErrorMsg, List<PharmacyMedicineEntity>>> call(
    GetPharmacyMedicinesParams params,
  ) async {
    return await repository.getPharmacyMedicines();
  }
}
