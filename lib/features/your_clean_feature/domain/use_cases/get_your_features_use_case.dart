import '../../../../core/functional/functional_export.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/your_feature_entity.dart';
import '../repositories/your_feature_repository.dart';

/// Use case for getting all features - Example for Clean Architecture
/// Simple example: GET /features
/// This is a sample use case for understanding Clean Architecture structure
class GetYourFeaturesUseCase
    implements UseCaseNoParams<List<YourFeatureEntity>> {
  final YourFeatureRepository featureRepository;

  GetYourFeaturesUseCase({required this.featureRepository});

  @override
  Future<Either<ErrorMsg, List<YourFeatureEntity>>> call() async {
    return await featureRepository.getFeatures();
  }
}
