import '../../domain/entities/prescription_extract_entity.dart';
import '../../domain/use_cases/abandon_pharmacy_order_use_case.dart';
import '../../domain/use_cases/pharmacy_checkout_use_case.dart';
import '../models/pharmacy_booking_detail_model.dart';
import '../models/pharmacy_booking_model.dart';
import '../models/pharmacy_city_model.dart';
import '../models/pharmacy_medicine_model.dart';

abstract class PharmacyRemoteDataSource {
  Future<List<PharmacyCityModel>> getPharmacyCities();

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

  Future<Map<String, dynamic>> uploadPrescription({
    required String productId,
    required String filePath,
    required String fileName,
  });

  Future<Map<String, dynamic>> checkoutOrder(PharmacyCheckoutParams params);

  Future<Map<String, dynamic>> abandonOrder(AbandonPharmacyOrderParams params);

  Future<List<PharmacyCartAddressModel>> getProfileAddresses();

  Future<Map<String, dynamic>> addProfileAddress({
    required String address,
    required String region,
    required String line1,
    required String cityId,
    String lat = '0',
    String long = '0',
  });

  Future<PharmacyBookingsPageModel> getPharmacyBookings({
    int page = 1,
    int limit = 20,
  });

  Future<PharmacyBookingDetailModel> getPharmacyBookingDetail({
    required String orderId,
  });

  Future<PrescriptionExtractEntity> extractPrescription({
    required String filePath,
  });
}
