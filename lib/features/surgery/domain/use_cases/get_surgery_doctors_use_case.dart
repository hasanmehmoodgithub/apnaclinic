import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/surgery_doctor_entity.dart';
import '../repositories/surgery_repository.dart';

class GetSurgeryDoctorsParams {
  const GetSurgeryDoctorsParams({
    required this.surgeryId,
    required this.procedureName,
    required this.city,
  });

  final String surgeryId;
  final String procedureName;
  final String city;
}

class GetSurgeryDoctorsUseCase
    implements UseCase<SurgeryDoctorsEntity, GetSurgeryDoctorsParams> {
  GetSurgeryDoctorsUseCase({required this.repository});

  final SurgeryRepository repository;

  @override
  Future<Either<ErrorMsg, SurgeryDoctorsEntity>> call(
    GetSurgeryDoctorsParams params,
  ) async {
    return repository.getSurgeryDoctors(
      surgeryId: params.surgeryId,
      procedureName: params.procedureName,
      city: params.city,
    );
  }
}
