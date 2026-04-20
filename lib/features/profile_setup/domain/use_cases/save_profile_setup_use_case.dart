import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../models/profile_setup_data.dart';
import '../repositories/profile_setup_repository.dart';

class SaveProfileSetupUseCase implements UseCaseVoid<ProfileSetupData> {
  SaveProfileSetupUseCase({required this.repository});

  final ProfileSetupRepository repository;

  @override
  Future<Either<ErrorMsg, void>> call(ProfileSetupData params) async {
    return await repository.saveProfile(params);
  }
}
