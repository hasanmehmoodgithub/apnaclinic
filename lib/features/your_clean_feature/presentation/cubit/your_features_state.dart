import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/your_feature_entity.dart';

part 'your_features_state.freezed.dart';

/// State class for Your Features - Example for Clean Architecture
/// Simple example: GET list and POST create
/// This is a sample state for understanding Clean Architecture structure
@freezed
class YourFeaturesState with _$YourFeaturesState {
  const factory YourFeaturesState({
    @Default([]) List<YourFeatureEntity> features,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _YourFeaturesState;

  const YourFeaturesState._();
}
