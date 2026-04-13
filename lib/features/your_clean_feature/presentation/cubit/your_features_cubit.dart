import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/create_your_feature_use_case.dart';
import '../../domain/use_cases/get_your_features_use_case.dart';
import '../../domain/use_cases/create_feature_params.dart';
import 'your_features_state.dart';

/// Cubit for managing Your Features state - Example for Clean Architecture
/// Simple example: GET list and POST create
/// This is a sample cubit for understanding Clean Architecture structure
class YourFeaturesCubit extends Cubit<YourFeaturesState> {
  final GetYourFeaturesUseCase getFeaturesUseCase;
  final CreateYourFeatureUseCase createFeatureUseCase;

  YourFeaturesCubit({
    required this.getFeaturesUseCase,
    required this.createFeatureUseCase,
  }) : super(const YourFeaturesState()) {
    loadFeatures();
  }

  /// GET: Load all features
  Future<void> loadFeatures() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await getFeaturesUseCase.call();

    result.fold(
      (error) {
        emit(state.copyWith(isLoading: false, errorMessage: error));
      },
      (features) {
        emit(
          state.copyWith(
            features: features,
            isLoading: false,
            errorMessage: null,
          ),
        );
      },
    );
  }

  /// POST: Create a new feature with 2 params (title, content)
  Future<void> createFeature({
    required String title,
    required String content,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    // Pass params to use case
    final result = await createFeatureUseCase.call(
      CreateFeatureParams(title: title, content: content),
    );

    result.fold(
      (error) {
        emit(state.copyWith(isLoading: false, errorMessage: error));
      },
      (feature) {
        final updatedFeatures = [feature, ...state.features];
        emit(
          state.copyWith(
            features: updatedFeatures,
            isLoading: false,
            errorMessage: null,
          ),
        );
      },
    );
  }
}
