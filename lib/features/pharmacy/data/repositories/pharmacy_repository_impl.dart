import 'dart:developer';

import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/pharmacy_cart_item_entity.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import '../../domain/repositories/pharmacy_repository.dart';
import '../data_sources/pharmacy_remote_data_source.dart';
import '../mappers/pharmacy_medicine_mapper.dart';

class PharmacyRepositoryImpl implements PharmacyRepository {
  PharmacyRepositoryImpl({required this.remoteDataSource});

  final PharmacyRemoteDataSource remoteDataSource;

  @override
  Future<Either<ErrorMsg, List<PharmacyMedicineEntity>>>
  getPharmacyMedicines() async {
    try {
      final model = await remoteDataSource.getPharmacyMedicines();
      final entities = PharmacyMedicineMapper.toEntityList(model);
      log('Mapped pharmacy medicines count: ${entities.length}');
      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, List<PharmacyCartItemEntity>>>
  getPharmacyCart() async {
    try {
      final model = await remoteDataSource.getPharmacyCart();
      final entities = PharmacyMedicineMapper.toCartItemEntityList(model);
      log('Mapped pharmacy cart count: ${entities.length}');
      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, String>> addToCart({
    required String medicineId,
    required int quantity,
  }) async {
    try {
      final response = await remoteDataSource.addToCart(
        medicineId: medicineId,
        quantity: quantity,
      );
      final message = (response['message'] ?? 'Added to cart').toString();
      return Right(message);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
