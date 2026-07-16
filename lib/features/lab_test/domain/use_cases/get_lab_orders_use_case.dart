import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/lab_order_entity.dart';
import '../repositories/lab_test_repository.dart';

class GetLabOrdersParams {
  const GetLabOrdersParams({
    this.page = 1,
    this.limit = 20,
  });

  final int page;
  final int limit;
}

class GetLabOrdersUseCase implements UseCase<LabOrdersPageEntity, GetLabOrdersParams> {
  GetLabOrdersUseCase({required this.repository});

  final LabTestRepository repository;

  @override
  Future<Either<ErrorMsg, LabOrdersPageEntity>> call(GetLabOrdersParams params) {
    return repository.getLabOrders(page: params.page, limit: params.limit);
  }
}
