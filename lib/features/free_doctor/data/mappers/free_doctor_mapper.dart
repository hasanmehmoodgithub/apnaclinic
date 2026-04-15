import '../../domain/entities/free_doctor_entity.dart';
import '../models/free_doctor_model.dart';

class FreeDoctorMapper {
  static FreeDoctorEntity toEntity(FreeDoctorResponseModel model) {
    final content = model.content;
    return FreeDoctorEntity(
      title: content.title,
      descriptionPoints: content.descriptionPoints,
      fikrfreeAndroidPackage: content.fikrfreeAndroidPackage,
      fikrfreeIosAppStoreUrl: content.fikrfreeIosAppStoreUrl,
      fikrfreeWebUrl: content.fikrfreeWebUrl,
    );
  }
}
