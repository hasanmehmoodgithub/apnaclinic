import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/promo_code_service.dart';
import '../entities/promo_code_validation_entity.dart';
import '../repositories/promo_code_repository.dart';

class ValidatePromoCodeParams {
  const ValidatePromoCodeParams({
    required this.code,
    required this.service,
    required this.amount,
    required this.isPro,
  });

  final String code;
  final PromoCodeService service;
  final int amount;
  final bool isPro;
}

class ValidatePromoCodeUseCase
    implements UseCase<PromoCodeValidationEntity, ValidatePromoCodeParams> {
  ValidatePromoCodeUseCase({required this.repository});

  final PromoCodeRepository repository;

  @override
  Future<Either<ErrorMsg, PromoCodeValidationEntity>> call(
    ValidatePromoCodeParams params,
  ) {
    return repository.validate(params);
  }
}
