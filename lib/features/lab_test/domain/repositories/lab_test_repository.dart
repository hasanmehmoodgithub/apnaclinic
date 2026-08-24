import '../../../../core/functional/functional_export.dart';
import '../../../payment/domain/entities/payment_initiation_result.dart';
import '../entities/lab_order_entity.dart';
import '../entities/lab_test_catalog_entity.dart';
import '../entities/lab_test_detail_entity.dart';
import '../use_cases/abandon_lab_test_booking_use_case.dart';
import '../use_cases/book_lab_test_use_case.dart';
import '../use_cases/download_lab_report_use_case.dart';
import '../use_cases/get_lab_test_catalog_use_case.dart';
import '../use_cases/get_lab_test_detail_use_case.dart';

abstract class LabTestRepository {
  Future<Either<ErrorMsg, LabTestCatalogEntity>> getLabTestCatalog(
    GetLabTestCatalogParams params,
  );

  Future<Either<ErrorMsg, LabTestDetailEntity>> getLabTestDetail(
    GetLabTestDetailParams params,
  );

  Future<Either<ErrorMsg, PaymentInitiationResult>> bookLabTest(
    BookLabTestParams params,
  );

  Future<Either<ErrorMsg, bool>> abandonLabTestBooking(
    AbandonLabTestBookingParams params,
  );

  Future<Either<ErrorMsg, LabOrdersPageEntity>> getLabOrders({
    int page = 1,
    int limit = 20,
  });

  Future<Either<ErrorMsg, LabOrderEntity>> getLabOrderDetail({
    required String orderId,
  });

  Future<Either<ErrorMsg, String>> downloadLabReport(
    DownloadLabReportParams params,
  );
}
