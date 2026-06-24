import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/instant_doctor_entity.dart';
import '../repositories/instant_doctor_repository.dart';
import 'get_instant_doctor_content_params.dart';

class GetInstantDoctorContentUseCase
    implements UseCase<InstantDoctorEntity, GetInstantDoctorContentParams> {
  GetInstantDoctorContentUseCase({required this.repository});

  final InstantDoctorRepository repository;

  @override
  Future<Either<ErrorMsg, InstantDoctorEntity>> call(
    GetInstantDoctorContentParams params,
  ) async {
    return repository.getInstantDoctorContent(params);
  }
}
