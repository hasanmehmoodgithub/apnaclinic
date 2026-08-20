import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../repositories/pharmacy_repository.dart';

class AbandonPharmacyOrderParams {
  const AbandonPharmacyOrderParams({
    required this.orderId,
    required this.unifiedOrderId,
  });

  final String orderId;
  final int unifiedOrderId;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'order_id': orderId,
        'unified_order_id': unifiedOrderId,
      };
}

class AbandonPharmacyOrderUseCase
    implements UseCase<bool, AbandonPharmacyOrderParams> {
  AbandonPharmacyOrderUseCase({required this.repository});

  final PharmacyRepository repository;

  @override
  Future<Either<ErrorMsg, bool>> call(AbandonPharmacyOrderParams params) {
    return repository.abandonOrder(params);
  }
}
