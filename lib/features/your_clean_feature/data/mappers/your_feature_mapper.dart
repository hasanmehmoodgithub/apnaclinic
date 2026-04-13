import '../../domain/entities/your_feature_entity.dart';
import '../models/your_feature_model.dart';

/// Mapper - Example for Clean Architecture
/// Converts between Model and Entity
/// This is a sample mapper for understanding Clean Architecture structure
class YourFeatureMapper {
  /// Convert YourFeatureModel to YourFeatureEntity
  static YourFeatureEntity toEntity(YourFeatureModel model) {
    return YourFeatureEntity(
      id: model.id,
      title: model.title,
      content: model.content,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      isCompleted: model.isCompleted,
    );
  }

  /// Convert YourFeatureEntity to YourFeatureModel
  static YourFeatureModel toModel(YourFeatureEntity entity) {
    return YourFeatureModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isCompleted: entity.isCompleted,
    );
  }
}
