import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/profile_setup_entity.dart';
import '../repositories/profile_setup_repository.dart';

class GetProfileSetupContentUseCase
    implements UseCaseNoParams<ProfileSetupEntity> {
  GetProfileSetupContentUseCase({required this.repository});

  final ProfileSetupRepository repository;

  @override
  Future<Either<ErrorMsg, ProfileSetupEntity>> call() async {
    return await repository.getProfileSetupContent();
  }
}
