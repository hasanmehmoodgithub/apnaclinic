import '../../../../core/network/api_service.dart';
import '../../domain/use_cases/create_feature_params.dart';
import '../models/your_feature_model.dart';
import 'your_feature_remote_data_source.dart';

/// Remote data source implementation - Example for Clean Architecture
/// Simple example: GET list and POST create
/// This is a sample implementation for understanding Clean Architecture structure
class YourFeatureRemoteDataSourceImpl implements YourFeatureRemoteDataSource {
  final ApiService apiService;

  YourFeatureRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<YourFeatureModel>> getFeatures() async {
    try {
      // Example: GET /features
      // final response = await apiService.get('/features');
      // return (response as List).map((json) => YourFeatureModel.fromJson(json)).toList();

      // Mock data for example
      return [];
    } catch (e) {
      throw Exception('Failed to get features: ${e.toString()}');
    }
  }

  @override
  Future<YourFeatureModel> createFeature(CreateFeatureParams params) async {
    try {
      // Example: POST /features
      // Params object is passed through from UseCase → Repository → DataSource
      // final response = await apiService.post('/features', data: {
      //   'title': params.title,
      //   'content': params.content,
      // });
      // return YourFeatureModel.fromJson(response);

      // Mock data for example
      return YourFeatureModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: params.title,
        content: params.content,
        createdAt: DateTime.now(),
        isCompleted: false,
      );
    } catch (e) {
      throw Exception('Failed to create feature: ${e.toString()}');
    }
  }
}
