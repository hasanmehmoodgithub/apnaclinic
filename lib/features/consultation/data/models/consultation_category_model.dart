import '../../domain/entities/consultation_category_entity.dart';

class ConsultationCategoryModel extends ConsultationCategoryEntity {
  const ConsultationCategoryModel({
    required super.id,
    required super.title,
    required super.description,
    required super.iconUrl,
  });

  factory ConsultationCategoryModel.fromMap(Map<String, dynamic> map) {
    return ConsultationCategoryModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      iconUrl: map['iconUrl'] as String? ?? '',
    );
  }
}
