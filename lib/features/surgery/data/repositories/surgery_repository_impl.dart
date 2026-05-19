import 'dart:developer';

import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/surgery_booking_request_entity.dart';
import '../../domain/entities/surgery_doctor_entity.dart';
import '../../domain/entities/surgery_patient_form_entity.dart';
import '../../domain/entities/surgery_procedure_entity.dart';
import '../../domain/repositories/surgery_repository.dart';
import '../data_sources/surgery_remote_data_source.dart';
import '../mappers/surgery_doctors_mapper.dart';
import '../mappers/surgery_mapper.dart';
import '../mappers/surgery_patient_form_mapper.dart';

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
  Future<Either<ErrorMsg, SurgeryDoctorsEntity>> getSurgeryDoctors({
    required String procedureName,
    required String city,
  }) async {
    try {
      final model = await remoteDataSource.getSurgeryDoctors(
        procedureName: procedureName,
        city: city,
      );
      return Right(SurgeryDoctorsMapper.toEntity(model));
    } catch (e) {
      log('getSurgeryDoctors repository error: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, SurgeryPatientFormEntity>> getSurgeryPatientForm({
    required String doctorId,
  }) async {
    try {
      final model = await remoteDataSource.getSurgeryPatientForm(
        doctorId: doctorId,
      );
      return Right(SurgeryPatientFormMapper.toEntity(model));
    } catch (e) {
      log('getSurgeryPatientForm repository error: $e');
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
