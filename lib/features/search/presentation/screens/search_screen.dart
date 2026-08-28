import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../constants/search_ui_config.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';
import '../widgets/search_empty_results_widget.dart';
import '../widgets/search_initial_content_widget.dart';
import '../widgets/search_input_row_widget.dart';
import '../widgets/search_results_sections_widget.dart';
import '../widgets/search_shimmer_view_widget.dart';
import '../widgets/search_suggestions_list_widget.dart';
import '../widgets/search_voice_listening_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    this.initialQuery,
    this.startVoiceSearch = false,
  });

  final String? initialQuery;
  final bool startVoiceSearch;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _didSubmitInitialQuery = false;

  @override
  void initState() {
    super.initState();
    unawaited(sl<AnalyticsService>().logEvent(AnalyticsEventKeys.searchScreen));
    final seed = SearchUiConfig.clampQuery(widget.initialQuery?.trim() ?? '');
    if (seed.isNotEmpty) {
      _controller.text = seed;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _didSubmitInitialQuery = true;
        context.read<SearchCubit>().submitSearch(seed);
      });
    } else {
      _didSubmitInitialQuery = true;
    }

    if (widget.startVoiceSearch) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 400));
        if (!mounted) return;
        await _startVoiceSearch();
      });
    }
  }

  Future<void> _startVoiceSearch() async {
    if (!mounted) return;
    final locale = Localizations.localeOf(context);
    final localeId = locale.countryCode == null || locale.countryCode!.isEmpty
        ? locale.languageCode
        : '${locale.languageCode}_${locale.countryCode}';
    await context.read<SearchCubit>().startListening(localeId: localeId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (_didSubmitInitialQuery && _controller.text != state.query) {
          _controller.value = TextEditingValue(
            text: state.query,
            selection: TextSelection.collapsed(offset: state.query.length),
          );
        }

        return AppScaffoldGradient(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 18.h),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.clr060,
                        size: 26.r,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        l10n.searchScreenTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.clr060,
                          fontWeight: FontWeight.w700,
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 44.w),
                  ],
                ),
              ),
              AppScaffoldGradientPanel(
                topBorderRadius: 28.r,
                child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
                        child: SearchInputRowWidget(
                          controller: _controller,
                          isListening: state.isListening,
                          onChanged: (v) =>
                              context.read<SearchCubit>().onQueryChanged(v),
                          onSubmit: (_) => context
                              .read<SearchCubit>()
                              .submitSearch(_controller.text),
                          onClear: () =>
                              context.read<SearchCubit>().clearQuery(),
                          onMicTap: () async {
                            if (state.isListening) {
                              await context.read<SearchCubit>().stopListening();
                            } else {
                              await _startVoiceSearch();
                            }
                          },
                          onSearchTap: () => context
                              .read<SearchCubit>()
                              .submitSearch(_controller.text),
                        ),
                      ),
                      Expanded(child: _buildBody(context, state)),
                    ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, SearchState state) {
    final query = state.query.trim();
    final hasResults = state.content.sections.any(
      (section) => section.results.isNotEmpty,
    );
    final hasSuggestions = state.content.suggestions.isNotEmpty;
    final isInitial = query.isEmpty &&
        !state.isSubmitted &&
        !state.isListening &&
        !hasResults;

    if (state.isListening) {
      return SearchVoiceListeningView(
        onStop: () => context.read<SearchCubit>().stopListening(),
      );
    }

    if (state.loadingStateStatus == StateStatus.loading) {
      return SearchShimmerViewWidget(showResultsStyle: !isInitial);
    }
    if (state.loadingStateStatus == StateStatus.error) {
      return Center(
        child: Text(
          state.errorMessage ?? AppLocalizations.of(context)!.labTestCatalogLoadFailed,
        ),
      );
    }
    if (state.isSubmitted && hasResults) {
      return SearchResultsSectionsWidget(
        sections: state.content.sections,
        query: query,
      );
    }
    if (state.isSubmitted && query.isNotEmpty) {
      return SearchEmptyResultsWidget(query: query);
    }
    if (hasSuggestions) {
      return SearchSuggestionsListWidget(
        query: query,
        suggestions: state.content.suggestions,
        onSuggestionTap: (v) => context.read<SearchCubit>().submitSearch(v),
      );
    }
    return SearchInitialContentWidget(
      recent: state.content.recentSearches,
      popular: state.content.popularSearches,
      onRecentTap: (t) => context.read<SearchCubit>().submitSearch(
        t,
        AnalyticsSearchMediumKeys.recent,
      ),
      onRemoveRecent: (t) => context.read<SearchCubit>().removeRecentSearch(t),
      onPopularTap: (v) => context.read<SearchCubit>().submitSearch(
        v,
        AnalyticsSearchMediumKeys.popular,
      ),
    );
  }
}
