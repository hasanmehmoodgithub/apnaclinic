import '../../domain/entities/surgery_procedure_entity.dart';
import '../models/surgery_content_model.dart';

class SurgeryMapper {
  static SurgeryContentEntity toEntity(SurgeryContentModel model) {
    return SurgeryContentEntity(
      cities: model.cities,
      defaultCity: model.defaultCity,
      procedures: model.procedures
          .map(
            (item) => SurgeryProcedureEntity(
              id: item.id,
              name: item.name,
              highlighted: item.highlighted,
            ),
          )
          .toList(),
    );
  }
}
