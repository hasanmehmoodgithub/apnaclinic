import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/services/speech_to_text_service.dart';
import '../../domain/entities/search_entity.dart';
import '../../domain/use_cases/get_search_content_use_case.dart';
import '../constants/search_ui_config.dart';
import '../screens/recent_search_store.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required this.getSearchContentUseCase,
    required RecentSearchesStore recentSearchesStore,
    required SpeechToTextService speechToTextService,
    required AnalyticsService analytics,
  })  : _recentSearchesStore = recentSearchesStore,
        _speechToTextService = speechToTextService,
        _analytics = analytics,
        super(const SearchState()) {
    loadInitial();
  }

  final GetSearchContentUseCase getSearchContentUseCase;
  final RecentSearchesStore _recentSearchesStore;
  final SpeechToTextService _speechToTextService;
  final AnalyticsService _analytics;

  Future<void> loadInitial() async {
    await _loadContent(query: '', listening: false, submitted: false);
  }

  Future<void> onQueryChanged(String query) async {
    if (state.isListening) {
      await stopListening();
    }
    // Typing only updates the field — network search runs on submit/search tap.
    emit(
      state.copyWith(
        query: SearchUiConfig.clampQuery(query),
        isListening: false,
        isSubmitted: false,
        loadingStateStatus: StateStatus.success,
        errorMessage: null,
        content: SearchContentEntity(
          recentSearches: state.content.recentSearches,
          popularSearches: state.content.popularSearches,
          suggestions: const [],
          sections: const [],
        ),
      ),
    );
  }

  Future<VoiceSearchFailure?> startListening({String? localeId}) async {
    if (state.isListening) return null;

    emit(
      state.copyWith(
        isListening: true,
        isSubmitted: false,
      ),
    );

    final failure = await _speechToTextService.startListening(
      localeId: localeId,
      onResult: (text, _) {
        if (isClosed) return;
        emit(state.copyWith(query: SearchUiConfig.clampQuery(text)));
      },
      onSessionDone: () {
        if (isClosed) return;
        _completeVoiceSearch();
      },
    );

    if (isClosed) return failure;
    if (failure != null) {
      emit(state.copyWith(isListening: false));
    }
    return failure;
  }

  Future<void> _completeVoiceSearch() async {
    if (!state.isListening) return;

    final query = state.query.trim();
    emit(state.copyWith(isListening: false));
    if (query.isEmpty) return;
    await submitSearch(query, AnalyticsSearchMediumKeys.voice);
  }

  Future<void> stopListening() async {
    if (!state.isListening && !_speechToTextService.isListening) return;

    await _speechToTextService.stop();
    if (isClosed) return;
    await _completeVoiceSearch();
  }

  Future<void> submitSearch([
    String? query,
    String medium = AnalyticsSearchMediumKeys.type,
  ]) async {
    if (state.isListening) {
      await _speechToTextService.stop();
    }

    final resolvedQuery =
        SearchUiConfig.clampQuery((query ?? state.query).trim());
    if (resolvedQuery.isEmpty) return;

    unawaited(
      _analytics.logEvent(
        AnalyticsEventKeys.searchPerformed,
        {
          AnalyticsParamKeys.keyword: resolvedQuery,
          AnalyticsParamKeys.medium: medium,
        },
      ),
    );

    await _recentSearchesStore.add(resolvedQuery);

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
    if (state.isListening) {
      await _speechToTextService.cancel();
    }

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
    final updated = await _recentSearchesStore.remove(title);

    emit(
      state.copyWith(
        content: SearchContentEntity(
          recentSearches: updated,
          popularSearches: state.content.popularSearches,
          suggestions: state.content.suggestions,
          sections: state.content.sections,
        ),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _speechToTextService.cancel();
    return super.close();
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
      (content) {
        final localRecents = _recentSearchesStore.load();
        final recentSearches = localRecents.isNotEmpty
            ? localRecents
            : content.recentSearches.take(5).toList(growable: false);
        final merged = SearchContentEntity(
          recentSearches: recentSearches,
          popularSearches: content.popularSearches,
          suggestions: content.suggestions,
          sections: content.sections,
        );

        emit(
          state.copyWith(
            loadingStateStatus: StateStatus.success,
            content: merged,
            errorMessage: null,
          ),
        );
      },
    );
  }
}
