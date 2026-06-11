import '../../../../core/functional/functional_export.dart';
import '../entities/lab_test_catalog_entity.dart';
import '../entities/lab_test_detail_entity.dart';
import '../use_cases/get_lab_test_catalog_use_case.dart';
import '../use_cases/get_lab_test_detail_use_case.dart';

abstract class LabTestRepository {
  Future<Either<ErrorMsg, LabTestCatalogEntity>> getLabTestCatalog(
    GetLabTestCatalogParams params,
  );

  Future<Either<ErrorMsg, LabTestDetailEntity>> getLabTestDetail(
    GetLabTestDetailParams params,
  );
}
