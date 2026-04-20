import '../../domain/models/profile_setup_data.dart';
import '../models/profile_setup_model.dart';

abstract class ProfileSetupRemoteDataSource {
  Future<ProfileSetupResponseModel> getProfileSetupContent();
  Future<void> saveProfile(ProfileSetupData data);
}
