import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/surgery_lead_entity.dart';
import '../repositories/surgery_repository.dart';

class GetSurgeryLeadsParams {
  const GetSurgeryLeadsParams({
    this.page = 1,
    this.limit = 20,
  });

  final int page;
  final int limit;
}

class GetSurgeryLeadsUseCase
    implements UseCase<SurgeryLeadsPageEntity, GetSurgeryLeadsParams> {
  GetSurgeryLeadsUseCase({required this.repository});

  final SurgeryRepository repository;

  @override
  Future<Either<ErrorMsg, SurgeryLeadsPageEntity>> call(
    GetSurgeryLeadsParams params,
  ) {
    return repository.getSurgeryLeads(page: params.page, limit: params.limit);
  }
}
