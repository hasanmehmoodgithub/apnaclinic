import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../repositories/consultation_repository.dart';

class AbandonConsultationBookingParams {
  const AbandonConsultationBookingParams({
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

class AbandonConsultationBookingUseCase
    implements UseCase<bool, AbandonConsultationBookingParams> {
  AbandonConsultationBookingUseCase({required this.repository});

  final ConsultationRepository repository;

  @override
  Future<Either<ErrorMsg, bool>> call(AbandonConsultationBookingParams params) {
    return repository.abandonBooking(params);
  }
}
