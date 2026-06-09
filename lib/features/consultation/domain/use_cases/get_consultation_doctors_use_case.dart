import '../../../../core/use_case/base_use_case.dart';
import '../../../../core/functional/functional_export.dart';
import '../../presentation/widgets/results_doctor_item.dart';
import '../repositories/consultation_repository.dart';

class GetConsultationDoctorsParams {
  const GetConsultationDoctorsParams({required this.mainCategoryId});

  final String mainCategoryId;
}

class GetConsultationDoctorsUseCase
    implements UseCase<List<ResultsDoctorItem>, GetConsultationDoctorsParams> {
  GetConsultationDoctorsUseCase({required this.repository});

  final ConsultationRepository repository;

  @override
  Future<Either<ErrorMsg, List<ResultsDoctorItem>>> call(
    GetConsultationDoctorsParams params,
  ) {
    return repository.getDoctors(mainCategoryId: params.mainCategoryId);
  }
}
