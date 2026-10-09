import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/get_consultation_categories_use_case.dart';
import 'consultation_state.dart';

class ConsultationCubit extends Cubit<ConsultationState> {
  final GetConsultationCategoriesUseCase getCategoriesUseCase;

  ConsultationCubit({required this.getCategoriesUseCase})
    : super(const ConsultationState()) {
    loadCategories();
  }

  void _safeEmit(ConsultationState newState) {
    if (isClosed) return;
    emit(newState);
  }

  Future<void> loadCategories() async {
    _safeEmit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await getCategoriesUseCase.call();
    if (isClosed) return;
    result.fold(
      (error) =>
          _safeEmit(state.copyWith(isLoading: false, errorMessage: error)),
      (page) => _safeEmit(
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
    if (isClosed) return;
    final query = value.trim().toLowerCase();
    if (query.isEmpty) {
      _safeEmit(
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
    _safeEmit(
      state.copyWith(
        searchQuery: value,
        filteredCategories: filtered,
        errorMessage: null,
      ),
    );
  }
}
