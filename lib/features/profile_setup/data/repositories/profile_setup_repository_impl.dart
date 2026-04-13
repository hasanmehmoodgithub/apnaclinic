import '../../../../core/preference/app_pref.dart';
import '../../domain/models/profile_setup_data.dart';
import '../../domain/repositories/profile_setup_repository.dart';

class ProfileSetupRepositoryImpl implements ProfileSetupRepository {
  ProfileSetupRepositoryImpl(this._appPref);

  final AppPref _appPref;

  @override
  Future<void> saveProfile(ProfileSetupData data) async {
    await _appPref.setString('profile_first_name', data.firstName);
    await _appPref.setString('profile_last_name', data.lastName);
    await _appPref.setString('profile_gender', data.gender);
    await _appPref.setString('profile_email', data.email);
    await _appPref.setString('profile_address', data.address);
    await _appPref.setString('profile_dob', data.dateOfBirth.toIso8601String());
    await _appPref.setProfileCompleted(true);
  }
}
