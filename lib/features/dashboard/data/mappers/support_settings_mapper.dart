import '../../domain/entities/support_settings_entity.dart';
import '../models/support_settings_model.dart';

class SupportSettingsMapper {
  static SupportSettingsEntity toEntity(SupportSettingsResponseModel model) {
    final data = model.data;
    return SupportSettingsEntity(
      phone: data.phone,
      email: data.email,
      description: data.description,
      buttonText: data.buttonText,
    );
  }
}
