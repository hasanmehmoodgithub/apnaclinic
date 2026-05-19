import 'package:intl/intl.dart';

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
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;

    final iso = DateTime.tryParse(trimmed);
    if (iso != null) return iso;

    for (final pattern in <String>[
      'dd-MM-yyyy HH:mm:ss',
      'dd-MM-yyyy',
      'yyyy-MM-dd',
    ]) {
      try {
        return DateFormat(pattern).parseStrict(trimmed);
      } catch (_) {
        continue;
      }
    }
    return null;
  }
}
