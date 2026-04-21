import 'dart:developer';

import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/surgery_booking_request_entity.dart';
import '../../domain/entities/surgery_procedure_entity.dart';
import '../../domain/repositories/surgery_repository.dart';
import '../data_sources/surgery_remote_data_source.dart';
import '../mappers/surgery_mapper.dart';

class SurgeryRepositoryImpl implements SurgeryRepository {
  SurgeryRepositoryImpl({required this.remoteDataSource});

  final SurgeryRemoteDataSource remoteDataSource;

  @override
  Future<Either<ErrorMsg, SurgeryContentEntity>> getSurgeryContent() async {
    try {
      final model = await remoteDataSource.getSurgeryContent();
      final entity = SurgeryMapper.toEntity(model);
      log('Mapped surgery procedures count: ${entity.procedures.length}');
      return Right(entity);
    } catch (e) {
      log('getSurgeryContent repository error: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, void>> submitSurgeryBooking(
    SurgeryBookingRequestEntity request,
  ) async {
    try {
      await remoteDataSource.submitSurgeryBooking(request);
      return const Right(null);
    } catch (e) {
      log('submitSurgeryBooking repository error: $e');
      return Left(e.toString());
    }
  }
}
