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
    String? bookingId,
  });
  Future<Map<String, dynamic>> updateCartQuantity({
    required String bookingId,
    required String productId,
    required String quantity,
  });
}
