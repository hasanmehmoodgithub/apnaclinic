import '../../../../core/network/api_service.dart';
import '../../model/your_mvvm_model.dart';
import 'your_mvvm_remote_data_source.dart';

/// Remote data source implementation - Example for MVVM
class YourMvvmRemoteDataSourceImpl implements YourMvvmRemoteDataSource {
  final ApiService apiService;

  YourMvvmRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<YourMvvmModel>> getItems() async {
    try {
      // Example: GET /items
      // final response = await apiService.get('/items');
      // return (response.data as List)
      //     .map((json) => YourMvvmModel.fromJson(json))
      //     .toList();

      // Mock data for example
      return [];
    } catch (e) {
      throw Exception('Failed to get items: ${e.toString()}');
    }
  }

  @override
  Future<YourMvvmModel> createItem({
    required String title,
    required String description,
  }) async {
    try {
      // Example: POST /items
      // final response = await apiService.post('/items', data: {
      //   'title': title,
      //   'description': description,
      // });
      // return YourMvvmModel.fromJson(response.data);

      // Mock data for example
      return YourMvvmModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to create item: ${e.toString()}');
    }
  }
}
