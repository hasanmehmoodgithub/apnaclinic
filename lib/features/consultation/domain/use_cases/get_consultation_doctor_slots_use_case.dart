import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/consultation_doctor_slots_entity.dart';
import '../repositories/consultation_repository.dart';

class GetConsultationDoctorSlotsParams {
  const GetConsultationDoctorSlotsParams({
    required this.doctorId,
    this.hospitalId,
  });

  final String doctorId;
  final String? hospitalId;
}

class GetConsultationDoctorSlotsUseCase
    implements
        UseCase<ConsultationDoctorSlotsEntity, GetConsultationDoctorSlotsParams> {
  GetConsultationDoctorSlotsUseCase({required this.repository});

  final ConsultationRepository repository;

  @override
  Future<Either<ErrorMsg, ConsultationDoctorSlotsEntity>> call(
    GetConsultationDoctorSlotsParams params,
  ) {
    return repository.getDoctorSlots(
      doctorId: params.doctorId,
      hospitalId: params.hospitalId,
    );
  }
}
