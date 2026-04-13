import '../../../../core/functional/functional_export.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/your_feature_entity.dart';
import '../repositories/your_feature_repository.dart';
import 'create_feature_params.dart';

/// Use case for creating a feature - Example for Clean Architecture
/// Simple example: POST /features with 2 params
/// This is a sample use case for understanding Clean Architecture structure
class CreateYourFeatureUseCase
    implements UseCase<YourFeatureEntity, CreateFeatureParams> {
  final YourFeatureRepository featureRepository;

  CreateYourFeatureUseCase({required this.featureRepository});

  @override
  Future<Either<ErrorMsg, YourFeatureEntity>> call(
    CreateFeatureParams params,
  ) async {
    // Pass params object through to repository
    return await featureRepository.createFeature(params);
  }
}
