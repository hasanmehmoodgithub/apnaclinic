import '../models/consultation_category_model.dart';

abstract class ConsultationLocalDataSource {
  Future<List<ConsultationCategoryModel>> getCategories();
}
