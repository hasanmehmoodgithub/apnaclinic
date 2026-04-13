import '../../domain/entities/your_feature_entity.dart';

/// Data model - Example for Clean Architecture
/// Extends YourFeatureEntity and adds JSON serialization
/// This is a sample model for understanding Clean Architecture structure
class YourFeatureModel extends YourFeatureEntity {
  const YourFeatureModel({
    required super.id,
    required super.title,
    required super.content,
    required super.createdAt,
    super.updatedAt,
    super.isCompleted,
  });

  /// Create YourFeatureModel from JSON
  factory YourFeatureModel.fromJson(Map<String, dynamic> json) {
    return YourFeatureModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  /// Convert YourFeatureModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  /// Convert YourFeatureModel to YourFeatureEntity
  YourFeatureEntity toEntity() {
    return YourFeatureEntity(
      id: id,
      title: title,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isCompleted: isCompleted,
    );
  }
}
