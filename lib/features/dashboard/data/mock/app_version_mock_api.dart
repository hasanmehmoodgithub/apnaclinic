import '../../../../core/config/mock_config.dart';

class AppVersionMockApi {
  static bool get useMockResponses => MockConfig.enableDashboardMocks;

  Future<Map<String, dynamic>> getAppVersionSuccessResponse({
    required String platform,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return {
      'success': true,
      'message': 'App version retrieved',
      'code': 200,
      'data': {
        'id': 2,
        'platform': platform,
        'minVersion': '1.0.0',
        'latestVersion': '2.0.0',
        'isForceUpgrade': true,
        'releaseNotes': 'test $platform',
        'isActive': true,
        'createdAt': '2026-07-13T19:16:45.000Z',
        'updatedAt': '2026-07-13T19:16:45.000Z',
      },
      'timestamp': '2026-07-13T14:16:36.930Z',
    };
  }
}
