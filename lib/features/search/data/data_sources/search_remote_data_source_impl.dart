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
    // Search API only after explicit submit (search button / enter / suggestion tap).
    if (trimmed.isEmpty || !submitted) {
      return const SearchResponseModel(
        success: true,
        message: '',
        recentSearches: [],
        popularSearches: [],
        suggestions: [],
        sections: [],
      );
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
}
