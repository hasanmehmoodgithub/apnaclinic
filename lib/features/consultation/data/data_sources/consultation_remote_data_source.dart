import '../models/consultation_category_model.dart';

abstract class ConsultationRemoteDataSource {
  Future<List<ConsultationCategoryModel>> getCategories();
}
