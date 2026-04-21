import '../../../../core/functional/functional_export.dart';
import '../entities/lab_test_catalog_entity.dart';

abstract class LabTestRepository {
  Future<Either<ErrorMsg, LabTestCatalogEntity>> getLabTestCatalog();
}
