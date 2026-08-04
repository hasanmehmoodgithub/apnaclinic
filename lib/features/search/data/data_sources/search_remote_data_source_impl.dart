import 'dart:developer';

import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/utils/error_handler.dart';
import '../mock/search_mock_api.dart';
import '../models/search_response_model.dart';
import 'search_remote_data_source.dart';

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  SearchRemoteDataSourceImpl({
    required this.apiService,
    required this.mockApi,
  });

  final ApiService apiService;
  final SearchMockApi mockApi;

  static const int _defaultLimit = 5;

  @override
  Future<SearchResponseModel> getSearchContent({
    required String query,
    required bool listening,
    required bool submitted,
  }) async {
    final trimmed = query.trim();
    // Initial/cleared state loads popular searches only.
    if (trimmed.isEmpty || !submitted) {
      return _getPopularSearchContent();
    }

    try {
      final Map<String, dynamic> response;
      if (SearchMockApi.useMockResponses) {
        response = await mockApi.getSearchResponse(
          query: trimmed,
          listening: listening,
          submitted: submitted,
        );
      } else {
        final endpoint = AppUrls.mobileSearch(
          text: trimmed,
          limit: _defaultLimit,
        );
        response = await apiService.get(endpoint);
        log('getSearchContent response: $response');
      }

      if (response['success'] == true ||
          (response['code'] is num && (response['code'] as num).toInt() == 200)) {
        return SearchResponseModel.fromJson(response);
      }

      return Future.error(
        (response['message'] ?? 'Failed to load search').toString(),
      );
    } catch (e) {
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.search,
      );
      return Future.error(message);
    }
  }

  Future<SearchResponseModel> _getPopularSearchContent() async {
    try {
      final Map<String, dynamic> response;
      if (SearchMockApi.useMockResponses) {
        response = await mockApi.getPopularSearchesResponse();
      } else {
        response = await apiService.get(AppUrls.mobileSearchPopular);
        log('getPopularSearches response: $response');
      }

      if (response['success'] == true ||
          (response['code'] is num && (response['code'] as num).toInt() == 200)) {
        final raw = response['data'];
        final popular = (raw is List ? raw : const <dynamic>[])
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList(growable: false);
        return SearchResponseModel(
          success: true,
          message: (response['message'] ?? '').toString(),
          recentSearches: const [],
          popularSearches: popular,
          suggestions: const [],
          sections: const [],
        );
      }

      return const SearchResponseModel(
        success: true,
        message: '',
        recentSearches: [],
        popularSearches: [],
        suggestions: [],
        sections: [],
      );
    } catch (e) {
      log('getPopularSearches failed: $e');
      return const SearchResponseModel(
        success: true,
        message: '',
        recentSearches: [],
        popularSearches: [],
        suggestions: [],
        sections: [],
      );
    }
  }
}
