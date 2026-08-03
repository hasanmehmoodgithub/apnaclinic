import '../../../../core/functional/functional_export.dart';
import '../entities/pharmacy_add_address_result_entity.dart';
import '../entities/pharmacy_cart_address_entity.dart';
import '../entities/pharmacy_cart_entity.dart';
import '../entities/pharmacy_add_to_cart_result_entity.dart';
import '../entities/pharmacy_booking_entity.dart';
import '../entities/pharmacy_checkout_result_entity.dart';
import '../entities/pharmacy_products_page_entity.dart';
import '../entities/pharmacy_product_detail_entity.dart';

abstract class PharmacyRepository {
  Future<Either<ErrorMsg, PharmacyProductsPageEntity>> getPharmacyProducts({
    required int page,
    String displayName = '',
  });

  Future<Either<ErrorMsg, PharmacyProductDetailEntity>> getPharmacyProductDetail({
    required String productId,
  });

  Future<Either<ErrorMsg, PharmacyCartEntity>> getPharmacyCart();
  Future<Either<ErrorMsg, PharmacyAddToCartResultEntity>> addToCart({
    required String medicineId,
    required int quantity,
  });
  Future<Either<ErrorMsg, PharmacyAddToCartResultEntity>> updateCartQuantity({
    required String productId,
    required String quantity,
  });

  Future<Either<ErrorMsg, PharmacyCheckoutResultEntity>> checkoutOrder({
    required String userLocationId,
    required String paymentMethod,
    List<Map<String, dynamic>> prescriptions = const [],
  });

  Future<Either<ErrorMsg, List<PharmacyCartAddressEntity>>> getProfileAddresses();

  Future<Either<ErrorMsg, PharmacyAddAddressResultEntity>> addProfileAddress({
    required String address,
    required String region,
    required String line1,
    required String cityId,
    String lat = '0',
    String long = '0',
  });

  Future<Either<ErrorMsg, PharmacyBookingsPageEntity>> getPharmacyBookings({
    int page = 1,
    int limit = 20,
  });
}
