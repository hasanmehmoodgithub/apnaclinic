import '../models/pharmacy_medicine_model.dart';

abstract class PharmacyRemoteDataSource {
  Future<PharmacyProductsPageModel> getPharmacyProducts({
    required int page,
    String displayName = '',
  });

  Future<PharmacyProductDetailModel> getPharmacyProductDetail({
    required String productId,
  });

  Future<PharmacyCartResponseModel> getPharmacyCart();
  Future<Map<String, dynamic>> addToCart({
    required String medicineId,
    required int quantity,
  });
  Future<Map<String, dynamic>> updateCartQuantity({
    required String productId,
    required String quantity,
  });

  Future<Map<String, dynamic>> checkoutOrder({
    required String userLocationId,
    required String paymentMethod,
    List<Map<String, dynamic>> prescriptions = const [],
  });

  Future<List<PharmacyCartAddressModel>> getProfileAddresses();

  Future<Map<String, dynamic>> addProfileAddress({
    required String address,
    required String region,
    required String line1,
    required String cityId,
    String lat = '0',
    String long = '0',
  });
}
