import 'dart:developer';

import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/instant_doctor_entity.dart';
import '../../domain/repositories/instant_doctor_repository.dart';
import '../../domain/use_cases/get_instant_doctor_content_params.dart';
import '../data_sources/instant_doctor_remote_data_source.dart';
import '../mappers/instant_doctor_mapper.dart';

class InstantDoctorRepositoryImpl implements InstantDoctorRepository {
  InstantDoctorRepositoryImpl({required this.remoteDataSource});

  final InstantDoctorRemoteDataSource remoteDataSource;

  @override
  Future<Either<ErrorMsg, InstantDoctorEntity>> getInstantDoctorContent(
    GetInstantDoctorContentParams params,
  ) async {
    try {
      final model = await remoteDataSource.getInstantDoctorContent(
        msisdn: params.msisdn,
      );
      return Right(InstantDoctorMapper.toEntity(model));
    } catch (e) {
      log('getInstantDoctorContent repository error: $e');
      return Left(e.toString());
    }
  }
}
