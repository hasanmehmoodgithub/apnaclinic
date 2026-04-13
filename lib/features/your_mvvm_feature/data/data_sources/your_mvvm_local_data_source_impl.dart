import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/your_mvvm_model.dart';
import 'your_mvvm_local_data_source.dart';

/// Local data source implementation - Example for MVVM
class YourMvvmLocalDataSourceImpl implements YourMvvmLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _key = 'your_mvvm_items';

  YourMvvmLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<YourMvvmModel>> getItems() async {
    try {
      final jsonString = sharedPreferences.getString(_key);
      if (jsonString == null) return [];

      final decoded = jsonDecode(jsonString) as List;
      return decoded
          .map((json) => YourMvvmModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get items from local preference: $e');
    }
  }

  @override
  Future<void> saveItem(YourMvvmModel item) async {
    try {
      final items = await getItems();
      final index = items.indexWhere((i) => i.id == item.id);

      if (index >= 0) {
        items[index] = item;
      } else {
        items.add(item);
      }

      await saveItems(items);
    } catch (e) {
      throw Exception('Failed to save item to local preference: $e');
    }
  }

  @override
  Future<void> saveItems(List<YourMvvmModel> items) async {
    try {
      final jsonString = jsonEncode(
        items.map((item) => item.toJson()).toList(),
      );
      await sharedPreferences.setString(_key, jsonString);
    } catch (e) {
      throw Exception('Failed to save items to local preference: $e');
    }
  }
}
