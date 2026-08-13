import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/utils/error_handler.dart';
import '../mock/pharmacy_mock_api.dart';
import '../models/pharmacy_booking_detail_model.dart';
import '../models/pharmacy_booking_model.dart';
import '../models/pharmacy_medicine_model.dart';
import 'pharmacy_remote_data_source.dart';

class PharmacyRemoteDataSourceImpl implements PharmacyRemoteDataSource {
  PharmacyRemoteDataSourceImpl({
    required this.apiService,
    required this.mockApi,
  });

  final ApiService apiService;
  final PharmacyMockApi mockApi;

  static bool _isSuccessResponse(Map<String, dynamic> response) {
    if (response['success'] == true) return true;
    final code = response['code'];
    return code is num && code.toInt() == 200;
  }

  @override
  Future<PharmacyProductsPageModel> getPharmacyProducts({
    required int page,
    String displayName = '',
  }) async {
    try {
      final Map<String, dynamic> response;
      if (PharmacyMockApi.useMockResponses) {
        response = await mockApi.getPharmacyProductsSuccessResponse(
          page: page,
          displayName: displayName,
        );
      } else {
        response = await apiService.post(
          AppUrls.pharmacyProducts,
          data: <String, dynamic>{
            'page': page.toString(),
            'display_name': displayName.trim(),
          },
        );
        log('getPharmacyProducts response: $response');
      }

      if (_isSuccessResponse(response)) {
        return PharmacyProductsPageModel.fromJson(response);
      }

      final message = (response['message'] ?? AppStrings.pharmacyLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.pharmacyProducts,
      );
      return Future.error(message);
    }
  }

  @override
  Future<PharmacyProductDetailModel> getPharmacyProductDetail({
    required String productId,
  }) async {
    try {
      final Map<String, dynamic> response;
      if (PharmacyMockApi.useMockResponses) {
        response = await mockApi.getPharmacyProductDetailSuccessResponse(
          productId: productId,
        );
      } else {
        final productIdInt = int.tryParse(productId.trim());
        if (productIdInt == null) {
          return Future.error(AppStrings.pharmacyLoadError);
        }

        response = await apiService.post(
          AppUrls.pharmacyProductDetail,
          data: <String, dynamic>{
            'product_id': productIdInt,
            'similar_items': true,
          },
        );
        log('getPharmacyProductDetail response: $response');
      }

      if (_isSuccessResponse(response)) {
        return PharmacyProductDetailModel.fromJson(response);
      }

      final message = (response['message'] ?? AppStrings.pharmacyLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.pharmacyProductDetail,
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
        response = await apiService.post(
          AppUrls.pharmacyCart,
          data: <String, dynamic>{},
        );
        log('getPharmacyCart response: $response');
      }

      if (_isSuccessResponse(response)) {
        return PharmacyCartResponseModel.fromJson(response);
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
        final productId = int.tryParse(medicineId.trim());
        if (productId == null) {
          return Future.error(AppStrings.pharmacyLoadError);
        }

        response = await apiService.post(
          AppUrls.pharmacyAddToCart,
          data: <String, dynamic>{
            'product_id': productId,
            'quantity': quantity,
          },
        );
        log('addToCart response: $response');
      }

      if (_isSuccessResponse(response)) {
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

  @override
  Future<Map<String, dynamic>> updateCartQuantity({
    required String productId,
    required String quantity,
  }) async {
    try {
      final Map<String, dynamic> response;
      if (PharmacyMockApi.useMockResponses) {
        response = await mockApi.updateCartQuantitySuccessResponse(
          productId: productId,
          quantity: quantity,
        );
      } else {
        final productIdInt = int.tryParse(productId.trim());
        final quantityInt = int.tryParse(quantity.trim());
        if (productIdInt == null || quantityInt == null) {
          return Future.error(AppStrings.pharmacyLoadError);
        }

        response = await apiService.post(
          AppUrls.pharmacyUpdateCartQuantity,
          data: <String, dynamic>{
            'product_id': productIdInt,
            'quantity': quantityInt,
          },
        );
        log('updateCartQuantity response: $response');
      }

      if (_isSuccessResponse(response)) {
        return response;
      }

      final message = (response['message'] ?? AppStrings.pharmacyLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.pharmacyUpdateCartQuantity,
      );
      return Future.error(message);
    }
  }

  @override
  Future<Map<String, dynamic>> uploadPrescription({
    required String productId,
    required String filePath,
    required String fileName,
  }) async {
    try {
      final Map<String, dynamic> response;
      if (PharmacyMockApi.useMockResponses) {
        response = await mockApi.uploadPrescriptionSuccessResponse(
          productId: productId,
          fileName: fileName,
        );
      } else {
        final productIdInt = int.tryParse(productId.trim());
        if (productIdInt == null) {
          return Future.error(AppStrings.pharmacyPrescriptionUploadError);
        }

        final formData = FormData.fromMap(<String, dynamic>{
          'product_id': productIdInt,
          'prescription': await MultipartFile.fromFile(
            filePath,
            filename: fileName,
          ),
        });

        response = await apiService.post(
          AppUrls.pharmacyPrescriptionUpload,
          data: formData,
          headers: const {'Content-Type': 'multipart/form-data'},
        );
        log('uploadPrescription response: $response');
      }

      if (_isSuccessResponse(response)) {
        return response;
      }

      final message =
          (response['message'] ?? AppStrings.pharmacyPrescriptionUploadError)
              .toString();
      return Future.error(message);
    } catch (e) {
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.pharmacyPrescriptionUpload,
      );
      return Future.error(message);
    }
  }

  @override
  Future<Map<String, dynamic>> checkoutOrder({
    required String userLocationId,
    required String paymentMethod,
    List<Map<String, dynamic>> prescriptions = const [],
  }) async {
    try {
      final Map<String, dynamic> response;
      if (PharmacyMockApi.useMockResponses) {
        response = await mockApi.checkoutOrderSuccessResponse(
          userLocationId: userLocationId,
          paymentMethod: paymentMethod,
          prescriptions: prescriptions,
        );
      } else {
        response = await apiService.post(
          AppUrls.pharmacyOrderCheckout,
          data: <String, dynamic>{
            'user_location_id': userLocationId,
            'payment_method': paymentMethod,
            'prescriptions': prescriptions,
          },
        );
        log('checkoutOrder response: $response');
      }

      if (_isSuccessResponse(response)) {
        return response;
      }

      final message = (response['message'] ?? AppStrings.pharmacyCheckoutError)
          .toString();
      return Future.error(message);
    } catch (e) {
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.pharmacyOrderCheckout,
      );
      return Future.error(message);
    }
  }

  @override
  Future<Map<String, dynamic>> addProfileAddress({
    required String address,
    required String region,
    required String line1,
    required String cityId,
    String lat = '0',
    String long = '0',
  }) async {
    try {
      final Map<String, dynamic> response;
      if (PharmacyMockApi.useMockResponses) {
        response = await mockApi.addProfileAddressSuccessResponse(
          address: address,
          region: region,
          line1: line1,
          cityId: cityId,
          lat: lat,
          long: long,
        );
      } else {
        response = await apiService.post(
          AppUrls.pharmacyProfileAddress,
          data: <String, dynamic>{
            'lat': lat.isEmpty ? '0' : lat,
            'long': long.isEmpty ? '0' : long,
            'category': <String, dynamic>{},
            'address': address,
            'region': region,
            'line1': line1,
            'city_id': cityId,
          },
        );
        log('addProfileAddress response: $response');
      }

      if (_isSuccessResponse(response)) {
        return response;
      }

      final message =
          (response['message'] ?? AppStrings.pharmacyAddAddressError).toString();
      return Future.error(message);
    } catch (e) {
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.pharmacyProfileAddress,
      );
      return Future.error(message);
    }
  }

  @override
  Future<List<PharmacyCartAddressModel>> getProfileAddresses() async {
    try {
      final Map<String, dynamic> response;
      if (PharmacyMockApi.useMockResponses) {
        response = await mockApi.getProfileAddressesSuccessResponse();
      } else {
        response = await apiService.post(
          AppUrls.pharmacyProfileAddressesList,
          data: <String, dynamic>{},
        );
        log('getProfileAddresses response: $response');
      }

      if (!_isSuccessResponse(response)) {
        final message =
            (response['message'] ?? AppStrings.pharmacyAddAddressError)
                .toString();
        return Future.error(message);
      }

      final data = response['data'];
      if (data is! List) return const [];

      return data
          .whereType<Map>()
          .map(
            (item) => PharmacyCartAddressModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .where((item) => item.address.isNotEmpty || item.id.isNotEmpty)
          .toList(growable: false);
    } catch (e) {
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.pharmacyProfileAddressesList,
      );
      return Future.error(message);
    }
  }

  @override
  Future<PharmacyBookingsPageModel> getPharmacyBookings({
    int page = 1,
    int limit = 20,
  }) async {
    final endpoint = AppUrls.pharmacyBookings(page: page, limit: limit);
    try {
      final Map<String, dynamic> response;
      if (PharmacyMockApi.useMockResponses) {
        response = await mockApi.getPharmacyBookingsSuccessResponse(
          page: page,
          limit: limit,
        );
      } else {
        response = await apiService.get(endpoint);
        log('getPharmacyBookings response: $response');
      }

      if (_isSuccessResponse(response)) {
        return PharmacyBookingsPageModel.fromJson(response);
      }

      final message = (response['message'] ?? AppStrings.pharmacyLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: endpoint,
      );
      return Future.error(message);
    }
  }

  @override
  Future<PharmacyBookingDetailModel> getPharmacyBookingDetail({
    required String orderId,
  }) async {
    final endpoint = AppUrls.pharmacyBookingDetail(orderId);
    try {
      final Map<String, dynamic> response;
      if (PharmacyMockApi.useMockResponses) {
        response = await mockApi.getPharmacyBookingDetailSuccessResponse(
          orderId: orderId,
        );
      } else {
        response = await apiService.get(endpoint);
        log('getPharmacyBookingDetail response: $response');
      }

      if (_isSuccessResponse(response)) {
        return PharmacyBookingDetailModel.fromJson(response);
      }

      final message = (response['message'] ?? AppStrings.pharmacyLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: endpoint,
      );
      return Future.error(message);
    }
  }
}
