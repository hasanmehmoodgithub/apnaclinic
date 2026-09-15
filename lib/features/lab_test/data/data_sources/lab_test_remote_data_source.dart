import '../models/lab_list_response_model.dart';
import '../models/lab_order_model.dart';
import '../models/lab_test_catalog_model.dart';
import '../models/lab_test_detail_response_model.dart';
import '../models/lab_test_mobile_tests_response_model.dart';
import '../../domain/use_cases/abandon_lab_test_booking_use_case.dart';
import '../../../payment/domain/entities/payment_initiation_result.dart';

abstract class LabTestRemoteDataSource {
  Future<LabTestCatalogResponseModel> getLabTestCatalog();

  Future<LabListResponseModel> getLabs({required String cityId});

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

  Future<PaymentInitiationResult> bookLabTest(Map<String, dynamic> body);

  Future<Map<String, dynamic>> abandonLabTestBooking(
    AbandonLabTestBookingParams params,
  );

  Future<LabOrdersPageModel> getLabOrders({
    int page = 1,
    int limit = 20,
  });

  Future<LabOrderModel> getLabOrderDetail({required String orderId});

  Future<String> downloadLabReport({
    required String url,
    required String fileName,
  });
}
