import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/free_doctor_entity.dart';
import '../repositories/free_doctor_repository.dart';
import 'get_free_doctor_content_params.dart';

class GetFreeDoctorContentUseCase
    implements UseCase<FreeDoctorEntity, GetFreeDoctorContentParams> {
  GetFreeDoctorContentUseCase({required this.repository});

  final FreeDoctorRepository repository;

  @override
  Future<Either<ErrorMsg, FreeDoctorEntity>> call(
    GetFreeDoctorContentParams params,
  ) async {
    return repository.getFreeDoctorContent(params);
  }
}
