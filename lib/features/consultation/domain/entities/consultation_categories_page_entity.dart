import 'package:equatable/equatable.dart';

import 'ai_screening_entity.dart';
import 'consultation_category_entity.dart';

class ConsultationCategoriesPageEntity extends Equatable {
  const ConsultationCategoriesPageEntity({
    required this.categories,
    this.aiScreening,
  });

  final List<ConsultationCategoryEntity> categories;
  final AiScreeningEntity? aiScreening;

  @override
  List<Object?> get props => [categories, aiScreening];
}
