import 'dart:developer';

import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/free_doctor_entity.dart';
import '../../domain/repositories/free_doctor_repository.dart';
import '../data_sources/free_doctor_remote_data_source.dart';
import '../mappers/free_doctor_mapper.dart';

class FreeDoctorRepositoryImpl implements FreeDoctorRepository {
  FreeDoctorRepositoryImpl({required this.remoteDataSource});

  final FreeDoctorRemoteDataSource remoteDataSource;

  @override
  Future<Either<ErrorMsg, FreeDoctorEntity>> getFreeDoctorContent() async {
    try {
      final model = await remoteDataSource.getFreeDoctorContent();
      final entity = FreeDoctorMapper.toEntity(model);
      log('Mapped free doctor content: ${entity.title}');
      return Right(entity);
    } catch (e) {
      log('getFreeDoctorContent repository error: $e');
      return Left(e.toString());
    }
  }
}
