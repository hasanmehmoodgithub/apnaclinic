import '../../domain/entities/free_doctor_entity.dart';
import '../models/free_doctor_model.dart';

class FreeDoctorMapper {
  static FreeDoctorEntity toEntity(FreeDoctorResponseModel model) {
    final content = model.content;
    return FreeDoctorEntity(
      isSubscribed: content.isSubscribed,
      bulletPoints: content.bulletPoints,
      buttonText: content.buttonText,
      redirectUrl: content.redirectUrl,
    );
  }
}
