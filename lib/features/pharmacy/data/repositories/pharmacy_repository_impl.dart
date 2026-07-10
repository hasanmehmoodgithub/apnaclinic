import 'dart:developer';

import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/pharmacy_add_to_cart_result_entity.dart';
import '../../domain/entities/pharmacy_cart_entity.dart';
import '../../domain/entities/pharmacy_products_page_entity.dart';
import '../../domain/entities/pharmacy_product_detail_entity.dart';
import '../../domain/repositories/pharmacy_repository.dart';
import '../data_sources/pharmacy_remote_data_source.dart';
import '../mappers/pharmacy_medicine_mapper.dart';
import '../models/pharmacy_medicine_model.dart';

class PharmacyRepositoryImpl implements PharmacyRepository {
  PharmacyRepositoryImpl({required this.remoteDataSource});

  final PharmacyRemoteDataSource remoteDataSource;

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
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, PharmacyAddToCartResultEntity>> addToCart({
    required String medicineId,
    required int quantity,
    String? bookingId,
  }) async {
    try {
      final response = await remoteDataSource.addToCart(
        medicineId: medicineId,
        quantity: quantity,
        bookingId: bookingId,
      );
      final model = PharmacyCartResponseModel.fromJson(response);
      final entity = PharmacyMedicineMapper.toAddToCartResultEntity(model);
      log('Mapped add-to-cart bookingId: ${entity.bookingId}');
      return Right(entity);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, PharmacyAddToCartResultEntity>> updateCartQuantity({
    required String bookingId,
    required String productId,
    required String quantity,
  }) async {
    try {
      final response = await remoteDataSource.updateCartQuantity(
        bookingId: bookingId,
        productId: productId,
        quantity: quantity,
      );
      final model = PharmacyCartResponseModel.fromJson(response);
      final entity = PharmacyMedicineMapper.toAddToCartResultEntity(model);
      log('Mapped update-cart bookingId: ${entity.bookingId}');
      return Right(entity);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
