import '../models/consultation_category_model.dart';
import '../mock/consultation_categories_mock_api.dart';
import 'consultation_local_data_source.dart';

class ConsultationLocalDataSourceImpl implements ConsultationLocalDataSource {
  ConsultationLocalDataSourceImpl({required this.mockApi});

  final ConsultationCategoriesMockApi mockApi;

  @override
  Future<List<ConsultationCategoryModel>> getCategories() async {
    final response = await mockApi.getConsultationCategoriesSuccessResponse();
    final rawCategories = response['categories'];
    final categories =
        (rawCategories is List ? rawCategories : const <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .map(ConsultationCategoryModel.fromMap)
            .toList(growable: false);
    return categories;
  }
}
