import '../domain/entities/consultation_category_entity.dart';

class DoctorConsultationResultsArgs {
  const DoctorConsultationResultsArgs({
    required this.selectedCategory,
    required this.mainCategoryId,
    required this.categoryOptions,
  });

  final String selectedCategory;
  final String mainCategoryId;
  final List<ConsultationCategoryEntity> categoryOptions;
}
