import '../../../../core/config/mock_config.dart';
import '../../domain/use_cases/abandon_consultation_booking_use_case.dart';

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

  Future<Map<String, dynamic>> abandonBookingSuccessResponse(
    AbandonConsultationBookingParams params,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return {
      'success': true,
      'message': 'Order abandoned successfully',
      'code': 200,
      'data': {
        'order_id': params.orderId,
        'unified_order_id': params.unifiedOrderId,
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

  Future<Map<String, dynamic>> recordAiAssistantInteractionResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return {
      'success': true,
      'message': 'Interaction recorded',
      'data': null,
    };
  }
}
