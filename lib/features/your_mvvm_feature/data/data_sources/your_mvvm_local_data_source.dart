import '../../model/your_mvvm_model.dart';

/// Local data source interface - Example for MVVM
abstract class YourMvvmLocalDataSource {
  /// Get all items from local preference
  Future<List<YourMvvmModel>> getItems();

  /// Save an item to local preference
  Future<void> saveItem(YourMvvmModel item);

  /// Save multiple items to local preference
  Future<void> saveItems(List<YourMvvmModel> items);
}
