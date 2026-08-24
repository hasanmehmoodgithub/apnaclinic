import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../repositories/lab_test_repository.dart';

class AbandonLabTestBookingParams {
  const AbandonLabTestBookingParams({
    required this.orderId,
    this.unifiedOrderId = 0,
  });

  /// Booking API `publicId` sent as `order_id`.
  final String orderId;
  final int unifiedOrderId;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'order_id': orderId,
        'unified_order_id': unifiedOrderId,
      };
}

class AbandonLabTestBookingUseCase
    implements UseCase<bool, AbandonLabTestBookingParams> {
  AbandonLabTestBookingUseCase({required this.repository});

  final LabTestRepository repository;

  @override
  Future<Either<ErrorMsg, bool>> call(AbandonLabTestBookingParams params) {
    return repository.abandonLabTestBooking(params);
  }
}
