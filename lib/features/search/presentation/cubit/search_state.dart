import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/entities/search_entity.dart';

part 'search_state.freezed.dart';

@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState({
    @Default(StateStatus.idle) StateStatus loadingStateStatus,
    @Default('') String query,
    @Default(false) bool isListening,
    @Default(false) bool isSubmitted,
    @Default(SearchContentEntity(
      recentSearches: [],
      popularSearches: [],
      suggestions: [],
      sections: [],
    ))
    SearchContentEntity content,
    String? errorMessage,
  }) = _SearchState;
}
