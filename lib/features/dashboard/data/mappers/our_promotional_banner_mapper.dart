import '../../domain/entities/promotional_banner_entity.dart';
import '../models/promotional_banner_model.dart';

class PromotionalBannerMapper {
  static PromotionalBannerEntity toEntity(
    PromotionalBannerResponseModel model,
  ) {
    return PromotionalBannerEntity(
      showBanner: model.banner.showBanner,
      url: model.banner.url,
      route: model.banner.route,
    );
  }
}

