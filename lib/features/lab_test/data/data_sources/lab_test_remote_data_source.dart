import '../models/lab_test_catalog_model.dart';

abstract class LabTestRemoteDataSource {
  Future<LabTestCatalogResponseModel> getLabTestCatalog();
}
