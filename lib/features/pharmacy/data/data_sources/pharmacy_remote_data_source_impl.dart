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
          data: <String, dynamic>{'product_id': productIdInt},
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
    String? bookingId,
  }) async {
    try {
      final Map<String, dynamic> response;
      if (PharmacyMockApi.useMockResponses) {
        response = await mockApi.addToCartSuccessResponse(
          medicineId: medicineId,
          quantity: quantity,
          bookingId: bookingId,
        );
      } else {
        final productId = int.tryParse(medicineId.trim());
        if (productId == null) {
          return Future.error(AppStrings.pharmacyLoadError);
        }

        final trimmedBookingId = bookingId?.trim();
        final payload = <String, dynamic>{
          'product_id': productId,
          'quantity': quantity,
          if (trimmedBookingId != null && trimmedBookingId.isNotEmpty)
            'booking_id': trimmedBookingId,
        };

        response = await apiService.post(
          AppUrls.pharmacyAddToCart,
          data: payload,
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
    required String bookingId,
    required String productId,
    required String quantity,
  }) async {
    try {
      final Map<String, dynamic> response;
      if (PharmacyMockApi.useMockResponses) {
        response = await mockApi.updateCartQuantitySuccessResponse(
          bookingId: bookingId,
          productId: productId,
          quantity: quantity,
        );
      } else {
        response = await apiService.post(
          AppUrls.pharmacyUpdateCartQuantity,
          data: <String, dynamic>{
            'booking_id': bookingId,
            'product_id': productId,
            'quantity': quantity,
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
  Future<Map<String, dynamic>> checkoutOrder({
    required String bookingId,
    required String patientId,
    required String userLocationId,
    required String paymentMethod,
  }) async {
    try {
      final Map<String, dynamic> response;
      if (PharmacyMockApi.useMockResponses) {
        response = await mockApi.checkoutOrderSuccessResponse(
          bookingId: bookingId,
          patientId: patientId,
          userLocationId: userLocationId,
          paymentMethod: paymentMethod,
        );
      } else {
        response = await apiService.post(
          AppUrls.pharmacyOrderCheckout,
          data: <String, dynamic>{
            'booking_id': bookingId,
            'patient_id': patientId,
            'user_location_id': userLocationId,
            'payment_method': paymentMethod,
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
    String lat = '',
    String long = '',
  }) async {
    try {
      final Map<String, dynamic> response;
      if (PharmacyMockApi.useMockResponses) {
        response = await mockApi.addProfileAddressSuccessResponse(
          address: address,
          region: region,
          lat: lat,
          long: long,
        );
      } else {
        response = await apiService.post(
          AppUrls.pharmacyProfileAddress,
          data: <String, dynamic>{
            'lat': lat,
            'long': long,
            'category': <String, dynamic>{},
            'address': address,
            'region': region,
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
}
