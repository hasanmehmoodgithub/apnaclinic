import '../../domain/entities/free_doctor_entity.dart';
import '../models/free_doctor_model.dart';

class FreeDoctorMapper {
  static FreeDoctorEntity toEntity(FreeDoctorModel model) {
    return FreeDoctorEntity(
      title: model.title,
      descriptionPoints: model.descriptionPoints,
      fikrfreeAndroidPackage: model.fikrfreeAndroidPackage,
      fikrfreeIosAppStoreUrl: model.fikrfreeIosAppStoreUrl,
      fikrfreeWebUrl: model.fikrfreeWebUrl,
    );
  }
}
