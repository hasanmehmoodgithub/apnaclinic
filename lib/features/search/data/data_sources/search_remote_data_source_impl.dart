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

  @override
  Future<SearchResponseModel> getSearchContent({
    required String query,
    required bool listening,
    required bool submitted,
  }) async {
    try {
      final Map<String, dynamic> response;
      if (SearchMockApi.useMockResponses) {
        response = await mockApi.getSearchResponse(
          query: query,
          listening: listening,
          submitted: submitted,
        );
      } else {
        response = await apiService.get(
          AppUrls.search,
          queryParameters: {
            'query': query,
            'listening': listening,
            'submitted': submitted,
          },
        );
        log('getSearchContent response: $response');
      }

      if (response['success'] == true) {
        return SearchResponseModel.fromJson(response);
      }

      return Future.error((response['message'] ?? 'Failed to load search').toString());
    } catch (e) {
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.search,
      );
      return Future.error(message);
    }
  }
}
