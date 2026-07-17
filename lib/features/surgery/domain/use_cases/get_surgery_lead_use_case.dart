import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/surgery_lead_entity.dart';
import '../repositories/surgery_repository.dart';

class GetSurgeryLeadParams {
  const GetSurgeryLeadParams({required this.leadId});

  final int leadId;
}

class GetSurgeryLeadUseCase
    implements UseCase<SurgeryLeadEntity, GetSurgeryLeadParams> {
  GetSurgeryLeadUseCase({required this.repository});

  final SurgeryRepository repository;

  @override
  Future<Either<ErrorMsg, SurgeryLeadEntity>> call(
    GetSurgeryLeadParams params,
  ) {
    return repository.getSurgeryLead(leadId: params.leadId);
  }
}
