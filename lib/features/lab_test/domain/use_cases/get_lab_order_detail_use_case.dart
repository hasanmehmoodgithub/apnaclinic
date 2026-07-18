import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/lab_order_entity.dart';
import '../repositories/lab_test_repository.dart';

class GetLabOrderDetailParams {
  const GetLabOrderDetailParams({required this.orderId});

  final String orderId;
}

class GetLabOrderDetailUseCase
    implements UseCase<LabOrderEntity, GetLabOrderDetailParams> {
  GetLabOrderDetailUseCase({required this.repository});

  final LabTestRepository repository;

  @override
  Future<Either<ErrorMsg, LabOrderEntity>> call(GetLabOrderDetailParams params) {
    return repository.getLabOrderDetail(orderId: params.orderId);
  }
}
