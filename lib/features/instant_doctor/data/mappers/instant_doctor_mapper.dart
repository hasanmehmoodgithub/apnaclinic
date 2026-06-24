import '../../domain/entities/instant_doctor_entity.dart';
import '../models/instant_doctor_model.dart';

class InstantDoctorMapper {
  static InstantDoctorEntity toEntity(InstantDoctorResponseModel model) {
    final content = model.content;
    return InstantDoctorEntity(
      isSubscribed: content.isSubscribed,
      bulletPoints: content.bulletPoints,
      buttonText: content.buttonText,
      redirectUrl: content.redirectUrl,
    );
  }
}
