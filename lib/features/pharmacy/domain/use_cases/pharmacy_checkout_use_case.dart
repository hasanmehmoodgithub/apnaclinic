import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/pharmacy_checkout_result_entity.dart';
import '../repositories/pharmacy_repository.dart';

class PharmacyCheckoutParams {
  const PharmacyCheckoutParams({
    required this.bookingId,
    required this.patientId,
    required this.userLocationId,
    required this.paymentMethod,
  });

  final String bookingId;
  final String patientId;
  final String userLocationId;
  final String paymentMethod;
}

class PharmacyCheckoutUseCase
    implements UseCase<PharmacyCheckoutResultEntity, PharmacyCheckoutParams> {
  PharmacyCheckoutUseCase({required this.repository});

  final PharmacyRepository repository;

  @override
  Future<Either<ErrorMsg, PharmacyCheckoutResultEntity>> call(
    PharmacyCheckoutParams params,
  ) {
    return repository.checkoutOrder(
      bookingId: params.bookingId,
      patientId: params.patientId,
      userLocationId: params.userLocationId,
      paymentMethod: params.paymentMethod,
    );
  }
}
