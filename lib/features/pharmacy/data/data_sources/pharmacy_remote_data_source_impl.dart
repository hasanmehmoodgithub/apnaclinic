import 'dart:developer';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/utils/error_handler.dart';
import '../mock/pharmacy_mock_api.dart';
import '../models/pharmacy_medicine_model.dart';
import 'pharmacy_remote_data_source.dart';

class PharmacyRemoteDataSourceImpl implements PharmacyRemoteDataSource {
  PharmacyRemoteDataSourceImpl({
    required this.apiService,
    required this.mockApi,
  });

  final ApiService apiService;
  final PharmacyMockApi mockApi;

  @override
  Future<PharmacyMedicinesResponseModel> getPharmacyMedicines() async {
    try {
      final Map<String, dynamic> response;
      if (PharmacyMockApi.useMockResponses) {
        response = await mockApi.getPharmacyMedicinesSuccessResponse();
      } else {
        response = await apiService.get(AppUrls.pharmacyMedicines);
        log('getPharmacyMedicines response: $response');
      }

      if (response['success'] == true) {
        return Future.value(PharmacyMedicinesResponseModel.fromJson(response));
      }

      final message = (response['message'] ?? AppStrings.pharmacyLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.pharmacyMedicines,
      );
      return Future.error(message);
    }
  }

  @override
  Future<PharmacyCartResponseModel> getPharmacyCart() async {
    try {
      final Map<String, dynamic> response;
      if (PharmacyMockApi.useMockResponses) {
        response = await mockApi.getPharmacyCartSuccessResponse();
      } else {
        response = await apiService.get(AppUrls.pharmacyCart);
        log('getPharmacyCart response: $response');
      }

      if (response['success'] == true) {
        return Future.value(PharmacyCartResponseModel.fromJson(response));
      }

      final message = (response['message'] ?? AppStrings.pharmacyLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.pharmacyCart,
      );
      return Future.error(message);
    }
  }

  @override
  Future<Map<String, dynamic>> addToCart({
    required String medicineId,
    required int quantity,
  }) async {
    try {
      final Map<String, dynamic> response;
      if (PharmacyMockApi.useMockResponses) {
        response = await mockApi.addToCartSuccessResponse(
          medicineId: medicineId,
          quantity: quantity,
        );
      } else {
        response = await apiService.post(
          AppUrls.pharmacyAddToCart,
          data: {'medicineId': medicineId, 'quantity': quantity},
        );
        log('addToCart response: $response');
      }

      if (response['success'] == true) {
        return response;
      }

      final message = (response['message'] ?? AppStrings.pharmacyLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.pharmacyAddToCart,
      );
      return Future.error(message);
    }
  }
}
