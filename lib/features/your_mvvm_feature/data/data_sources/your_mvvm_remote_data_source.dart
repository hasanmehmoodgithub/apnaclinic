import '../../model/your_mvvm_model.dart';

/// Remote data source interface - Example for MVVM
/// Simple example: GET list and POST create
abstract class YourMvvmRemoteDataSource {
  /// GET all items from API
  Future<List<YourMvvmModel>> getItems();

  /// POST create a new item via API
  Future<YourMvvmModel> createItem({
    required String title,
    required String description,
  });
}
