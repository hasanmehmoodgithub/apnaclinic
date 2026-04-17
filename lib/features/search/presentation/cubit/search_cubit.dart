import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/entities/search_entity.dart';
import '../../domain/use_cases/get_search_content_use_case.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required this.getSearchContentUseCase})
      : super(const SearchState()) {
    loadInitial();
  }

  final GetSearchContentUseCase getSearchContentUseCase;

  Future<void> loadInitial() async {
    await _loadContent(query: '', listening: false, submitted: false);
  }

  Future<void> onQueryChanged(String query) async {
    emit(
      state.copyWith(
        query: query,
        isListening: false,
        isSubmitted: false,
      ),
    );
    await _loadContent(query: query, listening: false, submitted: false);
  }

  Future<void> startListening() async {
    emit(state.copyWith(isListening: true, isSubmitted: false));
    await _loadContent(
      query: state.query,
      listening: true,
      submitted: false,
    );
  }

  Future<void> stopListening() async {
    emit(state.copyWith(isListening: false));
    await _loadContent(
      query: state.query,
      listening: false,
      submitted: false,
    );
  }

  Future<void> submitSearch([String? query]) async {
    final resolvedQuery = query ?? state.query;
    emit(
      state.copyWith(
        query: resolvedQuery,
        isListening: false,
        isSubmitted: true,
      ),
    );
    await _loadContent(
      query: resolvedQuery,
      listening: false,
      submitted: true,
    );
  }

  Future<void> clearQuery() async {
    emit(
      state.copyWith(
        query: '',
        isListening: false,
        isSubmitted: false,
      ),
    );
    await loadInitial();
  }

  Future<void> removeRecentSearch(String title) async {
    final filtered = state.content.recentSearches
        .where((item) => item.title.toLowerCase() != title.toLowerCase())
        .toList();
    emit(
      state.copyWith(
        content: SearchContentEntity(
          recentSearches: filtered,
          popularSearches: state.content.popularSearches,
          suggestions: state.content.suggestions,
          sections: state.content.sections,
        ),
      ),
    );
  }

  Future<void> _loadContent({
    required String query,
    required bool listening,
    required bool submitted,
  }) async {
    emit(
      state.copyWith(
        loadingStateStatus: StateStatus.loading,
        errorMessage: null,
      ),
    );

    final result = await getSearchContentUseCase(
      GetSearchContentParams(
        query: query,
        listening: listening,
        submitted: submitted,
      ),
    );
    if (isClosed) return;

    result.fold(
      (error) => emit(
        state.copyWith(
          loadingStateStatus: StateStatus.error,
          errorMessage: error,
        ),
      ),
      (content) => emit(
        state.copyWith(
          loadingStateStatus: StateStatus.success,
          content: content,
          errorMessage: null,
        ),
      ),
    );
  }
}
