import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/lab_test_vendor_entity.dart';
import '../repositories/lab_test_repository.dart';

class GetLabsParams {
  const GetLabsParams({required this.cityName});

  final String cityName;
}

class GetLabsUseCase
    implements UseCase<List<LabTestVendorEntity>, GetLabsParams> {
  GetLabsUseCase({required this.repository});

  final LabTestRepository repository;

  @override
  Future<Either<ErrorMsg, List<LabTestVendorEntity>>> call(
    GetLabsParams params,
  ) {
    return repository.getLabs(params);
  }
}
