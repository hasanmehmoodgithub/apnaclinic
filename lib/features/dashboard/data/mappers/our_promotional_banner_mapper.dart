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
            routeType: banner.routeType,
            route: banner.route,
            tabIndex: banner.tabIndex,
          ),
        )
        .toList(growable: false);
  }
}
