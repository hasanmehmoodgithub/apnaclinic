import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/get_consultation_categories_use_case.dart';
import 'consultation_state.dart';

class ConsultationCubit extends Cubit<ConsultationState> {
  final GetConsultationCategoriesUseCase getCategoriesUseCase;

  ConsultationCubit({required this.getCategoriesUseCase})
    : super(const ConsultationState()) {
    loadCategories();
  }

  Future<void> loadCategories() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await getCategoriesUseCase.call();
    result.fold(
      (error) => emit(state.copyWith(isLoading: false, errorMessage: error)),
      (page) => emit(
        state.copyWith(
          categories: page.categories,
          filteredCategories: page.categories,
          aiScreening: page.aiScreening,
          isLoading: false,
          errorMessage: null,
          clearAiScreening: page.aiScreening == null,
        ),
      ),
    );
  }

  void onSearchChanged(String value) {
    final query = value.trim().toLowerCase();
    if (query.isEmpty) {
      emit(
        state.copyWith(
          searchQuery: value,
          filteredCategories: state.categories,
          errorMessage: null,
        ),
      );
      return;
    }

    final filtered = state.categories
        .where(
          (item) =>
              item.title.toLowerCase().contains(query) ||
              item.description.toLowerCase().contains(query),
        )
        .toList(growable: false);
    emit(
      state.copyWith(
        searchQuery: value,
        filteredCategories: filtered,
        errorMessage: null,
      ),
    );
  }
}
