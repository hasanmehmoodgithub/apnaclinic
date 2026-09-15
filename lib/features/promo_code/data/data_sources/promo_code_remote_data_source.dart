import '../../domain/use_cases/validate_promo_code_use_case.dart';
import '../models/promo_code_validation_model.dart';

abstract class PromoCodeRemoteDataSource {
  Future<PromoCodeValidationModel> validate(ValidatePromoCodeParams params);
}
