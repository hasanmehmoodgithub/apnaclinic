import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/your_feature_model.dart';
import 'your_feature_local_data_source.dart';

/// Local data source implementation - Example for Clean Architecture
/// Implements local preference using SharedPreferences
/// This is a sample implementation for understanding Clean Architecture structure
class YourFeatureLocalDataSourceImpl implements YourFeatureLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _key = 'your_features';

  YourFeatureLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<YourFeatureModel>> getFeatures() async {
    try {
      final jsonString = sharedPreferences.getString(_key);
      if (jsonString == null) return [];

      final decoded = jsonDecode(jsonString) as List;
      return decoded
          .map(
            (json) => YourFeatureModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get features from local preference: $e');
    }
  }

  @override
  Future<YourFeatureModel?> getFeatureById(String id) async {
    try {
      final features = await getFeatures();
      return features.firstWhere(
        (feature) => feature.id == id,
        orElse: () => throw Exception('Feature not found'),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveFeature(YourFeatureModel feature) async {
    try {
      final features = await getFeatures();
      final index = features.indexWhere((f) => f.id == feature.id);

      if (index >= 0) {
        features[index] = feature;
      } else {
        features.add(feature);
      }

      await saveFeatures(features);
    } catch (e) {
      throw Exception('Failed to save feature to local preference: $e');
    }
  }

  @override
  Future<void> saveFeatures(List<YourFeatureModel> features) async {
    try {
      final jsonString = jsonEncode(
        features.map((feature) => feature.toJson()).toList(),
      );
      await sharedPreferences.setString(_key, jsonString);
    } catch (e) {
      throw Exception('Failed to save features to local preference: $e');
    }
  }
}
