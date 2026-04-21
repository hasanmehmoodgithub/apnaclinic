import '../../../../core/functional/functional_export.dart';
import '../entities/profile_setup_entity.dart';
import '../models/profile_setup_data.dart';

abstract class ProfileSetupRepository {
  Future<Either<ErrorMsg, ProfileSetupEntity>> getProfileSetupContent();
  Future<Either<ErrorMsg, void>> saveProfile(ProfileSetupData data);
}
