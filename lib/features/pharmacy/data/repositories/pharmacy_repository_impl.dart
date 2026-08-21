import 'dart:developer';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/pharmacy_add_address_result_entity.dart';
import '../../domain/entities/pharmacy_add_to_cart_result_entity.dart';
import '../../domain/entities/pharmacy_booking_detail_entity.dart';
import '../../domain/entities/pharmacy_booking_entity.dart';
import '../../domain/entities/pharmacy_cart_address_entity.dart';
import '../../domain/entities/pharmacy_cart_entity.dart';
import '../../domain/entities/pharmacy_checkout_result_entity.dart';
import '../../domain/entities/pharmacy_products_page_entity.dart';
import '../../domain/entities/pharmacy_product_detail_entity.dart';
import '../../domain/repositories/pharmacy_repository.dart';
import '../../domain/use_cases/abandon_pharmacy_order_use_case.dart';
import '../../domain/use_cases/pharmacy_checkout_use_case.dart';
import '../data_sources/pharmacy_remote_data_source.dart';
import '../mappers/pharmacy_bookings_mapper.dart';
import '../mappers/pharmacy_medicine_mapper.dart';
import '../models/pharmacy_medicine_model.dart';
import '../pharmacy_cart_api_failure.dart';

class PharmacyRepositoryImpl implements PharmacyRepository {
  PharmacyRepositoryImpl({required this.remoteDataSource});

  final PharmacyRemoteDataSource remoteDataSource;
  int? _failedPaymentUnifiedOrderId;

  @override
  int? consumeFailedPaymentUnifiedOrderId() {
    final id = _failedPaymentUnifiedOrderId;
    _failedPaymentUnifiedOrderId = null;
    return id;
  }

  void _rememberFailedPayment(Object error) {
    if (error is! PharmacyCartApiFailure) return;
    final id = error.failedPaymentUnifiedOrderId ?? 0;
    if (id == 0) return;
    _failedPaymentUnifiedOrderId = id;
  }

  @override
  Future<Either<ErrorMsg, PharmacyProductsPageEntity>> getPharmacyProducts({
    required int page,
    String displayName = '',
  }) async {
    try {
      final model = await remoteDataSource.getPharmacyProducts(
        page: page,
        displayName: displayName,
      );
      final entity = PharmacyMedicineMapper.toProductsPageEntity(model);
      log('Mapped pharmacy products count: ${entity.items.length}');
      return Right(entity);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, PharmacyProductDetailEntity>> getPharmacyProductDetail({
    required String productId,
  }) async {
    try {
      final model = await remoteDataSource.getPharmacyProductDetail(
        productId: productId,
      );
      final entity = PharmacyMedicineMapper.toProductDetailEntity(model);
      log('Mapped pharmacy product detail id: ${entity.product.id}');
      return Right(entity);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, PharmacyCartEntity>> getPharmacyCart() async {
    try {
      final model = await remoteDataSource.getPharmacyCart();
      final entity = PharmacyMedicineMapper.toCartEntity(model);
      log('Mapped pharmacy cart count: ${entity.items.length}');
      return Right(entity);
    } catch (e) {
      _rememberFailedPayment(e);
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, PharmacyAddToCartResultEntity>> addToCart({
    required String medicineId,
    required int quantity,
  }) async {
    try {
      final response = await remoteDataSource.addToCart(
        medicineId: medicineId,
        quantity: quantity,
      );
      final model = PharmacyCartResponseModel.fromJson(response);
      final entity = PharmacyMedicineMapper.toAddToCartResultEntity(model);
      log('Mapped add-to-cart bookingId: ${entity.bookingId}');
      return Right(entity);
    } catch (e) {
      _rememberFailedPayment(e);
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, PharmacyAddToCartResultEntity>> updateCartQuantity({
    required String productId,
    required String quantity,
  }) async {
    try {
      final response = await remoteDataSource.updateCartQuantity(
        productId: productId,
        quantity: quantity,
      );
      final model = PharmacyCartResponseModel.fromJson(response);
      final entity = PharmacyMedicineMapper.toAddToCartResultEntity(model);
      log('Mapped update-cart bookingId: ${entity.bookingId}');
      return Right(entity);
    } catch (e) {
      _rememberFailedPayment(e);
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, String>> uploadPrescription({
    required String productId,
    required String filePath,
    required String fileName,
  }) async {
    try {
      final response = await remoteDataSource.uploadPrescription(
        productId: productId,
        filePath: filePath,
        fileName: fileName,
      );
      final url = PharmacyMedicineMapper.prescriptionUrlFromUploadResponse(
        response,
      );
      if (url.isEmpty) {
        return const Left(AppStrings.pharmacyPrescriptionUploadError);
      }
      log('Mapped prescription upload url: $url');
      return Right(url);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, PharmacyCheckoutResultEntity>> checkoutOrder(
    PharmacyCheckoutParams params,
  ) async {
    try {
      final response = await remoteDataSource.checkoutOrder(params);
      final entity = PharmacyMedicineMapper.toCheckoutResultEntity(response);
      log('Mapped checkout orderNo: ${entity.orderNo}');
      return Right(entity);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, bool>> abandonOrder(
    AbandonPharmacyOrderParams params,
  ) async {
    try {
      await remoteDataSource.abandonOrder(params);
      return const Right(true);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, List<PharmacyCartAddressEntity>>>
      getProfileAddresses() async {
    try {
      final models = await remoteDataSource.getProfileAddresses();
      final entities = models
          .map(
            (model) => PharmacyCartAddressEntity(
              id: model.id,
              address: model.address,
              region: model.region,
              cityId: model.cityId,
              isDefault: model.isDefault,
            ),
          )
          .toList(growable: false);
      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, PharmacyAddAddressResultEntity>> addProfileAddress({
    required String address,
    required String region,
    required String line1,
    required String cityId,
    String lat = '0',
    String long = '0',
  }) async {
    try {
      final response = await remoteDataSource.addProfileAddress(
        address: address,
        region: region,
        line1: line1,
        cityId: cityId,
        lat: lat,
        long: long,
      );
      final entity = PharmacyMedicineMapper.toAddAddressResultEntity(response);
      log('Mapped add address id: ${entity.id}');
      return Right(entity);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, PharmacyBookingsPageEntity>> getPharmacyBookings({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final model = await remoteDataSource.getPharmacyBookings(
        page: page,
        limit: limit,
      );
      final entity = PharmacyBookingsMapper.toPageEntity(model);
      log('Mapped pharmacy bookings count: ${entity.items.length}');
      return Right(entity);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, PharmacyBookingDetailEntity>> getPharmacyBookingDetail({
    required String orderId,
  }) async {
    try {
      final model = await remoteDataSource.getPharmacyBookingDetail(
        orderId: orderId,
      );
      final entity = PharmacyBookingsMapper.toDetailEntity(model);
      log('Mapped pharmacy booking detail id: ${entity.orderId}');
      return Right(entity);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
