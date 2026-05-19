import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/surgery_patient_form_entity.dart';
import '../repositories/surgery_repository.dart';

class GetSurgeryPatientFormParams {
  const GetSurgeryPatientFormParams({required this.doctorId});

  final String doctorId;
}

class GetSurgeryPatientFormUseCase
    implements UseCase<SurgeryPatientFormEntity, GetSurgeryPatientFormParams> {
  GetSurgeryPatientFormUseCase({required this.repository});

  final SurgeryRepository repository;

  @override
  Future<Either<ErrorMsg, SurgeryPatientFormEntity>> call(
    GetSurgeryPatientFormParams params,
  ) async {
    return repository.getSurgeryPatientForm(doctorId: params.doctorId);
  }
}
