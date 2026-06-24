import '../../../../core/functional/functional_export.dart';
import '../entities/instant_doctor_entity.dart';
import '../use_cases/get_instant_doctor_content_params.dart';

abstract class InstantDoctorRepository {
  Future<Either<ErrorMsg, InstantDoctorEntity>> getInstantDoctorContent(
    GetInstantDoctorContentParams params,
  );
}
