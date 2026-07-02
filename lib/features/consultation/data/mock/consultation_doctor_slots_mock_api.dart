import '../../../../core/config/mock_config.dart';

class ConsultationDoctorSlotsMockApi {
  static bool useMockResponses = MockConfig.enableConsultationMocks;

  Future<Map<String, dynamic>> getDoctorSlotsSuccessResponse({
    required String doctorId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    return {
      'success': true,
      'message': 'Time slots retrieved',
      'code': 200,
      'data': [
        {
          'date': '2026-07-02',
          'slots': [
            {'start_time': '17:00', 'end_time': '17:30'},
            {'start_time': '17:30', 'end_time': '18:00'},
            {'start_time': '18:00', 'end_time': '18:30'},
            {'start_time': '18:30', 'end_time': '19:00'},
            {'start_time': '19:00', 'end_time': '19:30'},
            {'start_time': '19:30', 'end_time': '20:00'},
          ],
        },
        {
          'date': '2026-07-03',
          'slots': [
            {'start_time': '17:00', 'end_time': '17:30'},
            {'start_time': '17:30', 'end_time': '18:00'},
            {'start_time': '18:00', 'end_time': '18:30'},
            {'start_time': '18:30', 'end_time': '19:00'},
            {'start_time': '19:00', 'end_time': '19:30'},
            {'start_time': '19:30', 'end_time': '20:00'},
          ],
        },
        {
          'date': '2026-07-04',
          'slots': [
            {'start_time': '17:00', 'end_time': '17:30'},
            {'start_time': '17:30', 'end_time': '18:00'},
            {'start_time': '18:00', 'end_time': '18:30'},
          ],
        },
      ],
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };
  }
}
