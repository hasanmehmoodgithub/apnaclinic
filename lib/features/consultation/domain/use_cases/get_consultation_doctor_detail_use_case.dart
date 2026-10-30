import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/consultation_doctor_detail_entity.dart';
import '../repositories/consultation_repository.dart';

class GetConsultationDoctorDetailParams {
  const GetConsultationDoctorDetailParams({required this.doctorId});

  final String doctorId;
}

class GetConsultationDoctorDetailUseCase
    implements
        UseCase<
          ConsultationDoctorDetailEntity,
          GetConsultationDoctorDetailParams
        > {
  GetConsultationDoctorDetailUseCase({required this.repository});

  final ConsultationRepository repository;

  @override
  Future<Either<ErrorMsg, ConsultationDoctorDetailEntity>> call(
    GetConsultationDoctorDetailParams params,
  ) {
    return repository.getDoctorDetail(doctorId: params.doctorId);
  }
}
