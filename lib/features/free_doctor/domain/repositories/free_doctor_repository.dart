import '../../../../core/failure/exceptions.dart';
import '../../../../core/functional/functional_export.dart';
import '../entities/free_doctor_entity.dart';

abstract class FreeDoctorRepository {
  Future<Either<ErrorMsg, FreeDoctorEntity>> getFreeDoctorContent();
}
