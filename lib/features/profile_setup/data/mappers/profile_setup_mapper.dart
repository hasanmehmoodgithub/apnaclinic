import '../../domain/entities/profile_setup_entity.dart';
import '../models/profile_setup_model.dart';

class ProfileSetupMapper {
  const ProfileSetupMapper._();

  static ProfileSetupEntity toEntity(ProfileSetupResponseModel model) {
    return ProfileSetupEntity(
      firstName: model.content.firstName,
      lastName: model.content.lastName,
      gender: model.content.gender,
      email: model.content.email,
      address: model.content.address,
      dateOfBirth: _tryParseDate(model.content.dateOfBirth),
    );
  }

  static DateTime? _tryParseDate(String value) {
    if (value.trim().isEmpty) return null;
    return DateTime.tryParse(value);
  }
}
