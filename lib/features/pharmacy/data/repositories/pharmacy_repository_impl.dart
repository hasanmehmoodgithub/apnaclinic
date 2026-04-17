import 'dart:developer';

import '../../../../core/failure/exceptions.dart';
import '../../../../core/functional/functional_export.dart';
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
}
