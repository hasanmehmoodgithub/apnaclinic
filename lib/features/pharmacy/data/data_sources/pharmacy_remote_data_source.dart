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
    required String guestPhone,
    required String guestName,
    required String paymentMethod,
    required String guestAddressCityId,
  });

  Future<Map<String, dynamic>> addProfileAddress({
    required String address,
    required String region,
    String lat = '',
    String long = '',
  });
}
