import '../../../../core/config/mock_config.dart';

class AccountMockApi {
  static bool useMockResponses = MockConfig.enableMocks;

  Future<Map<String, dynamic>> getAccountsListResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return <String, dynamic>{
      'success': true,
      'message': 'Accounts fetched successfully',
      'accounts': <Map<String, dynamic>>[
        {'id': 'ACC-1001', 'number': '03001234567', 'isDefault': true},
        {'id': 'ACC-1002', 'number': '03112223334', 'isDefault': false},
        {'id': 'ACC-1003', 'number': '03224445556', 'isDefault': false},
      ],
    };
  }
}
