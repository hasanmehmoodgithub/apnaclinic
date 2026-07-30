import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/pharmacy_checkout_result_entity.dart';
import '../repositories/pharmacy_repository.dart';

class PharmacyCheckoutPrescriptionParams {
  const PharmacyCheckoutPrescriptionParams({
    required this.productId,
    required this.url,
  });

  final int productId;
  final String url;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'product_id': productId,
        'url': url,
      };
}

class PharmacyCheckoutParams {
  const PharmacyCheckoutParams({
    required this.userLocationId,
    required this.paymentMethod,
    this.prescriptions = const [],
  });

  final String userLocationId;
  final String paymentMethod;
  final List<PharmacyCheckoutPrescriptionParams> prescriptions;
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
      userLocationId: params.userLocationId,
      paymentMethod: params.paymentMethod,
      prescriptions: params.prescriptions
          .map((item) => item.toJson())
          .toList(growable: false),
    );
  }
}
