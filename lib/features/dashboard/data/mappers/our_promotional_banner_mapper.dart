import '../../domain/entities/promotional_banner_entity.dart';
import '../models/promotional_banner_model.dart';

class PromotionalBannerMapper {
  static List<PromotionalBannerEntity> toEntityList(
    PromotionalBannerResponseModel model,
  ) {
    return model.banners
        .map(
          (banner) => PromotionalBannerEntity(
            showBanner: banner.showBanner,
            url: banner.url,
            route: banner.route,
          ),
        )
        .toList(growable: false);
  }
}
