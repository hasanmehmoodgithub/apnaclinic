import '../../domain/entities/home_panel_entity.dart';
import '../../domain/entities/our_service_entity.dart';
import '../models/our_service_model.dart';

class DashboardServicesMapper {
  static HomePanelEntity toEntity(OurServicesModel model) {
    return HomePanelEntity(
      services: model.services.map(_toServiceEntity).toList(),
      bannerUrl: model.bannerUrl,
      aiEnabled: model.aiEnabled,
      aiPrescriptionEnabled: model.aiPrescriptionEnabled,
    );
  }

  static List<OurServiceEntity> toEntityList(OurServicesModel model) {
    return toEntity(model).services;
  }

  static OurServiceEntity _toServiceEntity(OurServiceModel model) {
    return OurServiceEntity(
      title: model.title,
      subtitle: model.subtitle,
      offerUpto: model.offerUpto,
      thumb: model.thumb,
      route: model.route,
      visibility: model.visibility,
    );
  }
}
