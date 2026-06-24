import '../../../../core/functional/functional_export.dart';
import '../entities/free_doctor_entity.dart';
import '../use_cases/get_free_doctor_content_params.dart';

abstract class FreeDoctorRepository {
  Future<Either<ErrorMsg, FreeDoctorEntity>> getFreeDoctorContent(
    GetFreeDoctorContentParams params,
  );
}
