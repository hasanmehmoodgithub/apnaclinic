import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/surgery_procedure_entity.dart';
import '../repositories/surgery_repository.dart';

class GetSurgeryContentParams {
  const GetSurgeryContentParams();
}

class GetSurgeryContentUseCase
    implements UseCase<SurgeryContentEntity, GetSurgeryContentParams> {
  GetSurgeryContentUseCase({required this.repository});

  final SurgeryRepository repository;

  @override
  Future<Either<ErrorMsg, SurgeryContentEntity>> call(
    GetSurgeryContentParams params,
  ) async {
    return await repository.getSurgeryContent();
  }
}
