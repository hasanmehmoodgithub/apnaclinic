import '../../domain/entities/instant_doctor_entity.dart';
import '../../domain/entities/instant_doctor_product_entity.dart';
import '../../domain/entities/instant_doctor_provider_entity.dart';
import '../../domain/entities/instant_doctor_verify_otp_entity.dart';
import '../models/instant_doctor_model.dart';

class InstantDoctorMapper {
  static InstantDoctorEntity toEntity(InstantDoctorResponseModel model) {
    return InstantDoctorEntity(
      providers: model.providers.map(_toProviderEntity).toList(),
    );
  }

  static InstantDoctorProviderEntity _toProviderEntity(
    InstantDoctorProviderModel model,
  ) {
    return InstantDoctorProviderEntity(
      providerId: model.providerId,
      providerName: model.providerName,
      logoUrl: model.logoUrl,
      isSubscribed: model.isSubscribed,
      product: InstantDoctorProductEntity(
        productId: model.product.productId,
        productCode: model.product.productCode,
        productType: model.product.productType,
        productTitle: model.product.productTitle,
        priceDisplay: model.product.priceDisplay,
        benefits: model.product.benefits,
        redirectUrl: model.product.redirectUrl,
      ),
    );
  }

  static InstantDoctorVerifyOtpEntity toVerifyOtpEntity(
    InstantDoctorVerifyOtpResultModel model,
  ) {
    return InstantDoctorVerifyOtpEntity(
      resultCode: model.resultCode,
      status: model.status,
      transactionId: model.transactionId,
      description: model.description,
      redirectUrl: model.redirectUrl,
    );
  }
}
