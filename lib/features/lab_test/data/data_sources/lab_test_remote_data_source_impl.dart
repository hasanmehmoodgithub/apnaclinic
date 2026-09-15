import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/network/dio_app_network_config.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../payment/domain/entities/payment_initiation_result.dart';
import '../../domain/use_cases/abandon_lab_test_booking_use_case.dart';
import '../mock/lab_orders_mock_api.dart';
import '../mock/lab_test_mock_api.dart';
import '../models/lab_list_response_model.dart';
import '../models/lab_order_model.dart';
import '../models/lab_test_catalog_model.dart';
import '../models/lab_test_detail_response_model.dart';
import '../models/lab_test_mobile_tests_response_model.dart';
import 'lab_test_remote_data_source.dart';

class LabTestRemoteDataSourceImpl implements LabTestRemoteDataSource {
  LabTestRemoteDataSourceImpl({
    required this.apiService,
    required this.mockApi,
    required this.labOrdersMockApi,
  });

  final ApiService apiService;
  final LabTestMockApi mockApi;
  final LabOrdersMockApi labOrdersMockApi;

  static bool _isSuccessResponse(Map<String, dynamic> response) {
    if (response['success'] == true) return true;
    final code = response['code'];
    return code is num && code.toInt() == 200;
  }

  @override
  Future<LabTestCatalogResponseModel> getLabTestCatalog() async {
    try {
      final Map<String, dynamic> response;
      if (LabTestMockApi.useMockResponses) {
        response = await mockApi.getLabTestCatalogSuccessResponse();
      } else {
        response = await apiService.get(AppUrls.labTestCatalog);
        log('getLabTestCatalog response: $response');
      }

      if (_isSuccessResponse(response)) {
        return Future.value(LabTestCatalogResponseModel.fromJson(response));
      }

      final message = (response['message'] ?? AppStrings.ourServicesLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.labTestCatalog,
      );
      return Future.error(message);
    }
  }

  @override
  Future<LabListResponseModel> getLabs({required String cityId}) async {
    final endpoint = AppUrls.labs(cityId: cityId);
    try {
      final Map<String, dynamic> response;
      if (LabTestMockApi.useMockResponses) {
        response = await mockApi.getLabsSuccessResponse(cityId: cityId);
      } else {
        response = await apiService.get(endpoint);
        log('getLabs response: $response');
      }

      final parsed = LabListResponseModel.fromJson(response);
      if (_isSuccessResponse(response) || parsed.labs.isNotEmpty) {
        return parsed;
      }

      if (response['data'] != null) {
        return parsed;
      }

      final message = (response['message'] ?? AppStrings.ourServicesLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      final message = ErrorHandler.handleExceptions(e, endpoint: endpoint);
      return Future.error(message);
    }
  }

  @override
  Future<LabTestMobileTestsResponseModel> getLabTests({
    required String cityId,
    int page = 1,
    int limit = 20,
    String? search,
    String? labId,
  }) async {
    final endpoint = AppUrls.labTests(
      cityId: cityId,
      page: page,
      limit: limit,
      search: search,
      labId: labId,
    );

    try {
      final Map<String, dynamic> response;
      if (LabTestMockApi.useMockResponses) {
        response = await mockApi.getLabTestsSuccessResponse(
          cityId: cityId,
          page: page,
          limit: limit,
          search: search,
          labId: labId,
        );
      } else {
        response = await apiService.get(endpoint);
        log('getLabTests response: $response');
      }

      if (_isSuccessResponse(response)) {
        return LabTestMobileTestsResponseModel.fromJson(response);
      }

      final message = (response['message'] ?? AppStrings.ourServicesLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      final message = ErrorHandler.handleExceptions(e, endpoint: endpoint);
      return Future.error(message);
    }
  }

  @override
  Future<LabTestDetailResponseModel> getLabTestDetail({
    required int testId,
    required String cityId,
  }) async {
    final endpoint = AppUrls.labTestDetail(testId: testId, cityId: cityId);

    try {
      final Map<String, dynamic> response;
      if (LabTestMockApi.useMockResponses) {
        response = await mockApi.getLabTestDetailSuccessResponse(
          testId: testId,
          cityId: cityId,
        );
      } else {
        response = await apiService.get(endpoint);
        log('getLabTestDetail response: $response');
      }

      if (_isSuccessResponse(response)) {
        return LabTestDetailResponseModel.fromJson(response);
      }

      final message = (response['message'] ?? AppStrings.ourServicesLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      final message = ErrorHandler.handleExceptions(e, endpoint: endpoint);
      return Future.error(message);
    }
  }

  @override
  Future<LabOrdersPageModel> getLabOrders({
    int page = 1,
    int limit = 20,
  }) async {
    final endpoint = AppUrls.labOrders(page: page, limit: limit);

    try {
      final Map<String, dynamic> response;
      if (LabOrdersMockApi.useMockResponses) {
        response = await labOrdersMockApi.getLabOrdersSuccessResponse(
          page: page,
          limit: limit,
        );
      } else {
        response = await apiService.get(endpoint);
        log('getLabOrders response: $response');
      }

      if (_isSuccessResponse(response)) {
        return LabOrdersPageModel.fromJson(response);
      }

      final message = (response['message'] ?? AppStrings.ourServicesLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      final message = ErrorHandler.handleExceptions(e, endpoint: endpoint);
      return Future.error(message);
    }
  }

  @override
  Future<LabOrderModel> getLabOrderDetail({required String orderId}) async {
    final trimmedId = orderId.trim();
    final endpoint = AppUrls.labOrderById(trimmedId);

    try {
      final Map<String, dynamic> response;
      if (LabOrdersMockApi.useMockResponses) {
        response = await labOrdersMockApi.getLabOrderDetailSuccessResponse(
          orderId: trimmedId,
        );
      } else {
        response = await apiService.get(endpoint);
        log('getLabOrderDetail response: $response');
      }

      if (_isSuccessResponse(response)) {
        return LabOrderModel.fromDetailResponse(response);
      }

      final message = (response['message'] ?? AppStrings.ourServicesLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      final message = ErrorHandler.handleExceptions(e, endpoint: endpoint);
      return Future.error(message);
    }
  }

  @override
  Future<PaymentInitiationResult> bookLabTest(Map<String, dynamic> body) async {
    try {
      final Map<String, dynamic> response;
      if (LabTestMockApi.useMockResponses) {
        response = await mockApi.bookLabTestSuccessResponse(body);
      } else {
        response = await apiService.post(AppUrls.labBookTest, data: body);
        log('bookLabTest response: $response');
      }

      if (_isSuccessResponse(response)) {
        return PaymentInitiationResult.fromBookingResponse(response);
      }

      final message = (response['message'] ?? AppStrings.ourServicesLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      log('bookLabTest error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.labBookTest,
      );
      return Future.error(message);
    }
  }

  @override
  Future<Map<String, dynamic>> abandonLabTestBooking(
    AbandonLabTestBookingParams params,
  ) async {
    try {
      final Map<String, dynamic> response;
      if (LabTestMockApi.useMockResponses) {
        response = await mockApi.abandonLabTestBookingSuccessResponse(params);
      } else {
        response = await apiService.post(
          AppUrls.labBookTestAbandon,
          data: params.toJson(),
        );
        log('abandonLabTestBooking response: $response');
      }

      if (_isSuccessResponse(response)) {
        return response;
      }

      final message =
          (response['message'] ?? AppStrings.labTestAbandonOrderError)
              .toString();
      return Future.error(message);
    } catch (e) {
      log('abandonLabTestBooking error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.labBookTestAbandon,
      );
      return Future.error(message);
    }
  }

  @override
  Future<String> downloadLabReport({
    required String url,
    required String fileName,
  }) async {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
        followRedirects: true,
        headers: const {
          'Accept': 'application/pdf,application/octet-stream,*/*',
          'User-Agent':
              'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 '
              '(KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
        },
      ),
    );
    configureDioForAppNetwork(dio);

    try {
      final docs = await getApplicationDocumentsDirectory();
      final dir = Directory(p.join(docs.path, 'lab_reports'));
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      final savePath = p.join(dir.path, fileName);
      await dio.download(url, savePath);

      final file = File(savePath);
      if (!await file.exists() || await file.length() == 0) {
        return Future.error(AppStrings.ourServicesLoadError);
      }
      final header = await file.openRead(0, 5).first;
      final isPdf = header.length >= 4 &&
          header[0] == 0x25 &&
          header[1] == 0x50 &&
          header[2] == 0x44 &&
          header[3] == 0x46;
      if (!isPdf) {
        await file.delete();
        return Future.error(AppStrings.ourServicesLoadError);
      }
      return savePath;
    } catch (e) {
      final message = ErrorHandler.handleExceptions(e, endpoint: url);
      return Future.error(message);
    } finally {
      dio.close();
    }
  }
}
