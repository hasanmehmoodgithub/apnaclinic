import '../models/your_feature_model.dart';

/// Local data source interface - Example for Clean Architecture
/// Abstract interface for local preference operations
/// This is a sample local data source for understanding Clean Architecture structure
abstract class YourFeatureLocalDataSource {
  /// Get all features from local preference
  Future<List<YourFeatureModel>> getFeatures();

  /// Get a single feature by ID from local preference
  Future<YourFeatureModel?> getFeatureById(String id);

  /// Save a feature to local preference
  Future<void> saveFeature(YourFeatureModel feature);

  /// Save multiple features to local preference
  Future<void> saveFeatures(List<YourFeatureModel> features);
}
