import '../../../../core/use_case/base_use_case.dart';
import '../../../../core/functional/functional_export.dart';
import '../entities/consultation_doctors_page_entity.dart';
import '../repositories/consultation_repository.dart';

class GetConsultationDoctorsParams {
  const GetConsultationDoctorsParams({
    required this.mainCategoryId,
    this.partnerId,
    this.search,
    this.page = 1,
    this.limit = 20,
  });

  final String mainCategoryId;
  final String? partnerId;
  final String? search;
  final int page;
  final int limit;
}

class GetConsultationDoctorsUseCase
    implements UseCase<ConsultationDoctorsPageEntity, GetConsultationDoctorsParams> {
  GetConsultationDoctorsUseCase({required this.repository});

  final ConsultationRepository repository;

  @override
  Future<Either<ErrorMsg, ConsultationDoctorsPageEntity>> call(
    GetConsultationDoctorsParams params,
  ) {
    return repository.getDoctors(
      mainCategoryId: params.mainCategoryId,
      partnerId: params.partnerId,
      search: params.search,
      page: params.page,
      limit: params.limit,
    );
  }
}
