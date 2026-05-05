import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/free_doctor_entity.dart';
import '../repositories/free_doctor_repository.dart';

class GetFreeDoctorContentUseCase implements UseCaseNoParams<FreeDoctorEntity> {
  GetFreeDoctorContentUseCase({required this.repository});

  final FreeDoctorRepository repository;

  @override
  Future<Either<ErrorMsg, FreeDoctorEntity>> call() async {
    return await repository.getFreeDoctorContent();
  }
}
