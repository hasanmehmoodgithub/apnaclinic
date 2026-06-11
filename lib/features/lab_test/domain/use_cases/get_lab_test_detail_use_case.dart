import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/lab_test_detail_entity.dart';
import '../repositories/lab_test_repository.dart';

class GetLabTestDetailParams {
  const GetLabTestDetailParams({
    required this.testId,
    required this.cityName,
  });

  final int testId;
  final String cityName;
}

class GetLabTestDetailUseCase
    implements UseCase<LabTestDetailEntity, GetLabTestDetailParams> {
  GetLabTestDetailUseCase({required this.repository});

  final LabTestRepository repository;

  @override
  Future<Either<ErrorMsg, LabTestDetailEntity>> call(
    GetLabTestDetailParams params,
  ) async {
    return repository.getLabTestDetail(params);
  }
}
