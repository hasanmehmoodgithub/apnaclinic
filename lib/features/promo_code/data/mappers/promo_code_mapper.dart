import '../../domain/entities/promo_code_validation_entity.dart';
import '../models/promo_code_validation_model.dart';

class PromoCodeMapper {
  PromoCodeMapper._();

  static PromoCodeValidationEntity toEntity(PromoCodeValidationModel model) {
    return PromoCodeValidationEntity(
      code: model.code,
      discountType: model.discountType,
      discountValue: model.discountValue,
      originalAmount: model.originalAmount,
      discountAmount: model.discountAmount,
      payableAmount: model.payableAmount,
    );
  }
}
