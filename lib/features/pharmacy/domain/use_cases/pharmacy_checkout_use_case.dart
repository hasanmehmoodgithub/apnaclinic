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
    this.jazzCashNumber,
    this.name,
    this.deliveryInstructions,
    this.prescriptions = const [],
  });

  final String userLocationId;
  final String paymentMethod;
  final String? jazzCashNumber;
  final String? name;
  final String? deliveryInstructions;
  final List<PharmacyCheckoutPrescriptionParams> prescriptions;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'user_location_id': userLocationId,
      'payment_method': paymentMethod,
      'prescriptions': prescriptions
          .map((item) => item.toJson())
          .toList(growable: false),
    };
    final jazzCash = _digitsOnly(jazzCashNumber);
    if (jazzCash.isNotEmpty) {
      data['jazz_cash_number'] = jazzCash;
    }
    final trimmedName = name?.trim() ?? '';
    if (trimmedName.isNotEmpty) {
      data['name'] = trimmedName.length > 100
          ? trimmedName.substring(0, 100)
          : trimmedName;
    }
    final instructions = deliveryInstructions?.trim() ?? '';
    if (instructions.isNotEmpty) {
      data['delivery_instructions'] = instructions.length > 500
          ? instructions.substring(0, 500)
          : instructions;
    }
    return data;
  }

  static String _digitsOnly(String? value) =>
      (value ?? '').replaceAll(RegExp(r'\D'), '');
}

class PharmacyCheckoutUseCase
    implements UseCase<PharmacyCheckoutResultEntity, PharmacyCheckoutParams> {
  PharmacyCheckoutUseCase({required this.repository});

  final PharmacyRepository repository;

  @override
  Future<Either<ErrorMsg, PharmacyCheckoutResultEntity>> call(
    PharmacyCheckoutParams params,
  ) {
    return repository.checkoutOrder(params);
  }
}
