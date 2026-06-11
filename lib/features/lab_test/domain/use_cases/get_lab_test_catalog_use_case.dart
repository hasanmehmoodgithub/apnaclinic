import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/lab_test_catalog_entity.dart';
import '../repositories/lab_test_repository.dart';

class GetLabTestCatalogParams {
  const GetLabTestCatalogParams.citiesOnly()
      : cityName = null,
        page = 1,
        limit = 20,
        search = null,
        labId = null,
        citiesOnly = true;

  const GetLabTestCatalogParams.forCity({
    required this.cityName,
    this.page = 1,
    this.limit = 20,
    this.search,
    this.labId,
  }) : citiesOnly = false;

  final bool citiesOnly;
  final String? cityName;
  final int page;
  final int limit;
  final String? search;
  final String? labId;
}

class GetLabTestCatalogUseCase
    implements UseCase<LabTestCatalogEntity, GetLabTestCatalogParams> {
  GetLabTestCatalogUseCase({required this.repository});

  final LabTestRepository repository;

  @override
  Future<Either<ErrorMsg, LabTestCatalogEntity>> call(
    GetLabTestCatalogParams params,
  ) async {
    return await repository.getLabTestCatalog(params);
  }
}
