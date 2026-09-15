import '../../../../core/functional/functional_export.dart';
import '../entities/promo_code_validation_entity.dart';
import '../use_cases/validate_promo_code_use_case.dart';

abstract class PromoCodeRepository {
  Future<Either<ErrorMsg, PromoCodeValidationEntity>> validate(
    ValidatePromoCodeParams params,
  );
}
