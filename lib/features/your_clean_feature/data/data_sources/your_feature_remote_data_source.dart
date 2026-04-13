import '../../domain/use_cases/create_feature_params.dart';
import '../models/your_feature_model.dart';

/// Remote data source interface - Example for Clean Architecture
/// Simple example: GET list and POST create
/// This is a sample remote data source for understanding Clean Architecture structure
abstract class YourFeatureRemoteDataSource {
  /// GET all features from API
  Future<List<YourFeatureModel>> getFeatures();

  /// POST create a new feature via API
  /// Receives CreateFeatureParams and passes to API
  Future<YourFeatureModel> createFeature(CreateFeatureParams params);
}
