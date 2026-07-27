import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/pharmacy_checkout_result_entity.dart';
import '../repositories/pharmacy_repository.dart';

class PharmacyCheckoutParams {
  const PharmacyCheckoutParams({
    required this.guestPhone,
    required this.guestName,
    required this.paymentMethod,
    required this.guestAddressCityId,
  });

  final String guestPhone;
  final String guestName;
  final String paymentMethod;
  final String guestAddressCityId;
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
      guestPhone: params.guestPhone,
      guestName: params.guestName,
      paymentMethod: params.paymentMethod,
      guestAddressCityId: params.guestAddressCityId,
    );
  }
}
