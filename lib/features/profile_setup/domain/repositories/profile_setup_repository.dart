import '../models/profile_setup_data.dart';

abstract class ProfileSetupRepository {
  Future<void> saveProfile(ProfileSetupData data);
}
