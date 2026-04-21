import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/lab_test_catalog_entity.dart';
import '../repositories/lab_test_repository.dart';

class GetLabTestCatalogParams {
  const GetLabTestCatalogParams();
}

class GetLabTestCatalogUseCase
    implements UseCase<LabTestCatalogEntity, GetLabTestCatalogParams> {
  GetLabTestCatalogUseCase({required this.repository});

  final LabTestRepository repository;

  @override
  Future<Either<ErrorMsg, LabTestCatalogEntity>> call(
    GetLabTestCatalogParams params,
  ) async {
    return await repository.getLabTestCatalog();
  }
}
