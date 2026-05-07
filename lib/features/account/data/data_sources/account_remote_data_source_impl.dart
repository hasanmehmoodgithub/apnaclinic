import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/utils/error_handler.dart';
import '../mock/account_mock_api.dart';
import '../models/account_item_model.dart';
import 'account_remote_data_source.dart';

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  AccountRemoteDataSourceImpl({
    required this.apiService,
    required this.mockApi,
  });

  final ApiService apiService;
  final AccountMockApi mockApi;

  @override
  Future<List<AccountItemModel>> getAccountsList() async {
    try {
      final Map<String, dynamic> response;
      if (AccountMockApi.useMockResponses) {
        response = await mockApi.getAccountsListResponse();
      } else {
        // TODO: Replace with real endpoint once available.
        response = await mockApi.getAccountsListResponse();
      }

      if (response['success'] == true) {
        final rawList = (response['accounts'] as List?) ?? const [];
        return rawList
            .whereType<Map>()
            .map((e) => AccountItemModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }

      return Future.error(
        (response['message'] ?? AppStrings.genericErrorMessage).toString(),
      );
    } catch (e) {
      return Future.error(ErrorHandler.handleExceptions(e));
    }
  }
}
