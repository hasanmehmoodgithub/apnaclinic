import '../models/lab_test_catalog_model.dart';
import '../models/lab_test_detail_response_model.dart';
import '../models/lab_test_mobile_tests_response_model.dart';

abstract class LabTestRemoteDataSource {
  Future<LabTestCatalogResponseModel> getLabTestCatalog();

  Future<LabTestMobileTestsResponseModel> getLabTests({
    required String cityId,
    int page = 1,
    int limit = 20,
    String? search,
    String? labId,
  });

  Future<LabTestDetailResponseModel> getLabTestDetail({
    required int testId,
    required String cityId,
  });
}
