import '../../../../core/config/mock_config.dart';

class ConsultationBookingMockApi {
  static bool useMockResponses = MockConfig.enableConsultationMocks;

  Future<Map<String, dynamic>> submitBookingSuccessResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return {
      'success': true,
      'message': 'Consultation booked successfully',
      'code': 200,
      'data': {
        'bookingId': 'mock-booking-001',
      },
    };
  }

  Future<Map<String, dynamic>> submitFeedbackSuccessResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return {
      'success': true,
      'message': 'Feedback submitted successfully',
      'code': 200,
      'data': null,
    };
  }
}
