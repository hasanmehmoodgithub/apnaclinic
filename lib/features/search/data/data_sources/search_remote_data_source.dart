import '../models/search_response_model.dart';

abstract class SearchRemoteDataSource {
  Future<SearchResponseModel> getSearchContent({
    required String query,
    required bool listening,
    required bool submitted,
  });
}
