import '../../domain/entities/our_service_entity.dart';
import '../models/our_service_model.dart';

class DashboardServicesMapper {
  static List<OurServiceEntity> toEntityList(
    OurServicesModel model,
  ) {
    return model.services.map(_toServiceEntity).toList();
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

